---
id: KABSD-TSK-0165
uid: 019ba8d9-6cf1-785e-9d37-bcfad0f259a3
type: Task
title: "Add deprecation warnings to scripts/backlog/*.py"
state: Done
priority: P1
parent: KABSD-FTR-0028
area: tooling
iteration: null
tags: ["phase3", "deprecation"]
created: 2026-01-11
updated: 2026-01-11
owner: copilot
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: [ADR-0013]
---

# Context

# Goal

# Non-Goals

# Approach

# Alternatives

# Acceptance Criteria

# Risks / Dependencies

# Worklog

2026-01-11 00:59 [agent=copilot] Created for Phase 3: add warnings directing users to use kano CLI instead of calling scripts directly
2026-01-11 01:15 [agent=copilot] Done: Created lib/deprecation.py helper, added warnings to workitem_create.py, workitem_update_state.py, view_refresh_dashboards.py. Tested successfully with formatted deprecation message.
