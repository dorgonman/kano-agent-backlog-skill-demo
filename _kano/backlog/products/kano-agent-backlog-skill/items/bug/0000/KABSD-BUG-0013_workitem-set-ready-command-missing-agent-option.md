---
area: general
created: '2026-02-06'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-BUG-0013
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: Done
tags: []
title: workitem set-ready command missing --agent option
type: Bug
uid: 019c3063-8f80-74a7-bdcb-7fea22a5f67a
updated: 2026-02-06
---

# Context

The workitem set-ready command does not support the --agent option. All workitem commands should support --agent for auditability per SKILL.md rules.

# Goal

Add --agent option to set-ready command and append Worklog entry when Ready fields are updated.

# Approach

1. Add --agent parameter to set_ready() function 2. Track which fields are updated 3. Append Worklog entry with agent attribution 4. Test the fix

# Acceptance Criteria

- set-ready accepts --agent parameter - Help shows --agent as required option - Worklog is appended when fields are updated

# Risks / Dependencies

None - minimal change to existing code

# Worklog

2026-02-06 08:39 [agent=opencode] Created item
2026-02-06 08:39 [agent=opencode] Starting fix for missing --agent option [Ready gate validated]
2026-02-06 08:41 [agent=opencode] Updated Ready fields: Context, Goal, Approach, Acceptance Criteria, Risks
2026-02-06 08:41 [agent=opencode] Fixed: Added --agent option to set-ready command. Worklog is now appended when Ready fields are updated.
