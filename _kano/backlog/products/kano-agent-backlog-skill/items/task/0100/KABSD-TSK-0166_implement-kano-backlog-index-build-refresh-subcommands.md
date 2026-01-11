---
id: KABSD-TSK-0166
uid: 019bac45-bf58-719e-92d5-9534253c02a4
type: Task
title: "Implement kano backlog index build|refresh subcommands"
state: Proposed
priority: P2
parent: KABSD-FTR-0028
area: cli
iteration: active
tags: ['cli', 'indexing', 'ops-layer']
created: 2026-01-11
updated: 2026-01-11
owner: None
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

Currently, backlog indexing (SQLite FTS + optional embeddings) relies on legacy `scripts/backlog/index_db.py`. The ops layer has stubs (`kano_backlog_ops.index.build_index` / `refresh_index`) but no implementation. To complete the backlog namespace migration, we need `kano backlog index build|refresh` subcommands that wrap these ops functions.

# Goal

Implement CLI subcommands:
- `kano backlog index build`: Scan all items in a product and create/rebuild the SQLite index from scratch.
- `kano backlog index refresh`: Incrementally update the index based on file mtimes (faster for CI/dev loops).

Both commands should:
- Accept `--product`, `--backlog-root`, `--force` (for build), `--since` (for refresh).
- Output stats (items indexed, links scanned, duration) in plain text or JSON.
- Support multi-product indexing when `--product` is omitted (all products under backlog root).

# Non-Goals

- Embedding generation (deferred to separate task or external tooling).
- Real-time file watching / auto-refresh (out of scope for MVP).
- Migration of existing index schemas (handle via separate migration task if needed).

# Approach

1. Implement `kano_backlog_ops.index.build_index()` and `refresh_index()` by extracting logic from `index_db.py`.
2. Add CLI commands in `src/kano_cli/commands/init.py` (under the backlog group) or create new `src/kano_cli/commands/index.py`.
3. Wire up arg parsing: product resolution, backlog root detection, force/since flags.
4. Return structured result objects (`IndexBuildResult`, `IndexRefreshResult`) with stats.
5. Update SKILL.md / README.md to document the new subcommands and deprecate direct `index_db.py` usage.

# Alternatives

- Keep `index_db.py` as-is and add a thin CLI wrapper: Rejected because it doesn't migrate logic to the ops layer (violates ADR-0013).
- Combine build and refresh into a single `kano backlog index` with auto-detection: Rejected for clarity; explicit build vs refresh makes behavior predictable.

# Acceptance Criteria

- [ ] `kano backlog index build --product <name>` creates/rebuilds SQLite index for that product.
- [ ] `kano backlog index refresh --product <name>` incrementally updates the index.
- [ ] Both commands accept `--backlog-root`, `--format json|plain`.
- [ ] Output includes: index path, items/links count, duration.
- [ ] SKILL.md documents the new commands and marks `index_db.py` deprecated.
- [ ] No regressions: existing index queries (via `kano_backlog_ops.index` or direct SQL) still work.

# Risks / Dependencies

- Depends on `kano_backlog_ops.index` module having complete implementations (currently stubs).
- SQLite schema may need versioning if we introduce breaking changes (deferred).
- Multi-product indexing requires careful path isolation to avoid cross-product leakage.

# Worklog

2026-01-11 14:48 [agent=copilot] Created item
