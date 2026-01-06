---
id: KABSD-TSK-0064
uid: 019b8f52-9fd9-717e-834e-888720a41975
type: Task
title: 'Unify dashboard generation: auto use SQLite index with file-scan fallback'
state: Done
priority: P3
parent: KABSD-USR-0016
area: views
iteration: null
tags:
- views
- sqlite
- index
- refresh
created: 2026-01-06
updated: 2026-01-06
owner: antigravity
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

We now have both file-scan dashboards (PlainMarkdown) and DBIndex dashboards generated from SQLite.
This overlaps functionally and confuses users. We want a single set of dashboard outputs that can be generated from either data source: prefer SQLite when enabled/available, otherwise scan files.

# Goal

Provide a unified, reproducible dashboard generation flow that is data-source agnostic (SQLite index when available, file scan otherwise), and keep Obsidian Dataview/Bases views compatible by relying on Markdown outputs.

# Non-Goals

- Change how Obsidian Dataview/Bases themselves query data (they read files).
- Require the SQLite index for normal file-first usage.
- Build embeddings/RAG here.

# Approach

- Keep `scripts/backlog/view_generate.py` as the single dashboard renderer; use `--source auto` (already implemented).
- Add `scripts/backlog/view_refresh_dashboards.py` to (optionally) rebuild the index (incremental) then regenerate the standard dashboard files.
- Deprecate `Dashboard_DBIndex_*.md` outputs (keep as optional demo or make them link to the unified dashboards).
- Update docs and REFERENCE to point to the unified flow.

# Alternatives

- Keep separate PlainMarkdown and DBIndex dashboards and document both (still confusing).

# Acceptance Criteria

- One command can refresh the standard dashboards, using SQLite when enabled and falling back to file scan.
- The canonical dashboard files are `Dashboard_PlainMarkdown_Active/New/Done.md` (source noted in header).
- Docs explain how to use the unified flow and how it relates to Obsidian Dataview/Bases.
- Demo DBIndex dashboard files no longer cause confusion (deprecated or removed).

# Risks / Dependencies

- SQLite DB might be stale or locked; script must fail clearly or fall back to file scan.

# Worklog

2026-01-06 01:38 [agent=codex] Created from template.
2026-01-06 01:39 [agent=codex] State -> Ready. Ready gate validated for unified dashboard refresh flow.
2026-01-06 01:59 [agent=codex-cli] State -> Done. Unified view generation via generate_view --source auto + refresh_dashboards; deprecated Dashboard_DBIndex_* stubs now point to canonical Dashboard_PlainMarkdown_* dashboards; refreshed dashboards using SQLite index.
2026-01-06 11:53 [agent=antigravity] Setting up artifacts directory.
2026-01-06 11:55 [agent=antigravity] Created artifacts directory and README.
