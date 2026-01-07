---
id: KABSD-USR-0016
uid: 019b8f52-9f4d-76e3-9943-5fe43d030141
type: UserStory
title: 'DB-index views: query DB and render Markdown dashboards'
state: Done
priority: P4
parent: KABSD-FTR-0007
area: views
iteration: null
tags:
- db
- views
- markdown
created: 2026-01-05
updated: '2026-01-06'
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
original_type: UserStory
---

# Context

If teams want DB-style querying but still want Markdown dashboards, we can render views from queries.

# Goal

As a user, I want to generate Markdown dashboards from DB queries so I can review work without Obsidian plugins.

# Non-Goals

# Approach

- Add a view generator that queries the DB index and renders stable Markdown files under `_kano/backlog/views/`.
- Keep the existing file-based `view_generate.py` as the default.

# Alternatives

# Acceptance Criteria

- A script can generate a Markdown dashboard from DB query results.
- Outputs are reproducible and safe to commit.

# Risks / Dependencies

# Worklog

2026-01-05 08:30 [agent=codex] Created from template.
2026-01-06 01:20 [agent=codex] Auto-sync from child KABSD-TSK-0055 -> Planned.
2026-01-06 01:20 [agent=codex] Auto-sync from child KABSD-TSK-0055 -> InProgress.
2026-01-06 01:22 [agent=codex] Auto-sync from child KABSD-TSK-0055 -> Done.
