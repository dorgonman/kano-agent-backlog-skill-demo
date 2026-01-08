# CLI Migration Plan: From Standalone Scripts to Thin Wrappers

**Task:** KABSD-TSK-0116  
**Date:** 2026-01-08  
**Status:** Draft  
**Parent:** KABSD-FTR-0019 (Refactor kano-backlog-core + facades)

---

## Overview

This document defines the migration strategy for transforming standalone shell scripts into a unified `kano` CLI facade backed by `kano-backlog-core`. The new CLI will:

- Provide consistent UX across all backlog operations
- Expose core library functions via structured subcommands
- Support machine-readable output (JSON) alongside human-friendly text
- Maintain backward compatibility through thin wrapper scripts

---

## Design Principles

1. **Transport-agnostic Core**: All business logic remains in `kano-backlog-core`
2. **Thin Facade**: CLI only handles argument parsing, input validation, output formatting
3. **Consistent Exit Codes**: Predictable error handling for scripting
4. **Backward Compatibility**: Existing scripts remain functional during transition
5. **Clear Separation**: Core → CLI → Scripts hierarchy (no bidirectional dependencies)

---

## 1. CLI Package Structure

### Directory Layout

```
kano-cli/                          # New package (or integrate into kano-backlog-core)
├── kano_cli/
│   ├── __init__.py
│   ├── cli.py                     # Main CLI entry point (typer app)
│   ├── commands/
│   │   ├── __init__.py
│   │   ├── item.py                # item create, read, update, state-transition
│   │   ├── index.py               # index build, query
│   │   ├── ref.py                 # ref resolve, parse
│   │   ├── worklog.py             # worklog append, parse
│   │   ├── audit.py               # audit logs, file operations
│   │   └── workset.py             # workset cache operations (future)
│   ├── formatters/
│   │   ├── __init__.py
│   │   ├── plain_text.py          # Human-readable output
│   │   ├── json_output.py         # JSON serialization
│   │   └── table.py               # Tabular output for queries
│   ├── errors.py                  # CLI-specific error handling
│   └── config.py                  # CLI configuration loading
├── scripts/
│   └── kano                        # Main entry point (console_scripts)
├── pyproject.toml
└── README.md
```

### Entry Point Configuration (pyproject.toml)

```toml
[project.scripts]
kano = "kano_cli.cli:main"

# Keep legacy scripts as wrappers (temporary, deprecated after v1.0)
# These are phased out over 2-3 releases
workitem-update-state = "kano_cli.legacy:workitem_update_state"
# ... other legacy wrappers
```

---

## 2. CLI Command Hierarchy

All commands map directly to core library functions. Format: `kano <resource> <action> [options]`

### 2.1. Item Commands

**Resource: `item`** - Create, read, update, and transition backlog items

```bash
kano item create \
  --type Task \
  --title "Implement X feature" \
  --parent KABSD-FTR-0020 \
  --area architecture \
  --json

# Output (with --json):
# { "id": "KABSD-TSK-0121", "uid": "...", "state": "New", ... }

kano item read <item-id> [--format json|yaml|plain]
# Reads from canonical markdown file

kano item update <item-id> \
  --context "New context" \
  --goal "New goal" \
  --state-action ready  # Validates Ready gate before transition
  # or --state-action start, done, block, drop

kano item list \
  --type Task \
  --state InProgress \
  --area architecture \
  --owner copilot \
  --format table|json|plain
```

**Mapping to Core:**
- `kano item create` → `CanonicalStore.create()`
- `kano item read` → `CanonicalStore.read()`
- `kano item update` → `CanonicalStore.write()`
- `kano item state-transition` → `StateMachine.transition()`
- `kano item list` → `DerivedStore.query()` with filters

### 2.2. State Transition Commands

**Resource: `state`** - Explicit state machine operations

```bash
kano state transition <item-id> \
  --action start \
  --agent copilot \
  --message "Starting implementation" \
  --force  # Skip Ready gate validation (admin override)

kano state validate <item-id>
# Returns: 0 (Ready), 1 (not Ready), prints missing sections

kano state transitions [--item-id <id>]
# List valid transitions from current state
```

