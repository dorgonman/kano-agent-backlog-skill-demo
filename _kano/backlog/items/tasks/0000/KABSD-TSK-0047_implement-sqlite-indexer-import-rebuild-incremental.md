---
id: KABSD-TSK-0047
type: Task
title: "Implement sqlite indexer (import + rebuild + incremental)"
state: Done
priority: P3
parent: KABSD-USR-0012
area: storage
iteration: null
tags: ["sqlite", "db", "index"]
created: 2026-01-05
updated: 2026-01-05
owner: codex
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

SQLite is the simplest local DB option for an index/cache.

# Goal

Implement a SQLite indexer that can rebuild from the file backlog.

# Non-Goals

- DB-first CRUD (source of truth remains files).
- Embedding/vector indexing.
- Live file watcher integration.

# Approach

- Add a script that reads `_kano/backlog/items/**` and writes to a sqlite file under `_kano/backlog/_index/` (or sandbox).
- Support full rebuild; incremental update can be a follow-up.
- Must not modify source files.

# Alternatives

- Keep using grep/Dataview only and skip DB indexing.
- Implement Postgres first (higher setup cost).
- Store a single JSON blob per item (harder to query).

# Acceptance Criteria

- Rebuild produces expected tables/rows for the demo backlog.
- Script refuses to write outside allowed roots and supports `--dry-run` where applicable.

# Risks / Dependencies

- Concurrency and file watcher integration deferred.

# Worklog

2026-01-05 08:31 [agent=codex] Created from template.
2026-01-05 13:38 [agent=codex] State -> Ready. Ready gate validated for sqlite indexer implementation.
2026-01-05 13:38 [agent=codex] State -> InProgress. Implementing SQLite indexer script (rebuild + optional incremental).
2026-01-05 13:54 [agent=codex] State -> Done. Added SQLite indexer script (rebuild + incremental), SQLite-first schema references, and ensured compatibility with sandboxed filesystems by using journal_mode=OFF.
