---
area: cli
created: '2026-01-12'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0181
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
title: Reorganize backlog subcommand to admin group
type: Task
uid: 019bae59-43f1-728b-ad4b-b60562ee9beb
updated: 2026-01-12
---

# Context

Current CLI uses 'backlog' as top-level group containing admin operations (init, index, validate, demo, persona, sandbox); this is confusing because 'backlog' sounds like the data container, not admin tools.

# Goal

Rename 'backlog' group to 'admin' to clarify that it contains administrative/setup operations, not work item data.

# Approach

Rename src/kano_backlog_cli/commands/init.py to admin.py; update cli.py registration from 'backlog' to 'admin'; update all subgroup registrations (index, demo, persona, sandbox, validate, adr).

# Acceptance Criteria

kano-backlog admin <subcommand> works (init, index, demo, persona, sandbox, validate, adr); old 'backlog' commands fail with clear error or deprecation warning.

# Risks / Dependencies

Large breaking change; all documentation and scripts reference 'backlog init', etc. Mitigated by comprehensive doc update (TSK-0182) and possible alias.

# Worklog

2026-01-12 02:37 [agent=copilot] Created item
2026-01-12 06:52 [agent=copilot] Started: renaming backlog command group to admin.
2026-01-12 06:53 [agent=copilot] Completed: renamed init.py to admin.py; updated cli.py registration from 'backlog' to 'admin'; all subgroups (index, demo, persona, sandbox, validate, adr) now nested under admin.
