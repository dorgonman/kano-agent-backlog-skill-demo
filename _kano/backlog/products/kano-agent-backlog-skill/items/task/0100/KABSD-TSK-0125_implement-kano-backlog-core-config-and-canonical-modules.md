---
id: KABSD-TSK-0125
uid: 019b9919-bf70-73fd-810e-c71b5da60287
type: Task
title: "Implement kano-backlog-core: Config and Canonical modules"
state: Done
priority: P1
parent: KABSD-FTR-0019
area: general
iteration: null
tags: []
created: 2026-01-07
updated: 2026-01-08
owner: copilot
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
---

# Context

Per KABSD-TSK-0115, we have defined interfaces for `kano-backlog-core`. The first implementation phase focuses on the foundational modules: Config and Canonical.

**Config module** resolves backlog context (platform/product/sandbox roots) and loads configuration from defaults.json.

**Canonical module** provides read/write/validate operations for markdown items (SSOT). It includes BacklogItem Pydantic model, file I/O, frontmatter parsing, and schema validation.

These two modules form the foundation for all other core modules (Derived, Refs, State, etc.).

## References
- Interface spec: `artifacts/KABSD-TSK-0115/core-interfaces-spec.md`
- Current scripts: `skills/kano-agent-backlog-skill/scripts/common/context.py`

# Goal

Implement `kano-backlog-core` package with Config and Canonical modules that:
1. Resolve backlog context from any workspace path
2. Load/parse canonical markdown items with full frontmatter support
3. Validate items against schema
4. Create new items with auto-generated id/uid and correct file paths
5. Write items preserving markdown structure

# Non-Goals

- Implementing Derived, Refs, State modules (separate tasks)
- Refactoring existing CLI scripts to use core (migration task KABSD-TSK-0116)
- Building facades (HTTP/MCP servers in KABSD-TSK-0117)

# Approach

1. **Project structure**:
   ```
   kano-backlog-core/
   ├── pyproject.toml
   ├── src/
   │   └── kano_backlog_core/
   │       ├── __init__.py
   │       ├── config.py       # ConfigLoader, BacklogContext
   │       ├── canonical.py    # CanonicalStore, BacklogItem
   │       ├── errors.py       # Exception taxonomy
   │       └── models.py       # Pydantic models (ItemType, ItemState, etc.)
   └── tests/
       ├── test_config.py
       └── test_canonical.py
   ```

2. **Implementation order**:
   - errors.py: Define exception classes (ConfigError, ItemNotFoundError, ParseError, ValidationError, WriteError)
   - models.py: Define Pydantic models (ItemType, ItemState, BacklogItem)
   - config.py: Implement ConfigLoader.from_path() and load_defaults()
   - canonical.py: Implement CanonicalStore (read, write, create, list_items, validate_schema)

3. **Key design decisions**:
   - Use `pathlib.Path` throughout (no string paths)
   - Pydantic v2 for models with strict validation
   - Frontmatter parsing via `python-frontmatter` library
   - UID generation via `uuid6` or Python 3.12+ native UUIDv7
   - File paths follow bucket strategy: `items/{type_plural}/{bucket}/` where bucket = `(number // 100) * 100`

4. **Testing**:
   - Unit tests with pytest
   - Fixtures for sample markdown files
   - Test invalid frontmatter handling
   - Test bucket assignment for various ID numbers

# Alternatives

- Implement all 9 modules at once (too risky; harder to test incrementally)
- Keep using ad-hoc script-level functions (rejected; no reusability across facades)

# Acceptance Criteria

- [ ] `kano-backlog-core` package created with pyproject.toml
- [ ] Config module: `ConfigLoader.from_path()` resolves platform/product/sandbox roots correctly
- [ ] Config module: `load_defaults()` parses `_shared/defaults.json`
- [ ] Canonical module: `BacklogItem` Pydantic model parses all frontmatter fields + body sections
- [ ] Canonical module: `CanonicalStore.read()` loads and parses markdown items
- [ ] Canonical module: `CanonicalStore.create()` generates new items with auto id/uid/path
- [ ] Canonical module: `CanonicalStore.write()` preserves frontmatter and body structure
- [ ] Canonical module: `validate_schema()` returns list of validation errors
- [ ] Unit tests pass with >80% coverage for Config and Canonical modules
- [ ] Documentation: README.md with usage examples

# Risks / Dependencies

- Dependency on `python-frontmatter`, `pydantic`, `uuid6` (or Python 3.12+)
- Existing scripts may need minor refactoring to import from core (deferred to KABSD-TSK-0116)
- File I/O edge cases (permissions, encoding) need robust error handling

# Worklog

2026-01-07 23:36 [agent=copilot] Created from template.
2026-01-08 00:02 [agent=copilot] State -> InProgress.
2026-01-08 00:19 [agent=copilot] Config and Canonical modules implemented with 84% test coverage. All 28 tests passing. Created errors.py, models.py, config.py, canonical.py, and README.md with full documentation.