**Mapping to Core:**
- `kano state transition` → `StateMachine.transition()`
- `kano state validate` → `ReadyValidator.check()`
- `kano state transitions` → List from `StateMachine.TRANSITIONS`

### 2.3. Worklog Commands

**Resource: `worklog`** - Append and parse work entries

```bash
kano worklog append <item-id> \
  --message "Completed initial design review" \
  --agent copilot

kano worklog read <item-id> [--format json|plain]
# Parse and display worklog entries with timestamps

kano worklog list <item-id>  # Alias for read
```

**Mapping to Core:**
- `kano worklog append` → `AuditLog.append_worklog()`
- `kano worklog read` → `AuditLog.parse_worklog()`

### 2.4. Index Commands

**Resource: `index`** - Build and query derived indexes

```bash
kano index build \
  --backend sqlite \
  --incremental  # Update only changed items

kano index query \
  --state InProgress \
  --type Task \
  --tag priority:P0 \
  --format table

kano index get-by-uid <uid> --format json
kano index get-by-id <display-id>
kano index get-by-uidshort <uidshort>
```

**Mapping to Core:**
- `kano index build` → `DerivedStore.build()`
- `kano index query` → `DerivedStore.query()`
- `kano index get-by-*` → `DerivedStore.get_by_*()`

### 2.5. Reference Resolution Commands

**Resource: `ref`** - Parse and resolve item references

```bash
kano ref resolve "KABSD-TSK-0115" --interactive

kano ref parse "KABSD-TSK-0115@019b98" --format full_uid

kano ref uidshort <full-uid>
# Output: 019b9853
```

**Mapping to Core:**
- `kano ref resolve` → `RefResolver.resolve()`
- `kano ref parse` → `RefResolver.parse()`
- `kano ref uidshort` → `RefResolver.format_uidshort()`

### 2.6. Audit Commands

**Resource: `audit`** - View audit trails and file operations

```bash
kano audit file-operations \
  --operation create,update \
  --path "_kano/backlog/items/**" \
  --agent copilot \
  --format table

kano audit file-operations \
  --agent copilot \
  --days 7 \
  --format json > audit-week.json
```

**Mapping to Core:**
- `kano audit file-operations` → `AuditLog.read_file_operations()`

---

## 3. Output Formatting Strategy

All commands support `--format` flag with consistent behavior:

### 3.1. Output Formats

#### Plain Text (default)
```
Human-friendly, multi-line output suitable for terminal reading.
Example:
  ID:    KABSD-TSK-0115
  Title: Define core interfaces
  State: Done
  Owner: copilot
```

#### JSON
```
Machine-readable structured output. Suitable for piping and scripting.
Example:
  {
    "id": "KABSD-TSK-0115",
    "uid": "019b9853-86ed-7ac4-80af-e9bb0fcf0c50",
    "state": "Done",
    "owner": "copilot"
  }
```

#### Table (for list/query results)
```
Columnar output with headers and alignment. No headers with --quiet.
Example:
  ID              State         Owner
  ────────────────────────────────────
  KABSD-TSK-0115  Done          copilot
  KABSD-TSK-0116  InProgress    copilot
```

#### YAML (optional, for some commands)
```
Suitable for config files and diffs.
Example:
  id: KABSD-TSK-0115
  state: Done
  owner: copilot
```

### 3.2. Error Output

Errors always go to stderr (not stdout). Example:

```bash
$ kano item read INVALID-ID
Error: Item not found: INVALID-ID (exit code 2)

$ kano state transition KABSD-TSK-0120 --action start  # Missing context/goal
Error: Cannot transition: Ready gate failed
  Missing sections:
    - Context (empty)
    - Goal (empty)
(exit code 3)
```

---

## 4. Exit Code Convention

```
0   ✓ Success
1   - General error (unspecified)
2   - Not found (item, file, etc.)
3   - Validation failed (Ready gate, schema, etc.)
4   - Permission denied (read-only directory, etc.)
5   - Configuration error (missing config, invalid backlog root)
6   - Already exists (item ID collision, etc.)
99  - Internal error (exception, unhandled state)
```

---

## 5. Configuration and Defaults

CLI respects these configuration sources (in order of precedence):

