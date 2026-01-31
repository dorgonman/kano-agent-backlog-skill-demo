---
area: cli
created: '2026-01-31'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0338
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
- diagnostics
title: Add DB sequence health check to doctor command
type: Task
uid: 019c11f1-2128-72aa-a2ea-d989339a074d
updated: 2026-01-31
---

# Context

The doctor command checks Python dependencies and backlog structure, but doesn't verify DB sequence health. This leads to silent ID allocation issues.

# Goal

Add DB sequence health check to doctor command to detect stale sequences proactively.

# Approach

1. Add sequence health check function (compare DB vs filesystem)
2. Integrate into doctor command output
3. Show status: OK / STALE / MISSING
4. If stale, show suggested sync-sequences command
5. Add --fix flag to auto-run sync-sequences

# Acceptance Criteria

- doctor command checks DB sequence health
- Output shows sequence status per type (EPIC, FTR, USR, TSK, BUG)
- Suggests sync-sequences command if stale
- --fix flag auto-syncs sequences
- Tests verify health check logic

# Risks / Dependencies

None - read-only check with optional fix.

# Worklog

2026-01-31 10:45 [agent=opencode] Created item
2026-01-31 10:46 [agent=opencode] Parent updated: null -> KABSD-FTR-0065.
2026-01-31 13:16 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-01-31 13:31 [agent=opencode] Added doctor sequence health check with fix
2026-01-31 13:32 [agent=opencode] Implemented DB sequence health check in doctor command with --fix flag support
