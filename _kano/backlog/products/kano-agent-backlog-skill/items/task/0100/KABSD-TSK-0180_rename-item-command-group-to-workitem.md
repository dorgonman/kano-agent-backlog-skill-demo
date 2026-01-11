---
area: cli
created: '2026-01-12'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0180
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0035
priority: P2
state: Done
tags:
- refactor
- naming
title: Rename item command group to workitem
type: Task
uid: 019bae59-3171-7055-b38d-cfa532a20414
updated: 2026-01-12
---

# Context

Current CLI uses 'item' as command group name; conflicts with domain terminology (backlog items are work items, not generic items).

# Goal

Rename 'item' command group to 'workitem' for domain consistency and clarity.

# Approach

Rename src/kano_backlog_cli/commands/item.py to workitem.py; update cli.py registration; update command group help text.

# Acceptance Criteria

kano-backlog workitem <subcommand> works; kano-backlog item <subcommand> fails with clear error; all subcommands (create, set-ready, update-state, validate) work under workitem group.

# Risks / Dependencies

Breaking change for existing scripts; mitigated by deprecated 'item' alias with warning (similar to kano wrapper).

# Worklog

2026-01-12 02:37 [agent=copilot] Created item
2026-01-12 06:52 [agent=copilot] Started: renaming item command group to workitem.
2026-01-12 06:52 [agent=copilot] Completed: renamed item.py to workitem.py; updated cli.py registration to 'workitem' group.