1. **Command-line arguments** (highest priority)
2. **Environment variables** (e.g., `KANO_BACKLOG_ROOT`, `KANO_PRODUCT`)
3. **Config file** (e.g., `.kanorc` or `$HOME/.config/kano/config.toml`)
4. **Defaults** (hardcoded in `_shared/defaults.json`)

### Example `.kanorc` (TOML)
```toml
[paths]
backlog_root = "/home/user/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog"
product = "kano-agent-backlog-skill"

[output]
default_format = "plain"  # plain, json, table, yaml
color = true

[audit]
log_all_operations = true
log_path = "/home/user/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/_logs/agent_tools"
```

---

## 6. Migration Strategy: Legacy Script Compatibility

Current landscape of scripts:
- `workitem_update_state.py` - Updates item state with validation
- `view_generate.py` - Generates dashboard views
- `workset_tool.py` - Manages workset operations
- Various `.sh` wrapper scripts

### Phase 1: Parallel Operation (Releases v0.2–v0.4)

**Goal:** Introduce new CLI without breaking existing workflows.

- Build new `kano` CLI alongside legacy scripts
- Legacy scripts remain as thin wrappers calling core library (not CLI)
- Create migration guide with examples
- Add deprecation warnings to legacy scripts (stderr warnings)

**Migration Map (Example):**

| Legacy Script | New CLI Command |
|---|---|
| `workitem_update_state.py --item <id> --action done` | `kano state transition <id> --action done` |
| `view_generate.py --groups "InProgress"` | `kano index query --state InProgress --format table` |
| `workset_tool.py cache <item-id>` | `kano workset cache <item-id>` (future) |

### Phase 2: Thin Wrappers (Release v0.5)

**Goal:** Convert legacy scripts to call new CLI as subprocesses.

```python
# Old: workitem_update_state.py
# New: Just a wrapper

import subprocess
import sys

def main():
    args = sys.argv[1:]
    # Translate old args to new CLI format and call subprocess
    subprocess.run(["kano", "state", "transition"] + convert_args(args))

if __name__ == "__main__":
    main()
```

### Phase 3: Deprecation (Release v1.0)

**Goal:** Remove legacy scripts entirely.

- Announce end-of-life for old scripts
- Provide 6-month transition window
- Remove legacy scripts from codebase

---

## 7. Implementation Roadmap

### MVP (v0.2) - Core Commands Only

**Required Commands:**
- `kano item create`
- `kano item read`
- `kano item update`
- `kano state transition`
- `kano state validate`
- `kano worklog append`
- `kano worklog read`

**Output:** Plain text + JSON formats

**No:** Config file, color output, table formatting (use plain text)

### Phase 1 (v0.3) - Enhanced Output

- Add `--format table`
- Add color support (with `--no-color` flag)
- Add config file support

### Phase 2 (v0.4) - Full Feature Parity

- Add `index` commands
- Add `ref` commands
- Add `audit` commands
- Complete `workset` commands (future)

---

## 8. Implementation Framework Choice

**Recommendation: `typer`** (built on `click`, adds async/FastAPI integration)

**Rationale:**
- Simpler than `argparse`, less boilerplate than `click`
- Native async support (can run core operations in parallel)
- Excellent help text generation
- Can share same type hints with FastAPI server facade

**Example CLI Structure (typer):**

```python
# kano_cli/cli.py
import typer
from .commands import item, state, worklog, index, ref, audit

app = typer.Typer(help="kano: Backlog management CLI")

app.add_typer(item.app, name="item", help="Item operations")
app.add_typer(state.app, name="state", help="State machine operations")
app.add_typer(worklog.app, name="worklog", help="Worklog operations")
app.add_typer(index.app, name="index", help="Index operations")
app.add_typer(ref.app, name="ref", help="Reference resolution")
app.add_typer(audit.app, name="audit", help="Audit trails")

def main():
    app()
```

---

## 9. Error Handling and Validation

All CLI commands follow this pattern:

1. **Parse arguments** (typer handles this)
2. **Load configuration** (BacklogContext)
3. **Validate inputs** (Check required fields, formats)
4. **Call core library** (Catch domain exceptions)
5. **Format output** (Plain, JSON, table, etc.)
6. **Exit with code** (0 for success, 1-99 for errors)

**Example: State Transition with Error Handling**

