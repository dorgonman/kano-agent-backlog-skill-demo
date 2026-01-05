---
id: KABSD-TSK-0052
type: Task
title: "Default SQLite index artifacts to _kano/backlog/_index and gitignore"
state: Done
priority: P3
parent: KABSD-USR-0012
area: storage
iteration: null
tags: ["sqlite", "index", "gitignore"]
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

Currently, when `index.path` is null, the SQLite indexer defaults to writing into the sandbox path.
For real usage, artifacts should default under `_kano/backlog/_index/` (gitignored), while sandbox remains for tests.

# Goal

Make the default SQLite index output path deterministic and production-friendly: `_kano/backlog/_index/backlog.sqlite3` (relative to the chosen `--backlog-root`).

# Non-Goals

- Enable indexing by default (index.enabled stays false by default).
- Change the source-of-truth model (file-first remains).

# Approach

- Update `scripts/indexing/build_sqlite_index.py` default path resolution to `<backlog-root>/_index/backlog.sqlite3` when `index.path` is null.
- Add `_kano/backlog/_index/` to `.gitignore` so artifacts do not get staged.
- Keep the ability to override via `--db-path` or `index.path`.

# Alternatives

- Keep defaulting to sandbox (confusing for real usage).
- Store DB under repo root (harder to scope/ignore).

# Acceptance Criteria

- Running with `--dry-run` shows default DB path under `<backlog-root>/_index/`.
- `.gitignore` prevents accidental staging of DB artifacts.
- Views are regenerated after the task item changes.

# Risks / Dependencies

- Some environments may lock sqlite/journal files; using sandbox for tests remains recommended.

# Worklog

2026-01-05 14:24 [agent=codex] Created from template.
2026-01-05 14:24 [agent=codex] State -> Ready. Ready gate validated for default index path + gitignore change.
2026-01-05 14:24 [agent=codex] State -> InProgress. Switching default DB index output to _kano/backlog/_index and ignoring artifacts in git.
2026-01-05 14:25 [agent=codex] State -> Done. Default DB path now resolves to <backlog-root>/_index/backlog.sqlite3 when index.path is null; added _kano/backlog/_index to .gitignore.
