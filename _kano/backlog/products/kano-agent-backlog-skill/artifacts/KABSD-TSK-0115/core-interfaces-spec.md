# Core Interfaces and Module Boundaries

**Version:** 0.1.0  
**Task:** KABSD-TSK-0115  
**Date:** 2026-01-07  
**Status:** Draft

## Overview

This document defines the interface contracts and module boundaries for `kano-backlog-core`, a transport-agnostic domain library that encapsulates all backlog business logic. The core library exposes stable Python interfaces that can be consumed by multiple facades (CLI, HTTP API, MCP server, GUI).

**Design Principles:**
- **Transport-agnostic**: Core knows nothing about HTTP, stdio, or GUI concerns
- **Single Source of Truth**: Canonical markdown files are SSOT; all derived data is rebuildable
- **Auditability**: All mutations logged with timestamp and agent attribution
- **Type safety**: Strong typing with Pydantic models and typed exceptions
- **Dependency injection**: Storage backends, config sources are pluggable

---

## Module Map

```
kano-backlog-core/
├── config/           # Context resolution (product/sandbox/repo roots)
├── canonical/        # Markdown SSOT (read/write/validate items)
├── derived/          # Index abstraction (SQLite/Postgres/MySQL)
├── refs/             # Reference parsing and resolution (id/uid/uidshort)
├── state/            # State machine (transitions, ready gate)
├── audit/            # Worklog and operation logging
├── workset/          # Per-agent cache/working memory
├── errors/           # Typed exception taxonomy
└── service/          # Internal service layer (optional coordinator)
```

---

## 1. Config Module

**Purpose:** Resolve project/product/sandbox roots and load configuration.

### Interfaces

```python
from pathlib import Path
from typing import Optional
from pydantic import BaseModel

class BacklogContext(BaseModel):
    """Resolved backlog context with platform and product roots."""
    project_root: Path      # e.g., D:/_work/_Kano/kano-agent-backlog-skill-demo
    backlog_root: Path       # e.g., project_root / _kano/backlog
    product_root: Path       # e.g., backlog_root / products / kano-agent-backlog-skill
    sandbox_root: Optional[Path]  # e.g., backlog_root / sandboxes / <sandbox-name>
    product_name: str        # e.g., "kano-agent-backlog-skill"
    is_sandbox: bool         # True if operating in sandbox mode

class ConfigLoader:
    """Load and resolve backlog configuration."""
    
    @staticmethod
    def from_path(resource_path: Path, product: Optional[str] = None, sandbox: Optional[str] = None) -> BacklogContext:
        """
        Resolve backlog context from a file/folder path.
        
        Args:
            resource_path: Starting path (file or directory)
            product: Product name (optional, can be inferred)
            sandbox: Sandbox name (optional, for isolated operations)
            
        Returns:
            BacklogContext with resolved roots
            
        Raises:
            ConfigError: If project/product root cannot be determined
        """
        pass
    
    @staticmethod
    def load_defaults(backlog_root: Path) -> dict:
        """Load default configuration from _kano/backlog/_shared/defaults.json"""
        pass
```

**Invariants:**
- `backlog_root` must contain `_index/`, `_shared/`, `products/` directories
- `product_root` must exist if `product_name` is specified
- `sandbox_root` is always under `backlog_root/sandboxes/` if present

---

## 2. Canonical Module

**Purpose:** Read, write, and validate canonical markdown items (SSOT).

### Interfaces

