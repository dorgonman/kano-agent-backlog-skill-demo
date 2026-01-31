---
area: cli
created: '2026-01-31'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0339
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: KABSD-FTR-0065
priority: P2
state: Done
tags:
- cli
- id-management
- automation
title: Auto-sync DB sequences in item create if stale detected
type: Task
uid: 019c11f1-2137-75a3-8782-e39beba83ccf
updated: 2026-01-31
---

# Context

Even with warnings (KABSD-TSK-0337), agents may ignore them or not understand the issue. Auto-syncing sequences when stale would prevent ID collisions automatically.

# Goal

Make item create automatically sync DB sequences if staleness is detected, eliminating manual sync-sequences step.

# Approach

1. Reuse staleness detection from KABSD-TSK-0337
2. If stale detected, auto-run sync-sequences before ID allocation
3. Log the auto-sync action for audit trail
4. Add --no-auto-sync flag to disable (for testing)
5. Show brief message: 'DB sequences synced automatically'

# Acceptance Criteria

- item create auto-syncs when stale detected
- Audit log records auto-sync action
- --no-auto-sync flag disables behavior
- User sees brief confirmation message
- No performance regression (sync is fast)
- Tests verify auto-sync triggers correctly

# Risks / Dependencies

Performance impact if sync is slow. Mitigation: optimize sync-sequences or add caching.

# Worklog

2026-01-31 10:45 [agent=opencode] Created item
2026-01-31 10:46 [agent=opencode] Parent updated: null -> KABSD-FTR-0065.
2026-01-31 13:18 [agent=opencode] Start implementation [Ready gate validated]
2026-01-31 13:31 [agent=opencode] Auto-sync sequences on create with audit log
2026-01-31 13:32 [agent=opencode] Implemented auto-sync DB sequences in item create with --no-auto-sync flag and audit logging
