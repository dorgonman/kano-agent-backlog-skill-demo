# kano-backlog-core

Transport-agnostic domain library for the Kano backlog system. Provides core functionality for reading, writing, and managing markdown-based backlog items with frontmatter.

## Features

- **File-first canonical storage**: Markdown files with YAML frontmatter as source of truth
- **Type-safe models**: Pydantic v2 models with full validation
- **Path resolution**: Automatic discovery of platform and product roots
- **Extensible architecture**: Transport-agnostic design for CLI, HTTP, MCP, and GUI facades

## Installation

```bash
pip install -e .
```

For development:

```bash
pip install -e ".[dev]"
```

## Quick Start

### Configuration

Load backlog context from any path within the backlog structure:

```python
from kano_backlog_core.config import ConfigLoader

# Automatically resolve platform, backlog, and product roots
ctx = ConfigLoader.from_path(Path("/workspace/_kano/backlog/products/my-product/items"))

print(f"Platform root: {ctx.platform_root}")
print(f"Backlog root: {ctx.backlog_root}")
print(f"Product: {ctx.product_name}")
```

### Reading Items

```python
from kano_backlog_core.canonical import CanonicalStore
from pathlib import Path

# Initialize store
store = CanonicalStore(ctx.product_root)

# Read an item
item_path = ctx.product_root / "items" / "tasks" / "0000" / "KABSD-TSK-0001_example.md"
item = store.read(item_path)

print(f"ID: {item.id}")
print(f"Title: {item.title}")
print(f"State: {item.state.value}")
print(f"Context: {item.context}")
```

### Creating Items

```python
from kano_backlog_core.models import ItemType

# Create a new task
item = store.create(
    item_type=ItemType.TASK,
    title="Implement feature X",
    parent="KABSD-FTR-0010",
    priority="P1",
    tags=["core", "urgent"]
)

# Populate body sections
item.context = "Users need this feature to complete workflow Y"
item.goal = "Implement feature X with full test coverage"
item.approach = "Use pattern Z, integrate with component A"
item.acceptance_criteria = "- Feature works\n- Tests pass\n- Docs updated"

# Write to disk
store.write(item)
print(f"Created: {item.file_path}")
```

### Updating Items

```python
# Read existing item
item = store.read(item_path)

# Modify
item.state = ItemState.IN_PROGRESS
item.owner = "alice"
item.worklog.append("2024-01-15 14:30 [agent=copilot] Started implementation")

# Write back
store.write(item)
```

### Listing Items

```python
from kano_backlog_core.models import ItemType

# List all tasks
task_paths = store.list_items(ItemType.TASK)

# List all items
all_paths = store.list_items()

# Process items
for path in task_paths:
    item = store.read(path)
    print(f"{item.id}: {item.title} ({item.state.value})")
```

### Validation

```python
# Validate item schema
errors = store.validate_schema(item)
if errors:
    for error in errors:
        print(f"Validation error: {error}")
```

## State Machine

Enforce valid state transitions and Ready gate validation for Task/Bug items:

```python
from kano_backlog_core import StateMachine, StateAction, ReadyValidator
from kano_backlog_core.models import ItemType, ItemState

# Check if transition is allowed
allowed = StateMachine.can_transition(ItemState.NEW, StateAction.START)
# True

# Perform transition (modifies item in-place)
item.state = ItemState.NEW
item.context = "Test context"
item.goal = "Test goal"
item.approach = "Test approach"
item.acceptance_criteria = "Test criteria"
item.risks = "Test risks"

result = StateMachine.transition(item, StateAction.READY, agent="copilot")
# item.state is now ItemState.READY
# Worklog entry appended with timestamp and agent

# Ready gate validation (Task/Bug only)
errors = ReadyValidator.check(item)
if errors:
    print(f"Not ready: {errors}")  # ['context', 'goal', ...]
else:
    print("Item is ready to work on")
```

### State Transitions

Valid transitions:
- **NEW** → PROPOSED, READY, START (InProgress), BLOCK, DROP
- **PROPOSED** → READY, BLOCK, DROP
- **READY** → START (InProgress), DONE, BLOCK, DROP
- **IN_PROGRESS** → REVIEW, DONE, BLOCK, DROP
- **REVIEW** → DONE, BLOCK, DROP
- **BLOCKED** → START (InProgress), DROP

### Ready Gate

Task and Bug items require these sections before transitioning to READY:
- **context**: Background and motivation
- **goal**: What this item aims to achieve
- **approach**: Implementation strategy
- **acceptance_criteria**: Definition of done
- **risks**: Blockers and concerns

Epic/Feature/UserStory items skip Ready gate validation.

## Audit Logging

Track worklog entries and file operations:

