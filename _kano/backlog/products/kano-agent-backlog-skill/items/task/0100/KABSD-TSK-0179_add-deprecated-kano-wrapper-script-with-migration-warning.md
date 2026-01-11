---
area: cli
created: '2026-01-12'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0179
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0034
priority: P2
state: Done
tags:
- migration
- compat
title: Add deprecated kano wrapper script with migration warning
type: Task
uid: 019bae59-1e0f-7772-995b-f3bd12518ae4
updated: 2026-01-12
---

# Context

After renaming to kano-backlog, existing users/scripts expect kano to still work; need graceful migration path.

# Goal

Create scripts/kano as deprecated wrapper that emits migration warning and delegates to kano-backlog.

# Approach

Create new scripts/kano with shebang and logic: print deprecation warning to stderr, then exec kano-backlog with same args.

# Acceptance Criteria

scripts/kano exists and is executable; when run, prints clear migration message (e.g., 'kano is deprecated; use kano-backlog') then delegates; functionally equivalent to kano-backlog.

# Risks / Dependencies

Wrapper adds indirection; mitigated by simple exec delegation with no logic overhead.

# Worklog

2026-01-12 02:37 [agent=copilot] Created item
2026-01-12 03:24 [agent=copilot] Started: creating deprecated kano wrapper script.
2026-01-12 03:24 [agent=copilot] Completed: created scripts/kano as deprecated wrapper that warns users and delegates to kano-backlog.
2026-01-12 03:24 [agent=copilot] Completed: created scripts/kano as deprecated wrapper that warns users and delegates to kano-backlog.
