# Server Facade Design: Layered Architecture for HTTP and MCP

**Task:** KABSD-TSK-0117  
**Date:** 2026-01-08  
**Status:** Draft  
**Parent:** KABSD-FTR-0019 (Refactor kano-backlog-core + facades)

---

## Overview

This document defines a layered architecture for server facades that expose `kano-backlog-core` operations via HTTP (FastAPI) and MCP (Model Context Protocol) interfaces. Both facades share a common internal service layer, with cross-cutting concerns (authentication, rate limiting, logging, versioning) applied consistently.

**Design Goals:**
- Transport-agnostic core remains independent
- Facades are thin, stateless request→response adapters
- Cross-cutting concerns (auth, rate-limit, logging) are pluggable
- MCP and HTTP facades can evolve independently while sharing service layer
- Safe write policies prevent data corruption from remote/untrusted clients

---

## 1. Layered Architecture Diagram

```
┌────────────────────────────────────────────────────────────────┐
│                    EXTERNAL CLIENTS                             │
│                (Browser, CLI, MCP Client, SDK)                 │
└──────────────────┬─────────────────────┬──────────────────────┘

            HTTP Requests               MCP Requests
                  │                            │
                  ▼                            ▼
         ┌────────────────────┐    ┌──────────────────────┐
         │   HTTP Facade      │    │   MCP Facade Server  │
         │  (FastAPI routes)  │    │ (Model Context Proto)│
         ├────────────────────┤    ├──────────────────────┤
         │ • Route handlers   │    │ • Tool registry      │
         │ • Request parsing  │    │ • Tool handlers      │
         │ • OpenAPI schema   │    │ • Resource handlers  │
         └────────────────────┘    └──────────────────────┘
                  │                            │
                  └────────────┬───────────────┘
                               │
                               ▼
         ┌─────────────────────────────────────────┐
         │  Cross-Cutting Concerns (Middleware)    │
         ├─────────────────────────────────────────┤
         │ • Authentication (JWT, MCP auth frame)  │
         │ • Rate limiting & request throttling    │
         │ • Request/response logging (with redact)│
         │ • Error mapping & standardization       │
         │ • Request validation & schema check     │
         │ • Versioning (API version negotiation)  │
         │ • Metrics & observability               │
         └─────────────────────────────────────────┘
                               │
                               ▼
         ┌─────────────────────────────────────────┐
         │     Service Layer (Coordination)        │
         ├─────────────────────────────────────────┤
         │ • Operation orchestration               │
         │ • Config/context resolution             │
         │ • Transaction & rollback handling       │
         │ • Response formatting                   │
         │ • Error handling & recovery             │
         └─────────────────────────────────────────┘
                               │
                               ▼
         ┌─────────────────────────────────────────┐
         │     kano-backlog-core (SSOT)            │
         ├─────────────────────────────────────────┤
         │ • config (BacklogContext)               │
         │ • canonical (CanonicalStore)            │
         │ • derived (DerivedStore index)          │
         │ • state (StateMachine)                  │
         │ • audit (AuditLog)                      │
         │ • refs (RefResolver)                    │
         └─────────────────────────────────────────┘
                               │
                               ▼
         ┌─────────────────────────────────────────┐
         │      Storage Layer (Canonical SSOT)     │
         ├─────────────────────────────────────────┤
         │ • Markdown files (authoritative)        │
         │ • SQLite index (derived, rebuildable)   │
         │ • JSONL audit logs (append-only)        │
         └─────────────────────────────────────────┘
```

---

## 2. Request → Validate → Core → Response Flow

All requests follow this standardized sequence:

### Request Handling Pipeline

