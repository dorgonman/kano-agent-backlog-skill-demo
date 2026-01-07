---
id: KABSD-TSK-0055
uid: 019b8f52-9fc6-7a10-ab99-a0d51b2962c9
type: Task
title: Generate Markdown views from SQLite index queries
state: Done
priority: P4
parent: KABSD-USR-0016
area: views
iteration: null
tags:
- sqlite
- index
- views
- markdown
created: 2026-01-05
updated: '2026-01-06'
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

If teams rely on DB queries but still want file-based dashboards, we should render markdown views from index queries.

# Goal

Generate Markdown dashboards from SQLite index query results under `_kano/backlog/views/`.

# Non-Goals

- Replace the file-based views (`scripts/backlog/view_generate.py`).
- Require DB indexing for normal backlog usage.
- Implement a full UI (keep outputs as Markdown).

# Approach

- Add `scripts/indexing/render_db_view.py` that runs a preset query and writes a Markdown view file.
- Keep outputs stable and safe to commit (but DB itself remains gitignored).
- This complements, not replaces, `scripts/backlog/view_generate.py`.

# Alternatives

- Keep using Dataview queries over files only.
- Ask agents to run ad-hoc SQL without a standardized script (harder to audit/reproduce).

# Acceptance Criteria

- A script can render at least New/InProgress/Done dashboards from the index.
- Output contains working links to the original item files.
- Running the script is auditable and path-restricted.

# Risks / Dependencies

- Requires a built index DB; script should fail with actionable guidance when missing.
- DB lock/journal issues may occur on some filesystems; prefer read-only access.
- Output stability matters for demos and review workflows.

# Worklog

2026-01-05 16:21 [agent=codex] Created from template.
2026-01-06 01:20 [agent=codex] State -> Ready. Ready gate validated for DB-index Markdown view generator.
2026-01-06 01:20 [agent=codex] State -> InProgress. Implementing scripts/indexing/render_db_view.py for New/InProgress/Done dashboards.
2026-01-06 01:22 [agent=codex] State -> Done. Added render_db_view.py to generate Markdown dashboards (New/InProgress/Done) from the SQLite index; documented in REFERENCE.md.