```python
from pathlib import Path
from typing import Optional, Dict, Any
from pydantic import BaseModel
from enum import Enum

class ItemType(str, Enum):
    EPIC = "Epic"
    FEATURE = "Feature"
    USER_STORY = "UserStory"
    TASK = "Task"
    BUG = "Bug"

class ItemState(str, Enum):
    NEW = "New"
    PROPOSED = "Proposed"
    READY = "Ready"
    IN_PROGRESS = "InProgress"
    REVIEW = "Review"
    DONE = "Done"
    BLOCKED = "Blocked"
    DROPPED = "Dropped"

class BacklogItem(BaseModel):
    """Parsed backlog item with frontmatter and body."""
    id: str                  # Display ID (e.g., KABSD-TSK-0115)
    uid: str                 # UUIDv7 (immutable primary key)
    type: ItemType
    title: str
    state: ItemState
    priority: Optional[str]  # P0, P1, P2, P3
    parent: Optional[str]    # Parent display ID
    owner: Optional[str]     # Agent or user name
    tags: list[str]
    created: str             # ISO date
    updated: str             # ISO date
    area: Optional[str]
    iteration: Optional[str]
    external: Dict[str, Any]
    links: Dict[str, list[str]]
    decisions: list[str]
    
    # Body sections
    context: Optional[str]
    goal: Optional[str]
    non_goals: Optional[str]
    approach: Optional[str]
    alternatives: Optional[str]
    acceptance_criteria: Optional[str]
    risks: Optional[str]
    worklog: list[str]       # Parsed worklog entries
    
    # Metadata
    file_path: Path          # Absolute path to .md file

class CanonicalStore:
    """Read and write canonical markdown items."""
    
    def __init__(self, product_root: Path):
        self.product_root = product_root
        self.items_root = product_root / "items"
    
    def read(self, item_path: Path) -> BacklogItem:
        """
        Parse a markdown item from file.
        
        Raises:
            ItemNotFoundError: If file does not exist
            ParseError: If frontmatter is invalid
        """
        pass
    
    def write(self, item: BacklogItem) -> None:
        """
        Write item to file, preserving frontmatter and body structure.
        
        Raises:
            ValidationError: If item data is invalid
            WriteError: If file write fails
        """
        pass
    
    def create(self, item_type: ItemType, title: str, parent: Optional[str] = None, **kwargs) -> BacklogItem:
        """
        Create a new item with auto-generated id, uid, and file path.
        
        Returns:
            BacklogItem ready to be written
        """
        pass
    
    def list_items(self, item_type: Optional[ItemType] = None) -> list[Path]:
        """List all item files, optionally filtered by type."""
        pass
    
    def validate_schema(self, item: BacklogItem) -> list[str]:
        """
        Validate item against schema.
        
        Returns:
            List of validation errors (empty if valid)
        """
        pass
```

**Invariants:**
- All items must have unique `uid` (enforced at creation)
- `id` format: `{project}-{type_abbrev}-{number}` (e.g., KABSD-TSK-0115)
- Files stored under `items/{type_plural}/{bucket}/` where bucket = `(number // 100) * 100`
- Filename: `{id}_{slug}.md` (slug is stable, derived from title at creation)
- `updated` timestamp auto-refreshed on write
- Frontmatter must be valid YAML between `---` delimiters

---

## 3. Derived Module

**Purpose:** Abstract interface for derived indexes (SQLite, Postgres, MySQL).

### Interfaces

```python
from abc import ABC, abstractmethod
from typing import Optional, List
from enum import Enum

class IndexBackend(str, Enum):
    SQLITE = "sqlite"
    POSTGRES = "postgres"
    MYSQL = "mysql"

class DerivedStore(ABC):
    """Abstract interface for derived/rebuildable indexes."""
    
    @abstractmethod
    def build(self, canonical: CanonicalStore, incremental: bool = False) -> None:
        """
        Build or rebuild index from canonical store.
        
        Args:
            canonical: Source of truth
            incremental: If True, update only changed items; else full rebuild
        """
        pass
    
    @abstractmethod
    def get_by_uid(self, uid: str) -> Optional[BacklogItem]:
        """Retrieve item by UID (fastest lookup)."""
        pass
    
    @abstractmethod
    def get_by_id(self, display_id: str) -> List[BacklogItem]:
        """Retrieve items by display ID (may return multiple if collisions exist)."""
        pass
    
    @abstractmethod
    def get_by_uidshort(self, uidshort: str) -> List[BacklogItem]:
        """Retrieve items by uidshort prefix (8 hex chars)."""
        pass
    
    @abstractmethod
    def query(self, filters: Dict[str, Any]) -> List[BacklogItem]:
        """
        Query items with filters (state, type, tags, etc.).
        
        Example:
            query({"state": "InProgress", "type": "Task"})
        """
        pass
    
    @abstractmethod
    def get_version(self) -> int:
        """Get current schema version."""
        pass
    
    @abstractmethod
    def migrate(self, target_version: int) -> None:
        """Apply migrations to reach target schema version."""
        pass

class SQLiteIndex(DerivedStore):
    """SQLite implementation of derived index."""
    def __init__(self, db_path: Path): ...

class PostgresIndex(DerivedStore):
    """PostgreSQL implementation (future)."""
    def __init__(self, connection_string: str): ...
```

**Invariants:**
- Derived data is **always rebuildable** from canonical store
- Index must not be treated as SSOT
- UID lookups must return at most one item (uniqueness)
- Display ID lookups may return multiple items (collision support)

---

## 4. Refs Module

**Purpose:** Parse and resolve item references (display ID, UID, uidshort).

### Interfaces