```
1. RECEIVE REQUEST
   │
   ├─→ Extract request context (user, auth token, trace ID)
   │
2. AUTHENTICATE & AUTHORIZE
   ├─→ Verify JWT token or MCP auth frame
   ├─→ Map subject (user/agent) to identity
   ├─→ Check permissions for operation
   └─→ Reject if not authorized (403 or MCP error)
   │
3. VALIDATE REQUEST
   ├─→ Parse and validate input data (Pydantic models)
   ├─→ Check schema compliance
   ├─→ Resolve item references (ID → UID)
   └─→ Reject if validation fails (422)
   │
4. CHECK RATE LIMITS
   ├─→ Look up rate bucket (user ID, endpoint, window)
   ├─→ Increment counter
   └─→ Reject if exceeded (429)
   │
5. RESOLVE CONTEXT
   ├─→ Load BacklogContext from config/env
   ├─→ Determine product root, sandbox, etc.
   └─→ Set up audit context (agent name, operation ID)
   │
6. CALL CORE LIBRARY
   ├─→ Instantiate store objects (CanonicalStore, DerivedStore, etc.)
   ├─→ Call appropriate core operation (read, write, transition, etc.)
   ├─→ Core may raise domain exceptions (ItemNotFoundError, ValidationError, etc.)
   │
7. HANDLE CORE EXCEPTIONS
   ├─→ Map domain errors to HTTP/MCP status codes
   ├─→ Format error message with context
   └─→ Log error (if unexpected)
   │
8. AUDIT OPERATION
   ├─→ Log file operation to _logs/agent_tools/tool_invocations.jsonl
   ├─→ Include: timestamp, agent, operation, path, tool, metadata
   │
9. FORMAT RESPONSE
   ├─→ Convert result to output format (JSON for HTTP, MCP format for tools)
   ├─→ Add metadata (request ID, timestamp, version)
   │
10. RETURN RESPONSE
    ├─→ HTTP: 200 with JSON body
    └─→ MCP: Tool result with structured content
```

---

## 3. Facade Adapters: HTTP vs MCP

### 3.1. HTTP Facade (FastAPI)

**Route Structure:**

```python
# Routes map directly to resource + action

# Items
POST   /api/v1/items              # Create item
GET    /api/v1/items/<item-id>    # Read item
PUT    /api/v1/items/<item-id>    # Update item
DELETE /api/v1/items/<item-id>    # Delete item (soft delete)
GET    /api/v1/items              # List items (with filters)

# State Transitions
POST   /api/v1/items/<item-id>/transitions  # Transition state
GET    /api/v1/items/<item-id>/transitions  # List valid transitions

# Worklog
POST   /api/v1/items/<item-id>/worklog     # Append entry
GET    /api/v1/items/<item-id>/worklog     # Read entries

# Index
POST   /api/v1/index/build        # Rebuild index
GET    /api/v1/index/query        # Query with filters

# References
GET    /api/v1/refs/resolve       # Resolve reference
GET    /api/v1/refs/parse         # Parse reference format

# Audit
GET    /api/v1/audit/operations   # List file operations
```

**Example HTTP Request/Response:**

```http
POST /api/v1/items/KABSD-TSK-0120/transitions HTTP/1.1
Host: localhost:8000
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
Content-Type: application/json
X-Request-ID: req_abc123
X-Agent: copilot

{
  "action": "start",
  "message": "Starting implementation",
  "force": false
}

HTTP/1.1 200 OK
Content-Type: application/json
X-Response-ID: req_abc123

{
  "id": "KABSD-TSK-0120",
  "uid": "019b9853-...",
  "state": "InProgress",
  "updated": "2026-01-08T12:34:56Z",
  "worklog": [
    "2026-01-08 12:34 [agent=copilot] Starting implementation"
  ]
}
```

### 3.2. MCP Facade (Model Context Protocol Server)

**Tool Registry:**

MCP exposes core operations as "tools" (like Claude function calling):

