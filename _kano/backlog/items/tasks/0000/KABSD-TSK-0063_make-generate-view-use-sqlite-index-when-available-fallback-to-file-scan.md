---
id: KABSD-TSK-0063
type: Task
title: "Make generate_view use SQLite index when available (fallback to file scan)"
state: Done
priority: P3
parent: KABSD-USR-0016
area: views
iteration: null
tags: ["views", "sqlite", "index", "auto"]
created: 2026-01-06
updated: 2026-01-06
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

We have two Markdown dashboard generators: file-scan (`scripts/backlog/generate_view.py`) and DB-index (`scripts/indexing/render_db_view.py`).
This causes overlap and confusion. We want a single view generator that can use the SQLite index when available/enabled, and fall back to scanning files otherwise.

# Goal

Unify generated Markdown dashboards so the same output files can be produced from either data source (SQLite index or file scan), controlled by a simple flag.

# Non-Goals

- Change Obsidian Dataview or Bases behavior (they read files, not DB).
- Require the SQLite index for normal file-first operation.
- Remove the DBIndex demo views (can be kept as an optional demo).

# Approach

- Extend `scripts/backlog/generate_view.py` to support `--source auto|files|sqlite` (default: auto).
- In `auto` mode, prefer SQLite when `index.enabled=true` and the DB exists; otherwise scan files.
- Keep output format identical between sources (links + group/type sections).
- Update docs: `references/views.md` and `references/indexing.md` to explain the behavior.

# Alternatives

- Keep two separate generators and document the difference (still confusing).

# Acceptance Criteria

- `generate_view.py --source auto` produces a view even when the DB does not exist (file scan fallback).
- When DB exists and `index.enabled=true`, it uses the DB as source.
- Docs explain how Dataview/Base differ and how generated Markdown views can use DB.
- Plain views are regenerated after changes.

# Risks / Dependencies

- DB can be stale; views should not silently hide that risk (add a note in output header about source).

# Worklog

2026-01-06 01:29 [agent=codex] Created from template.
2026-01-06 01:30 [agent=codex] State -> Ready. Ready gate validated for unified view generator changes.
2026-01-06 01:30 [agent=codex] State -> InProgress. Extending generate_view.py to auto-use SQLite index when enabled, fallback to file scan.
2026-01-06 01:35 [agent=codex] State -> Done. generate_view.py now supports --source auto|files|sqlite, preferring SQLite when index.enabled=true and DB exists, otherwise falling back to file scan; updated docs.