```python
from kano_backlog_core import AuditLog, WorklogEntry

# Append worklog to item
item = store.read(item_path)
AuditLog.append_worklog(item, "Started implementation", agent="copilot")
# Worklog: "2024-01-15 14:30 [agent=copilot] Started implementation"

# Parse existing worklog
entries = AuditLog.parse_worklog(item)
for entry in entries:
    print(f"{entry.timestamp} [{entry.agent}] {entry.message}")

# Log file operations to JSONL audit trail
from pathlib import Path
log_path = Path("_kano/backlog/_logs/agent_tools/tool_invocations.jsonl")
AuditLog.log_file_operation(
    operation="create",
    path="items/tasks/0000/KABSD-TSK-0001.md",
    tool="backlog_tool",
    agent="copilot",
    metadata={"reason": "New feature request"},
    log_path=log_path
)

# Read audit trail
records = AuditLog.read_file_operations(log_path, operation_filter="create")
for record in records:
    print(f"{record['timestamp']}: {record['operation']} {record['path']}")
```

### Worklog Format

Standard format: `YYYY-MM-DD HH:MM [agent=name] Message`

### File Operation Audit Log

JSONL format for audit trail with timestamp, agent, operation, path, and metadata.

### Derived Queries

Use the in-memory derived store for fast read-only queries over canonical items:

```python
from kano_backlog_core.derived import InMemoryDerivedStore, QueryFilter

store = CanonicalStore(ctx.product_root)
derived = InMemoryDerivedStore(store)

# List all items
items = derived.list_items()

# Filter by type/state
tasks = derived.list_items(QueryFilter(item_type=ItemType.TASK))
ready = derived.get_by_state(ItemState.READY)

# Search by text
found = derived.search("crash")

# Get by identifiers
by_id = derived.get_by_id("KABSD-TSK-0125")
by_uid = derived.get_by_uid("01234567-89ab-7def-8123-456789abcdef")
```

### Reference Parsing & Resolution

Parse and resolve references found in backlog content:

```python
from kano_backlog_core.refs import RefParser, RefResolver

resolver = RefResolver(store, derived)

# Parse references
RefParser.parse("KABSD-TSK-0125")
RefParser.parse("ADR-0003-appendix_migration-plan")

# Resolve references
item = resolver.resolve("KABSD-TSK-0125")
# Resolve multiple (skips invalid)
items = resolver.resolve_many(["KABSD-TSK-0125", "ADR-0001"])  # ADR may not exist

# Extract and validate references from an item
refs = resolver.get_references(item)
invalid = resolver.validate_references(item)
```
```

## Architecture

### Module Structure

```
kano_backlog_core/
├── config.py         # Configuration and context resolution
├── canonical.py      # Canonical store (file I/O)
├── models.py         # Pydantic data models
└── errors.py         # Typed exception taxonomy
```

### Core Modules

- **Config**: Path resolution, defaults loading
- **Canonical**: Read/write markdown items with frontmatter
- **Models**: ItemType, ItemState, BacklogItem, WorklogEntry
- **Errors**: Typed exceptions for precise error handling

## Item Structure

### Frontmatter Fields

```yaml
---
id: KABSD-TSK-0115
uid: 01234567-89ab-7def-8123-456789abcdef
type: task
title: Example Task
state: InProgress
priority: P1
parent: KABSD-FTR-0010
owner: alice
tags: [core, urgent]
created: 2024-01-01
updated: 2024-01-15
area: Backend
iteration: Sprint 5
external:
  jira: PROJ-123
links:
  relates: [KABSD-TSK-0020]
  blocks: []
  blocked_by: []
decisions: [ADR-0001]
---
```

### Body Sections

- **Context**: Background and motivation
- **Goal**: What this item aims to achieve
- **Non-Goals**: Out of scope
- **Approach**: Implementation strategy
- **Alternatives**: Other options considered
- **Acceptance Criteria**: Definition of done
- **Risks / Dependencies**: Blockers and concerns
- **Worklog**: Append-only audit trail

## Development

### Running Tests

```bash
pytest tests/ -v
```

### Coverage

```bash
pytest tests/ --cov=kano_backlog_core --cov-report=html
```

Coverage target: 80% (current: 84%)

### Type Checking

```bash
mypy src/
```

### Formatting

```bash
black src/ tests/
ruff check src/ tests/
```

## Design Principles

1. **File-first**: Markdown files are the canonical source of truth
2. **Transport-agnostic**: Core library has no CLI/HTTP/MCP dependencies
3. **Type-safe**: Pydantic models with full validation
4. **Explicit errors**: Typed exceptions for each error case
5. **Path-based**: Use pathlib.Path throughout

## Error Handling

```python
from kano_backlog_core.errors import (
    ItemNotFoundError,
    ValidationError,
    ConfigError,
    ParseError,
    WriteError,
)

try:
    item = store.read(item_path)
except ItemNotFoundError:
    print("Item not found")
except ParseError as e:
    print(f"Failed to parse: {e}")
```

## License

(TBD)