```json
{
  "tools": [
    {
      "name": "item_create",
      "description": "Create a new backlog item",
      "inputSchema": {
        "type": "object",
        "properties": {
          "type": {"type": "string", "enum": ["Epic", "Feature", "UserStory", "Task", "Bug"]},
          "title": {"type": "string"},
          "parent": {"type": "string"},
          "context": {"type": "string"}
        },
        "required": ["type", "title"]
      }
    },
    {
      "name": "item_read",
      "description": "Read a backlog item by ID",
      "inputSchema": {
        "type": "object",
        "properties": {
          "item_id": {"type": "string"}
        },
        "required": ["item_id"]
      }
    },
    {
      "name": "state_transition",
      "description": "Transition item state with validation",
      "inputSchema": {
        "type": "object",
        "properties": {
          "item_id": {"type": "string"},
          "action": {"type": "string", "enum": ["propose", "ready", "start", "review", "done", "block", "drop"]},
          "message": {"type": "string"},
          "force": {"type": "boolean", "default": false}
        },
        "required": ["item_id", "action"]
      }
    },
    {
      "name": "worklog_append",
      "description": "Append a worklog entry to an item",
      "inputSchema": {
        "type": "object",
        "properties": {
          "item_id": {"type": "string"},
          "message": {"type": "string"}
        },
        "required": ["item_id", "message"]
      }
    },
    {
      "name": "item_list",
      "description": "List items with filters",
      "inputSchema": {
        "type": "object",
        "properties": {
          "state": {"type": "string"},
          "type": {"type": "string"},
          "owner": {"type": "string"},
          "tags": {"type": "array", "items": {"type": "string"}}
        }
      }
    },
    {
      "name": "index_query",
      "description": "Query the derived index with filters",
      "inputSchema": {
        "type": "object",
        "properties": {
          "state": {"type": "string"},
          "type": {"type": "string"},
          "tag": {"type": "string"},
          "limit": {"type": "integer", "default": 100}
        }
      }
    },
    {
      "name": "ref_resolve",
      "description": "Resolve an item reference (ID, UID, or uidshort)",
      "inputSchema": {
        "type": "object",
        "properties": {
          "ref": {"type": "string"}
        },
        "required": ["ref"]
      }
    }
  ]
}
```

**Example MCP Tool Call:**

```json
{
  "jsonrpc": "2.0",
  "id": "msg_001",
  "method": "tools/call",
  "params": {
    "name": "state_transition",
    "arguments": {
      "item_id": "KABSD-TSK-0120",
      "action": "start",
      "message": "Starting implementation"
    }
  }
}
```

**Example MCP Response:**

```json
{
  "jsonrpc": "2.0",
  "id": "msg_001",
  "result": {
    "type": "tool_result",
    "content": [
      {
        "type": "text",
        "text": "Item KABSD-TSK-0120 transitioned to InProgress"
      },
      {
        "type": "text",
        "text": "{\"id\": \"KABSD-TSK-0120\", \"state\": \"InProgress\", \"updated\": \"2026-01-08T12:34:56Z\"}"
      }
    ]
  }
}
```

---

## 4. Cross-Cutting Concerns

### 4.1. Authentication

**Strategy:**

- **HTTP**: Bearer token (JWT) in `Authorization` header
  - Payload contains: `sub` (user ID), `role` (admin, agent, viewer), `exp` (expiration)
  - Issued by external auth service (OIDC, custom)
  - Validated on each request

- **MCP**: Auth frame in MCP handshake
  - Establish identity during connection setup
  - All messages in session inherit that identity
  - Refresh/rotate tokens per session timeout

**Implementation (HTTP Middleware):**

```python
@app.middleware("http")
async def authenticate(request: Request, call_next):
    auth_header = request.headers.get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        return JSONResponse({"detail": "Missing authorization"}, status_code=401)
    
    token = auth_header[7:]
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        request.state.user_id = payload["sub"]
        request.state.role = payload.get("role", "viewer")
    except jwt.InvalidTokenError:
        return JSONResponse({"detail": "Invalid token"}, status_code=401)
    
    response = await call_next(request)
    return response
```

### 4.2. Authorization

**Rules:**

| Operation | Required Role | Conditions |
|---|---|---|
| Read item | viewer | None |
| Create item | agent | Must have write sandbox or product |
| Update item | agent | Must be author or admin |
| Delete item | admin | Soft delete only (set state=Dropped) |
| Transition state | agent | Must pass Ready gate (unless admin) |
| Append worklog | agent | Must be author or admin |
| Rebuild index | admin | Resource-intensive operation |

**Implementation (Function-level):**

```python
def require_agent(request: Request):
    if request.state.role not in ["agent", "admin"]:
        raise HTTPException(status_code=403, detail="Insufficient permissions")

@app.post("/api/v1/items/{item_id}/transitions")
async def transition_item(
    item_id: str,
    request: Request,
    body: TransitionRequest
):
    require_agent(request)  # Raises 403 if not agent/admin
    # ... proceed with transition
```