```python
from typing import Union, List
from pydantic import BaseModel

class RefFormat(str, Enum):
    FULL_UID = "full_uid"           # 019473f2-79b0-7cc3-98c4-dc0c0c07398f
    UIDSHORT = "uidshort"           # 019473f2
    DISPLAY_ID = "display_id"       # KABSD-TSK-0115
    ID_AT_UIDSHORT = "id@uidshort"  # KABSD-TSK-0115@019473f2

class ResolveResult(BaseModel):
    """Result of reference resolution."""
    matches: List[BacklogItem]
    exact: bool              # True if single unambiguous match
    format: RefFormat        # Detected reference format
    error: Optional[str]     # Error message if resolution failed

class RefResolver:
    """Parse and resolve item references."""
    
    def __init__(self, index: DerivedStore):
        self.index = index
    
    def parse(self, ref: str) -> RefFormat:
        """Detect reference format."""
        pass
    
    def resolve(self, ref: str, interactive: bool = False) -> ResolveResult:
        """
        Resolve reference to one or more items.
        
        Args:
            ref: Reference string
            interactive: If True and ambiguous, prompt user for selection (CLI only)
            
        Returns:
            ResolveResult with matches and metadata
        """
        pass
    
    def format_uidshort(self, uid: str) -> str:
        """Extract uidshort (first 8 hex chars) from full UID."""
        return uid.replace("-", "")[:8]
```

**Invariants:**
- Full UID always resolves to exactly one item or none
- uidshort may resolve to multiple items (prefix match)
- Display ID may resolve to multiple items (collision support)
- `id@uidshort` format disambiguates collisions

---

## 5. State Module

**Purpose:** Enforce state transitions and Ready gate validation.

### Interfaces

```python
from typing import Optional, List, Callable

class StateTransition(BaseModel):
    """Metadata for a state transition."""
    from_state: ItemState
    to_state: ItemState
    action: str              # "start", "done", "block", etc.
    preconditions: List[Callable[[BacklogItem], bool]]
    side_effects: List[Callable[[BacklogItem], None]]

class StateMachine:
    """Enforce state transitions and business rules."""
    
    def __init__(self):
        self.transitions: Dict[str, StateTransition] = self._build_transitions()
    
    def can_transition(self, item: BacklogItem, action: str) -> tuple[bool, Optional[str]]:
        """
        Check if transition is valid.
        
        Returns:
            (allowed, error_message)
        """
        pass
    
    def transition(self, item: BacklogItem, action: str, agent: str, message: Optional[str] = None) -> BacklogItem:
        """
        Execute state transition with side effects (worklog entry, parent sync, etc.).
        
        Raises:
            InvalidTransitionError: If transition is not allowed
        """
        pass
    
    def validate_ready(self, item: BacklogItem) -> List[str]:
        """
        Validate Ready gate for Task/Bug items.
        
        Returns:
            List of validation errors (empty if Ready)
            
        Required sections:
            - Context (non-empty)
            - Goal (non-empty)
            - Approach (non-empty)
            - Acceptance Criteria (non-empty)
            - Risks / Dependencies (non-empty)
        """
        pass

class ReadyValidator:
    """Standalone Ready gate validator."""
    
    @staticmethod
    def check(item: BacklogItem) -> tuple[bool, List[str]]:
        """
        Check if item passes Ready gate.
        
        Returns:
            (is_ready, errors)
        """
        pass
```

**Invariants:**
- Only valid transitions are allowed (enforced by StateMachine)
- Ready gate required before Task/Bug can move to InProgress
- Every transition appends a worklog entry
- Parent items auto-sync when child state changes (configurable)

---

## 6. Audit Module

**Purpose:** Maintain append-only audit trails (worklog, file operations).

### Interfaces

```python
from datetime import datetime
from typing import Literal

class WorklogEntry(BaseModel):
    """Single worklog entry."""
    timestamp: datetime
    agent: str
    message: str
    
    def format(self) -> str:
        """Format as: 2026-01-07 19:59 [agent=copilot] Message"""
        return f"{self.timestamp:%Y-%m-%d %H:%M} [agent={self.agent}] {self.message}"

class AuditLog:
    """Manage worklog and file operation logs."""
    
    @staticmethod
    def append_worklog(item: BacklogItem, agent: str, message: str) -> None:
        """Add worklog entry to item (modifies in-place)."""
        pass
    
    @staticmethod
    def log_file_operation(
        operation: Literal["create", "update", "delete", "move"],
        path: Path,
        agent: str,
        details: Optional[Dict[str, Any]] = None
    ) -> None:
        """
        Log file operation to JSONL audit trail.
        
        File: _kano/backlog/_logs/agent_tools/tool_invocations.jsonl
        """
        pass
    
    @staticmethod
    def parse_worklog(worklog_text: str) -> List[WorklogEntry]:
        """Parse worklog section into structured entries."""
        pass
```

