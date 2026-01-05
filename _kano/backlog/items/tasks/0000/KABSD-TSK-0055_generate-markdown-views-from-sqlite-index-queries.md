---
id: KABSD-TSK-0055
type: Task
title: "Generate Markdown views from SQLite index queries"
state: Proposed
priority: P4
parent: KABSD-USR-0016
area: views
iteration: null
tags: ["sqlite", "index", "views", "markdown"]
created: 2026-01-05
updated: 2026-01-05
owner: null
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

# Approach

- Add `scripts/indexing/render_db_view.py` that runs a preset query and writes a Markdown view file.
- Keep outputs stable and safe to commit (but DB itself remains gitignored).
- This complements, not replaces, `scripts/backlog/generate_view.py`.

# Alternatives

# Acceptance Criteria

- A script can render at least New/InProgress/Done dashboards from the index.
- Output contains working links to the original item files.
- Running the script is auditable and path-restricted.

# Risks / Dependencies

# Worklog

2026-01-05 16:21 [agent=codex] Created from template.