### 4.3. Rate Limiting

**Strategy:**

- Per-user, per-endpoint, sliding window (1 minute)
- Read operations: 1000 req/min
- Write operations: 100 req/min
- Admin operations: 10 req/min

**Implementation (In-memory with optional Redis backend):**

```python
from slowapi import Limiter
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter

@app.get("/api/v1/items")
@limiter.limit("1000/minute")
async def list_items(request: Request):
    # ...
```

### 4.4. Logging and Redaction

**What to log:**

- Incoming request: URL, method, user ID, request ID
- Core operation: Name, inputs (redacted), duration
- Response: Status code, size, user ID
- Errors: Exception type, message, traceback (for internal errors)

**What to redact:**

- Authorization headers (tokens)
- Sensitive file paths
- Internal error details (expose only to logged-in users)
- Personal data (email, real names in logs)

**Implementation:**

```python
import logging
import json

logger = logging.getLogger(__name__)

def log_operation(operation_name: str, inputs: dict, agent: str, duration_ms: float):
    # Redact sensitive fields
    safe_inputs = {k: v for k, v in inputs.items() if k not in ["token", "password"]}
    
    logger.info(f"Operation: {operation_name} | Agent: {agent} | Duration: {duration_ms}ms",
                extra={
                    "operation": operation_name,
                    "agent": agent,
                    "duration_ms": duration_ms,
                    "inputs": json.dumps(safe_inputs)
                })
```

### 4.5. Error Mapping

**Core exceptions → HTTP status codes:**

| Core Exception | HTTP Status | MCP Error |
|---|---|---|
| `ItemNotFoundError` | 404 Not Found | `error_code: -1`, message: "Item not found" |
| `ValidationError` | 422 Unprocessable Entity | `error_code: -2`, details: validation errors |
| `InvalidTransitionError` | 409 Conflict | `error_code: -3`, message: "Cannot transition" |
| `PermissionError` | 403 Forbidden | `error_code: -4` |
| `ConfigError` | 500 Internal Server Error | `error_code: -5` |
| Generic Exception | 500 Internal Server Error | `error_code: -99` |

**Implementation:**

```python
from kano_backlog_core import ItemNotFoundError, ValidationError

@app.exception_handler(ItemNotFoundError)
async def handle_not_found(request: Request, exc: ItemNotFoundError):
    return JSONResponse(
        {"detail": str(exc), "error_code": "ITEM_NOT_FOUND"},
        status_code=404
    )

@app.exception_handler(ValidationError)
async def handle_validation_error(request: Request, exc: ValidationError):
    return JSONResponse(
        {"detail": "Validation failed", "errors": exc.errors()},
        status_code=422
    )
```

### 4.6. Versioning

**API versioning strategy:**

- URL path versioning: `/api/v1/`, `/api/v2/`
- Header versioning (optional): `X-API-Version: 1`
- Core library version in response: `X-Core-Version: 0.2.0`

**Compatibility rules:**

- Breaking changes require new major version
- Additive changes (new endpoints, new optional fields) within minor version
- Deprecation: 2-version grace period (v1 deprecated in v2, removed in v3)

**Example:**

```python
@app.get("/api/v1/items/{item_id}")
async def read_item_v1(item_id: str):
    # Old response format
    return {"id": item_id, "title": "...", "state": "..."}

@app.get("/api/v2/items/{item_id}")
async def read_item_v2(item_id: str):
    # New response format with additional fields
    return {
        "id": item_id,
        "uid": "...",
        "title": "...",
        "state": "...",
        "created": "2026-01-01",
        "updated": "2026-01-08"
    }
```

---

## 5. Service Layer (Coordination)

The service layer coordinates between facades and core library. It handles:

- **Context resolution**: Load `BacklogContext` from env/config
- **Store instantiation**: Create `CanonicalStore`, `DerivedStore`, etc.
- **Transaction handling**: Coordinate multiple core operations (if needed)
- **Response formatting**: Convert core results to facade-specific formats
- **Audit logging**: Call `AuditLog.log_file_operation()` for each write

