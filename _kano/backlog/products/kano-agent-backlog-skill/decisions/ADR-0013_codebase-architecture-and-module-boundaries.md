---
id: ADR-0013
title: "Codebase Architecture and Module Boundaries"
status: Accepted
date: 2026-01-11
related_items: [KABSD-FTR-0028, KABSD-FTR-0025, KABSD-FTR-0019]
supersedes: null
superseded_by: null
---

# Decision

Establish strict separation between **executable entrypoints** (`scripts/`) and **library modules** (`src/`). All agent-callable operations must go through a **single CLI entrypoint** (`scripts/kano`), which delegates to library use-cases.

## Hard Rules

1. **`scripts/` is executable-only**: No reusable module code in `scripts/`. Scripts must not be imported as libraries.
2. **Single CLI entrypoint**: Agents call only `scripts/kano <subcommand>`. All operations are exposed through this interface.
3. **`src/` is import-only**: Core logic lives in `src/kano_backlog_*` packages. These are imported by the CLI (and future facades), never executed directly.
4. **Consistent gating**: All write operations run prereqs + initialization checks via a single gate layer in the CLI.
5. **Deterministic output**: Same input state produces stable, reproducible output for views and queries.

# Context

## Current State (Problems)

The `scripts/` directory contains 40+ standalone Python scripts with overlapping responsibilities:

| Category | Scripts | Issues |
|----------|---------|--------|
| **backlog/** | 35+ scripts | Mixed executable + library code in same folder |
| **bootstrap/** | 1 script | OK |
| **indexing/** | 8 scripts | Some logic should be library code |
| **fs/** | 5 scripts | File operations, OK as thin wrappers |
| **vcs/** | 4 adapters | Already library-style but in scripts/ |
| **common/** | 4 modules | Shared code incorrectly placed in scripts/ |
| **logging/** | 3 modules | Shared code incorrectly placed in scripts/ |

**Problems**:
- Common logic mixed into scripts makes it hard to enforce consistent gating (prereqs/initialized/dry-run).
- Coding agents don't have a clear architecture reference; new code gets placed inconsistently.
- Different scripts may bypass checks or diverge behavior over time.
- No single entry point exists; agents must know which script to call.

## Existing Foundation

We already have:
- `src/kano_backlog_core/`: Core models, config, errors, refs, state (good foundation)
- `src/kano_cli/`: CLI skeleton with Typer, ~4 commands implemented
- `scripts/backlog/lib/`: Some shared code (should move to `src/`)
- `scripts/backlog/cli/`: Thin wrappers (good pattern, needs expansion)

# Architecture

## Layered Architecture

```mermaid
flowchart TB
  subgraph Agent["Coding Agent / Human"]
    A["calls scripts/kano (CLI)"]
  end

  subgraph Scripts["scripts/ (executable-only)"]
    CLI["scripts/kano\n├─ parse args\n├─ run gates (prereqs/init)\n└─ call lib use-cases"]
  end

  subgraph Src["src/ (import-only)"]
    Core["kano_backlog_core\n(config/models/ids/errors/refs/state)"]
    Ops["kano_backlog_ops\n(use-cases: init/create/update/\nindex/workset/view)"]
    Adapters["kano_backlog_adapters\n(sqlite/fts/faiss/vcs/fs)"]
    CLI_Pkg["kano_cli\n(Typer app, commands)"]
    Hooks["kano_backlog_hooks (future)\n(pre/post hooks interface)"]
  end

  subgraph Data["Data Layer"]
    SoT["Source of Truth\n(_kano/backlog/*.md)"]
    Cache["Derived Cache\n(_kano/backlog/_index/*.sqlite3)"]
  end

  A --> CLI
  CLI --> CLI_Pkg
  CLI_Pkg --> Ops
  Ops --> Core
  Ops --> Adapters
  Adapters --> SoT
  Adapters --> Cache
  Ops -. optional .-> Hooks
```

## Target Folder Structure

```mermaid
flowchart LR
  R["skills/kano-agent-backlog-skill/"] --> S["scripts/"]
  S --> K["kano (only entrypoint)"]
  S --> B["backlog/ (deprecated wrappers)"]
  S --> I["bootstrap/, fs/ (thin utilities)"]

  R --> SRC["src/"]
  SRC --> CORE["kano_backlog_core/\n(models, ids, config, errors)"]
  SRC --> OPS["kano_backlog_ops/\n(use-cases)"]
  SRC --> ADP["kano_backlog_adapters/\n(backends)"]
  SRC --> CLIPKG["kano_cli/\n(Typer commands)"]

  R --> REF["references/\n(schemas, docs)"]
  R --> TPL["templates/\n(markdown templates)"]
  R --> DEC["decisions/ (this ADR)"]
```

## Package Responsibilities

### `kano_backlog_core` (existing, expand)
- `models.py`: Pydantic models for work items, ADRs
- `config.py`: Configuration loading, defaults
- `ids.py`: ID parsing, generation, validation
- `errors.py`: Custom exceptions
- `refs.py`: Reference resolution logic
- `state.py`: State machine definitions
- `audit.py`: Audit logging primitives

### `kano_backlog_ops` (new)
Use-case functions that orchestrate operations:
- `init.py`: Initialize backlog structure
- `workitem.py`: Create, update, validate work items
- `adr.py`: Create, list ADRs
- `workset.py`: Workset management (init/refresh/promote)
- `view.py`: Generate views, dashboards
- `index.py`: Build/refresh SQLite index

### `kano_backlog_adapters` (new)
Pluggable backends:
- `fs.py`: File system operations (read/write markdown)
- `sqlite.py`: SQLite index adapter
- `fts.py`: Full-text search adapter
- `embedding.py`: Vector embedding adapter (optional)
- `vcs/`: VCS adapters (git, svn, perforce)

### `kano_cli` (existing, expand)
Typer-based CLI application:
- `cli.py`: Main app, callback for gating
- `commands/`: Subcommand modules (item, worklog, view, adr, index, workset)
- `util.py`: CLI utilities (output formatting, path resolution)

## CLI Command Structure (Target)

```
kano
├── doctor              # Check prereqs + initialization
├── init
│   └── backlog         # Initialize backlog structure
├── item
│   ├── create          # Create work item
│   ├── read            # Read item details
│   ├── update-state    # Transition state
│   ├── validate        # Check Ready gate
│   └── list            # List/query items
├── worklog
│   └── append          # Append worklog entry
├── adr
│   ├── create          # Create ADR
│   └── list            # List ADRs
├── index
│   ├── build           # Build SQLite index
│   └── refresh         # Incremental refresh
├── view
│   ├── refresh         # Refresh all dashboards
│   └── generate        # Generate specific view
└── workset
    ├── init            # Initialize workset
    ├── refresh         # Refresh workset
    ├── next            # Get next item
    └── promote         # Promote item state
```

# Migration Strategy

## Phase 0: ADR + SKILL Gate (This ADR)
- [x] Create this ADR with architecture diagrams
- [ ] Update SKILL.md: skill developers must read ADR-0013 before coding

## Phase 1: CLI Skeleton
- Expand `src/kano_cli/commands/` to cover all high-frequency operations
- CLI may internally call existing scripts as temporary adapters
- Add `kano doctor` for prereqs/init checks

## Phase 2: Library Migration
- Create `src/kano_backlog_ops/` with use-case functions
- Create `src/kano_backlog_adapters/` for backend abstraction
- Move logic from `scripts/backlog/*.py` into library packages
- Convert old scripts to thin wrappers calling `kano` CLI

## Phase 3: Deprecation
- Mark old scripts as deprecated (print warning)
- Update all documentation to recommend `kano` CLI
- Add CI check: fail if new executable scripts appear outside allowed set

## Phase 4: Future Extensions (Deferred)
- Plugin/hook system for external integrations
- Native engine option (C++/Rust via pybind11) for performance-critical paths
- HTTP/MCP server facade (reuses same `kano_backlog_ops` use-cases)

# Trade-offs

| Trade-off | Description |
|-----------|-------------|
| **Migration effort** | Significant refactoring of existing scripts. Mitigated by phased approach. |
| **Backward compatibility** | Old script paths break for agents. Mitigated by keeping thin wrappers. |
| **Initial complexity** | More packages to maintain. Pays off with clearer boundaries and reusability. |

# Consequences

1. **For skill developers**: Must read this ADR before adding code. New logic goes in `src/`, not `scripts/`.
2. **For agents**: Call only `scripts/kano`. Direct script calls are deprecated.
3. **For future facades**: HTTP/MCP/GUI can import `kano_backlog_ops` directly, no CLI dependency.
4. **For testing**: Use-case functions in `src/` are easier to unit test than CLI scripts.

# Related

- [[KABSD-FTR-0028]]: Parent feature for this refactoring
- [[KABSD-FTR-0025]]: Unified CLI (subset of this work)
- [[KABSD-FTR-0019]]: Core/CLI/Server/GUI facades separation
- [[ADR-0004]]: File-first architecture (complements this ADR)