```python
@state.command()
def transition(
    item_id: str = typer.Argument(...),
    action: StateAction = typer.Option(...),
    agent: str = typer.Option("copilot"),
    message: str = typer.Option(""),
    force: bool = typer.Option(False, help="Skip Ready gate validation"),
    format: OutputFormat = typer.Option("plain"),
):
    """Transition item state."""
    try:
        context = BacklogContext.from_path(Path.cwd())
        canonical = CanonicalStore(context.product_root)
        item = canonical.read(find_item_path(item_id, context))
        
        if not force:
            errors = ReadyValidator.check(item)
            if errors:
                typer.echo(f"Error: Ready gate failed", err=True)
                for err in errors:
                    typer.echo(f"  - {err}", err=True)
                raise typer.Exit(code=3)
        
        updated_item = StateMachine.transition(item, action, agent, message)
        canonical.write(updated_item)
        
        # Format output
        if format == "json":
            typer.echo(json.dumps(updated_item.dict()))
        else:
            typer.echo(f"✓ {item_id} transitioned to {updated_item.state}")
            
    except ItemNotFoundError as e:
        typer.echo(f"Error: {e}", err=True)
        raise typer.Exit(code=2)
    except ValidationError as e:
        typer.echo(f"Error: Validation failed\n{e}", err=True)
        raise typer.Exit(code=3)
    except Exception as e:
        typer.echo(f"Error: Internal error: {e}", err=True)
        raise typer.Exit(code=99)
```

---

## 10. Testing Strategy

CLI tests follow layered approach:

1. **Unit tests**: Command functions in isolation (mock core library)
2. **Integration tests**: CLI → Core library (real files, temp directory)
3. **Acceptance tests**: End-to-end workflows (full feature scenarios)

**Example Test:**

```python
def test_state_transition_cli(tmp_path):
    """Test CLI state transition with Ready gate validation."""
    # Setup
    context = setup_test_backlog(tmp_path)
    item = create_test_item(tmp_path, state=ItemState.NEW)
    
    # Missing context should fail
    runner = CliRunner()
    result = runner.invoke(app, [
        "state", "transition", item.id,
        "--action", "ready"
    ])
    assert result.exit_code == 3  # Validation error
    assert "Ready gate failed" in result.output
    
    # Add context, then retry
    item.context = "New context"
    item.goal = "New goal"
    item.approach = "New approach"
    item.acceptance_criteria = "New acceptance criteria"
    item.risks = "No risks"
    
    result = runner.invoke(app, [
        "state", "transition", item.id,
        "--action", "ready"
    ])
    assert result.exit_code == 0
    assert item.state == ItemState.READY
```

---

## 11. Documentation Requirements

- README with quick start (install, first command)
- Command reference (auto-generated from `--help`)
- Migration guide (legacy script → new CLI)
- Configuration guide (env vars, config files)
- Example workflows (create item, transition, worklog, query)

---

## 12. Acceptance Criteria

- ✅ Migration plan document exists and is detailed
- ✅ CLI command hierarchy is mapped to core operations
- ✅ Output formatting strategy (plain, JSON, table) is defined
- ✅ Exit code conventions are established
- ✅ Legacy script migration path is clear (phases 1-3)
- ✅ Configuration loading strategy is specified
- ✅ Implementation framework choice is justified (typer)
- ✅ Error handling patterns are documented
- ✅ Testing strategy is defined

---

## Notes and Open Questions

1. **Package Location**: Integrate CLI into `kano-backlog-core` or separate `kano-cli` package?
   - *Recommendation: Separate package for clarity; `kano-backlog-core` remains transport-agnostic*

2. **Color Output**: Should colors be automatic (detect terminal) or opt-in?
   - *Recommendation: Auto-detect with `--no-color` to disable*

3. **Config File Location**: Standard location for `.kanorc` or `config.toml`?
   - *Recommendation: `$HOME/.config/kano/config.toml` (Linux/Mac) or `%APPDATA%\kano\config.toml` (Windows)*

4. **Legacy Deprecation Timeline**: How long to keep wrappers?
   - *Recommendation: 3 releases (v0.2 → v1.0) with warnings*

5. **Async Operations**: Should CLI support async for parallel index builds?
   - *Recommendation: Yes, use typer's async support; allow `--parallel` flag*