**Example Service Class:**

```python
from pathlib import Path
from kano_backlog_core import (
    BacklogContext, CanonicalStore, DerivedStore,
    StateMachine, AuditLog
)

class BacklogService:
    """Service layer for backlog operations."""
    
    def __init__(self, context: BacklogContext):
        self.context = context
        self.canonical = CanonicalStore(context.product_root)
        self.derived = DerivedStore(context.backlog_root)
    
    def transition_item(self, item_id: str, action: str, agent: str, message: str = None):
        """Transition item state with audit logging."""
        # Resolve item path
        item_path = self._find_item(item_id)
        
        # Read from canonical store
        item = self.canonical.read(item_path)
        
        # Validate and transition
        if not StateMachine.can_transition(item.state, action):
            raise InvalidTransitionError(f"Cannot {action} from {item.state}")
        
        # Execute transition (modifies item in-place)
        updated_item = StateMachine.transition(item, action, agent, message)
        
        # Write back to canonical store
        self.canonical.write(updated_item)
        
        # Audit log
        AuditLog.log_file_operation(
            operation="update",
            path=item_path,
            tool="server_facade",
            agent=agent,
            metadata={"action": action, "item_id": item_id}
        )
        
        # Rebuild derived index (or incremental update)
        self.derived.build(self.canonical, incremental=True)
        
        return updated_item
    
    def _find_item(self, item_id: str) -> Path:
        """Resolve item ID to file path."""
        # Bucket-based path: items/{type}/{bucket}/{id}_{slug}.md
        # For now, simple filename search; could use index
        # ...
```

---

## 6. MVP Endpoints/Tools

### HTTP Endpoints (FastAPI)

```
GET  /api/v1/health                     # Health check
POST /api/v1/items                      # Create
GET  /api/v1/items/{item-id}            # Read
PUT  /api/v1/items/{item-id}            # Update (partial)
GET  /api/v1/items                      # List with filters
POST /api/v1/items/{item-id}/transitions # Transition state
GET  /api/v1/items/{item-id}/worklog    # Read worklog
POST /api/v1/items/{item-id}/worklog    # Append worklog
GET  /api/v1/refs/resolve               # Resolve reference
POST /api/v1/index/build                # Rebuild index
```

### MCP Tools (Model Context Protocol)

```
item_create          # Create a new item
item_read            # Read an item
item_update          # Update an item
item_list            # List items with filters
state_transition     # Transition state
worklog_append       # Append worklog entry
worklog_read         # Read worklog entries
ref_resolve          # Resolve an item reference
index_query          # Query the derived index
```

---

## 7. Configuration and Safe Write Policies

### Configuration Propagation

Server reads configuration from (in order):

1. Environment variables (`KANO_BACKLOG_ROOT`, `KANO_PRODUCT`)
2. Config file (`/etc/kano/config.toml` or `~/.kano/config.toml`)
3. Defaults from `_shared/defaults.json`

**Example `/etc/kano/config.toml`:**

```toml
[backlog]
backlog_root = "/data/_kano/backlog"
product = "kano-agent-backlog-skill"
sandbox = null  # null = use product root, "name" = use sandbox

[server]
host = "0.0.0.0"
port = 8000
auth_enabled = true
rate_limit_enabled = true

[logging]
level = "INFO"
format = "json"  # or "text"
redact_sensitive = true
```

### Safe Write Policies

**Read operations**: Always allowed (if authenticated)

**Write operations** (create, update, delete, transition):

- **Local dev mode** (socket-based):
  - No auth required
  - No sandbox restrictions
  - Logging enabled for audit

- **Container/remote mode** (HTTP/MCP):
  - Require authentication
  - Restrict writes to assigned sandbox or product
  - Enforce Ready gate validation (no `--force` unless admin)
  - Require explicit `--confirm` flag for destructive ops (delete, hard reset)
  - Log all write operations with full metadata

**Sandbox enforcement:**

