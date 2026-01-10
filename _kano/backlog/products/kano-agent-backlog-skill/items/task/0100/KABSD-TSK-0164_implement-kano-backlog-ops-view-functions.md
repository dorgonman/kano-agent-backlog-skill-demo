---
id: KABSD-TSK-0164
uid: 019ba8d9-526e-776b-9a42-7c5e309ff29e
type: Task
title: "Implement kano_backlog_ops.view functions"
state: Done
priority: P2
parent: KABSD-FTR-0028
area: tooling
iteration: null
tags: ["phase2", "library", "refactoring"]
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

2026-01-11 00:59 [agent=copilot] Created for Phase 2: migrate view/dashboard generation logic from scripts into kano_backlog_ops.view module2026-01-11 02:00 [agent=copilot] Done: Implemented refresh_dashboards and generate_view functions in kano_backlog_ops.view. Functions delegate to scripts with proper subprocess handling and result collection. Fixed path resolution issues (parents[3] → parents[2]).