**Invariants:**
- Worklog is append-only (never rewrite history)
- All state transitions must generate a worklog entry
- File operations logged to JSONL for audit trail
- Timestamps in ISO format with agent attribution

---

## 7. Workset Module

**Purpose:** Per-agent cache/working memory abstraction (future: workset feature).

### Interfaces

```python
class Workset:
    """Per-agent working memory (sandbox-like cache for active tasks)."""
    
    def __init__(self, agent: str, backlog_root: Path):
        self.agent = agent
        self.workset_root = backlog_root / "sandboxes" / f"workset_{agent}"
    
    def create(self, item: BacklogItem) -> Path:
        """Create workset entry for item (copy or reference)."""
        pass
    
    def promote(self, item_path: Path) -> BacklogItem:
        """Promote workset item back to canonical store."""
        pass
    
    def list_active(self) -> List[Path]:
        """List all items in this agent's workset."""
        pass
```

**Invariants:**
- Workset is a cache; canonical store is still SSOT
- Promote operation must validate and merge changes
- Workset lifecycle is agent-scoped

---

## 8. Errors Module

**Purpose:** Typed exception taxonomy for precise error handling.

### Exception Hierarchy

```python
class BacklogError(Exception):
    """Base exception for all backlog errors."""
    pass

# Config errors
class ConfigError(BacklogError):
    """Failed to resolve backlog context or load configuration."""
    pass

# Canonical store errors
class ItemNotFoundError(BacklogError):
    """Item file not found."""
    def __init__(self, path: Path): ...

class ParseError(BacklogError):
    """Failed to parse item frontmatter or body."""
    def __init__(self, path: Path, details: str): ...

class ValidationError(BacklogError):
    """Item data failed schema validation."""
    def __init__(self, errors: List[str]): ...

class WriteError(BacklogError):
    """Failed to write item to file."""
    pass

# State machine errors
class InvalidTransitionError(BacklogError):
    """State transition not allowed."""
    def __init__(self, from_state: str, to_state: str, reason: str): ...

class ReadyGateError(BacklogError):
    """Item failed Ready gate validation."""
    def __init__(self, errors: List[str]): ...

# Ref resolution errors
class RefNotFoundError(BacklogError):
    """Reference could not be resolved."""
    def __init__(self, ref: str): ...

class AmbiguousRefError(BacklogError):
    """Reference matched multiple items."""
    def __init__(self, ref: str, matches: List[str]): ...

# Index errors
class IndexError(BacklogError):
    """Derived index operation failed."""
    pass

class MigrationError(IndexError):
    """Schema migration failed."""
    def __init__(self, current_version: int, target_version: int, details: str): ...
```

---

## 9. Service Layer (Optional)

**Purpose:** Internal coordinator that orchestrates modules; facades call this instead of raw modules.

### Interfaces

```python
class BacklogService:
    """High-level service API orchestrating core modules."""
    
    def __init__(self, context: BacklogContext, index: DerivedStore):
        self.context = context
        self.canonical = CanonicalStore(context.product_root)
        self.index = index
        self.refs = RefResolver(index)
        self.state_machine = StateMachine()
    
    # Item operations
    def create_item(self, item_type: ItemType, title: str, parent: Optional[str], agent: str, **kwargs) -> BacklogItem:
        """Create and persist new item."""
        item = self.canonical.create(item_type, title, parent, **kwargs)
        AuditLog.append_worklog(item, agent, "Created from template.")
        self.canonical.write(item)
        self.index.build(self.canonical, incremental=True)
        return item
    
    def transition_item(self, item_path: Path, action: str, agent: str, message: Optional[str] = None) -> BacklogItem:
        """Execute state transition and update index."""
        item = self.canonical.read(item_path)
        item = self.state_machine.transition(item, action, agent, message)
        self.canonical.write(item)
        self.index.build(self.canonical, incremental=True)
        return item
    
    def validate_ready(self, item_path: Path) -> tuple[bool, List[str]]:
        """Validate Ready gate."""
        item = self.canonical.read(item_path)
        errors = self.state_machine.validate_ready(item)
        return (len(errors) == 0, errors)
    
    def resolve_ref(self, ref: str) -> ResolveResult:
        """Resolve item reference."""
        return self.refs.resolve(ref)
    
    # Query operations
    def query_items(self, filters: Dict[str, Any]) -> List[BacklogItem]:
        """Query items via index."""
        return self.index.query(filters)
    
    def get_item(self, ref: str) -> BacklogItem:
        """
        Get single item by reference.
        
        Raises:
            RefNotFoundError: If not found
            AmbiguousRefError: If multiple matches
        """
        result = self.refs.resolve(ref)
        if not result.exact or len(result.matches) != 1:
            raise AmbiguousRefError(ref, [m.id for m in result.matches])
        return result.matches[0]
```