```python
def validate_write_access(user: User, target_path: Path, context: BacklogContext):
    """Ensure user can write to target."""
    if user.role == "admin":
        return True  # Admins can write anywhere
    
    if context.is_sandbox:
        # User must be sandbox owner or authorized
        sandbox_owner = read_sandbox_metadata(context.sandbox_root)["owner"]
        if user.id != sandbox_owner and user.id not in sandbox_owner.collaborators:
            raise PermissionError(f"Cannot write to sandbox {context.sandbox_root}")
    
    return True
```

---

## 8. Implementation Roadmap

### MVP (v0.2) - Minimal HTTP API

**Goal**: Expose core read operations + state transitions

- HTTP server (FastAPI, running on localhost:8000)
- Auth: None (local dev only)
- Endpoints: item_read, item_list, state_transition, worklog_append
- Output: JSON only
- No rate limiting, no advanced logging

**Example MVP startup:**

```python
# kano_server/main.py
from fastapi import FastAPI
from kano_server.routes import items, state, worklog

app = FastAPI(title="kano-backlog-server", version="0.2.0")
app.include_router(items.router, prefix="/api/v1")
app.include_router(state.router, prefix="/api/v1")
app.include_router(worklog.router, prefix="/api/v1")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
```

### Phase 1 (v0.3) - Full HTTP API + Auth

- All 10 MVP endpoints implemented
- JWT authentication
- Authorization checks (role-based)
- Error mapping with proper status codes
- Comprehensive logging

### Phase 2 (v0.4) - MCP Server

- MCP server running alongside HTTP
- Tool registry with all operations
- Error handling in MCP format
- Authentication via MCP auth frame

### Phase 3 (v1.0) - Production Hardening

- Rate limiting
- Advanced logging with redaction
- Metrics/observability (Prometheus)
- Request tracing (OpenTelemetry)
- Config file support
- Sandbox isolation enforcement

---

## 9. Testing Strategy

### Unit Tests

Test individual route handlers and service methods in isolation:

```python
def test_transition_state_http():
    """Test state transition via HTTP."""
    client = TestClient(app)
    
    # Create test item
    response = client.post("/api/v1/items", json={
        "type": "Task",
        "title": "Test task",
        "context": "Context",
        "goal": "Goal",
        "approach": "Approach",
        "acceptance_criteria": "Criteria",
        "risks": "Risks"
    })
    item_id = response.json()["id"]
    
    # Transition to InProgress
    response = client.post(
        f"/api/v1/items/{item_id}/transitions",
        json={"action": "start", "message": "Starting"}
    )
    assert response.status_code == 200
    assert response.json()["state"] == "InProgress"
```

### Integration Tests

Test full request flow with real files:

```python
def test_transition_state_integration(tmp_path):
    """Test state transition with real backlog files."""
    context = setup_test_backlog(tmp_path)
    service = BacklogService(context)
    
    # Create item
    item = create_test_item(tmp_path)
    
    # Transition via service
    updated = service.transition_item(
        item.id, "start", agent="test_agent", message="Starting"
    )
    assert updated.state == "InProgress"
    
    # Verify written to file
    canonical = CanonicalStore(context.product_root)
    reloaded = canonical.read(item.file_path)
    assert reloaded.state == "InProgress"
    assert any("Starting" in entry for entry in reloaded.worklog)
```

### Acceptance Tests

End-to-end HTTP client tests:

```python
def test_full_workflow_http():
    """Test complete workflow: create → ready → start → done."""
    client = TestClient(app)
    
    # 1. Create
    response = client.post("/api/v1/items", json={...})
    item_id = response.json()["id"]
    
    # 2. Transition to Ready
    response = client.post(f"/api/v1/items/{item_id}/transitions",
                           json={"action": "ready"})
    assert response.status_code == 200
    
    # 3. Append worklog
    response = client.post(f"/api/v1/items/{item_id}/worklog",
                           json={"message": "Started work"})
    assert response.status_code == 200
    
    # 4. Transition to InProgress
    response = client.post(f"/api/v1/items/{item_id}/transitions",
                           json={"action": "start"})
    assert response.status_code == 200
    
    # 5. Done
    response = client.post(f"/api/v1/items/{item_id}/transitions",
                           json={"action": "done", "message": "Completed"})
    assert response.status_code == 200
    assert response.json()["state"] == "Done"
```

