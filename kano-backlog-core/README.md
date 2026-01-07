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