---

## Invariants Summary

1. **SSOT Principle**: Canonical markdown files are the single source of truth; derived indexes are always rebuildable.
2. **Auditability**: All mutations logged with timestamp and agent; worklog is append-only.
3. **Type Safety**: Pydantic models enforce schema; typed exceptions for precise error handling.
4. **Transport Agnostic**: Core has zero knowledge of HTTP, stdio, MCP, or GUI concerns.
5. **Rebuildability**: Derived indexes can be fully reconstructed from canonical store at any time.
6. **Uniqueness**: UIDs are globally unique; display IDs may collide (resolved via uidshort).
7. **State Discipline**: Only valid transitions allowed; Ready gate enforced for Task/Bug before InProgress.
8. **Schema Stability**: Frontmatter schema versioned; migrations applied via numbered SQL scripts.

---

## Example Call Flow

**Use case:** Create a new Task and transition it to InProgress.

```python
# 1. Initialize service
context = ConfigLoader.from_path(Path("/path/to/workspace"), product="kano-agent-backlog-skill")
index = SQLiteIndex(context.backlog_root / "_index" / "backlog.sqlite3")
service = BacklogService(context, index)

# 2. Create Task
item = service.create_item(
    item_type=ItemType.TASK,
    title="Implement SQLite migration runner",
    parent="KABSD-FTR-0019",
    agent="copilot",
    priority="P1",
    tags=["core", "indexing"]
)
print(f"Created: {item.id} at {item.file_path}")

# 3. Fill Ready sections (manual edit or programmatic)
item.context = "We need a migration framework for schema evolution."
item.goal = "Implement get_current_version() and apply_migrations()."
item.approach = "Version table + numbered SQL scripts in references/migrations/."
item.acceptance_criteria = "- v0 to v1 upgrade tested\n- Backward compatibility verified"
item.risks = "Breaking changes if not careful with schema."

# 4. Validate Ready gate
is_ready, errors = service.validate_ready(item.file_path)
if not is_ready:
    raise ReadyGateError(errors)

# 5. Start work
item = service.transition_item(item.file_path, action="start", agent="copilot")
print(f"State: {item.state}")  # InProgress

# 6. Complete work
item = service.transition_item(
    item.file_path,
    action="done",
    agent="copilot",
    message="Migration framework implemented and tested."
)
print(f"State: {item.state}")  # Done
```

**No transport code involved** - this flow runs entirely within the core library.

---

## Facade Responsibilities

Facades (CLI/HTTP/MCP/GUI) handle:
- **Argument parsing**: Convert CLI flags/HTTP params/MCP requests to core API calls
- **Authentication/Authorization**: Verify identity before delegating to core
- **Response formatting**: Transform core results to JSON/text/HTML
- **Error translation**: Map core exceptions to HTTP status codes/CLI exit codes
- **Concurrency**: Manage async/await or threading (core is sync)
- **Logging**: Request/response logging (distinct from audit trail)

**Core does NOT handle:**
- HTTP routing, request parsing, or status codes
- stdio buffering, ANSI colors, or terminal interaction
- MCP protocol framing or JSON-RPC
- GUI event loops, widget rendering, or windowing

---

## Dependency Injection Seams

Key injection points for testing and flexibility:

1. **Storage backend**: `DerivedStore` interface allows swapping SQLite/Postgres/MySQL
2. **Config source**: `ConfigLoader` can load from env vars, JSON, or hardcoded values
3. **Audit sink**: `AuditLog` can write to file, database, or mock
4. **Workset strategy**: Optional; can be disabled entirely
5. **UID generator**: Injectable for deterministic testing (default: UUIDv7)

---

## Next Steps

1. Implement skeleton classes with type stubs (no logic)
2. Write unit tests for each module interface
3. Implement `CanonicalStore` and `SQLiteIndex` (highest priority)
4. Build `BacklogService` orchestrator
5. Create facade examples (CLI, HTTP) consuming `BacklogService`

---

## References

- `skills/kano-agent-backlog-skill/references/schema.md` - Frontmatter schema
- `skills/kano-agent-backlog-skill/references/workflow.md` - State machine transitions
- ADR-0003 - UID strategy (UUIDv7, uidshort, resolution)
- ADR-0008 - SQLite schema migration framework