---

## 10. Monitoring and Observability

### Metrics to Track

- Request volume (by endpoint, by user, by status code)
- Request latency (p50, p95, p99)
- Error rate (by error type)
- Rate limit hit count
- Core library call duration (by operation)
- File I/O duration

### Logging Levels

- **DEBUG**: Request/response bodies, full SQL queries, cache hits/misses
- **INFO**: API requests, state transitions, auth events, index rebuilds
- **WARN**: Rate limit hits, deprecated API usage, missing config
- **ERROR**: Unexpected exceptions, invalid data, core library errors

### Health Checks

```
GET /api/v1/health
```

Returns:

```json
{
  "status": "ok",
  "timestamp": "2026-01-08T12:34:56Z",
  "core_version": "0.2.0",
  "index_status": "valid",
  "last_index_build": "2026-01-08T12:00:00Z",
  "database_connected": true
}
```

---

## 11. Acceptance Criteria

- ✅ Layered architecture diagram with 3+ layers documented
- ✅ Request→validate→core→response sequence defined
- ✅ HTTP and MCP facade designs mapped to core operations
- ✅ Cross-cutting concerns (auth, rate-limit, logging, errors) placement specified
- ✅ MVP endpoint/tool list (10+ endpoints/tools) documented
- ✅ Configuration loading strategy defined
- ✅ Safe write policies for local/remote modes specified
- ✅ Testing strategy (unit, integration, acceptance) outlined
- ✅ Error mapping table (core exceptions → HTTP/MCP codes)
- ✅ Service layer design with orchestration pattern shown

---

## 12. Implementation Framework Choice

**Recommendation: FastAPI (HTTP) + Official MCP Server SDK (MCP)**

**Rationale:**

| Framework | Reason |
|---|---|
| FastAPI | Async-first, Pydantic integration, auto-generated OpenAPI, modern Python |
| MCP SDK | Official protocol implementation, handles versioning, steady development |

**Why not Flask?** Too minimal; need async support and Pydantic integration.  
**Why not Django?** Too heavy; adds ORM and admin interfaces we don't need.  
**Why not FastRPC?** Emerging tool; FastAPI is more mature and widely adopted.

---

## 13. Key Design Decisions

| Decision | Rationale |
|---|---|
| Thin facades | Core remains transport-agnostic and testable |
| Shared service layer | DRY principle; HTTP and MCP use same business logic |
| JWT auth (HTTP) + MCP auth frame | Standard approaches for each transport |
| Per-user rate limiting | Prevents resource exhaustion; fair for multi-user |
| Request ID propagation | Enables tracing across logs and audit trails |
| Safe write policies for remote | Prevents data corruption from untrusted clients |
| Sandbox isolation | Enables multi-tenant scenarios |
| Incremental index rebuild | Faster performance on large backlogs |

---

## 14. Open Questions & Future Considerations

1. **WebSocket support**: Should we support WebSocket for long-polling or real-time updates?
   - *Recommendation: Defer to v1.1; HTTP + MCP sufficient for MVP*

2. **GraphQL endpoint**: Would GraphQL be useful for complex queries?
   - *Recommendation: Defer; JSON REST is simpler and sufficient*

3. **Database backend**: Support PostgreSQL/MySQL in addition to SQLite?
   - *Recommendation: Defer to v1.0; SQLite sufficient for local dev and small deployments*

4. **Caching layer**: Add Redis caching for frequently accessed items?
   - *Recommendation: Defer to v1.0; filesystem cache sufficient initially*

5. **Batch operations**: Support batch create/update/delete?
   - *Recommendation: Design in v0.4; implement in v0.5*

---

## Summary

This facade design provides a clean separation of concerns:

- **HTTP & MCP facades** are thin adapters (arg parsing, output formatting)
- **Service layer** orchestrates core operations and audit logging
- **Core library** remains transport-agnostic and testable
- **Cross-cutting concerns** (auth, rate-limit, logging) are pluggable middleware
- **Safe write policies** prevent data corruption in remote scenarios

The layered approach allows independent evolution of HTTP and MCP facades while maintaining a shared, tested core library.

