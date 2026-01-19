---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0224
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Done
tags: []
title: Add admin items trash command
type: Task
uid: 019bc568-78f5-727f-924a-5ec14e01bd48
updated: 2026-01-16
---

# Context

Need a CLI-safe way to remove duplicate backlog items without ad-hoc deletes; current CLI lacks item trash/delete.

# Goal

Provide admin items trash command that moves items to a per-product _trash folder and appends Worklog when appropriate.

# Approach

Add ops trash_item to move file under _trash/YYYYMMDD with optional reason, and expose via admin items trash CLI command. Ensure path stays within product root.

# Acceptance Criteria

admin items trash moves item files out of items/ to _trash; supports dry-run and logs worklog entry for items.

# Risks / Dependencies

File locks may prevent removal; allow copy + log and report status.

# Worklog

2026-01-16 14:05 [agent=codex] [model=unknown] Created item
2026-01-16 14:05 [agent=codex] [model=unknown] Implemented admin items trash command and used it to trash duplicate FTR items.
