---
area: general
created: '2026-01-24'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-BUG-0009
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Proposed
tags: []
title: SQLite index build fails due to duplicate item IDs in backlog
type: Bug
uid: 019bf081-03c3-7380-bfd2-df2f8e50c0ad
updated: '2026-01-24'
---

# Context

SQLite index build fails with 'UNIQUE constraint failed: items.id' error. Investigation revealed 6 duplicate IDs (14 files) and 5 null IDs in the backlog. The index database is created but remains empty (0 items).

# Goal

Fix all duplicate and null IDs so SQLite index can be built successfully

# Approach

1. Manually fix 14 files with duplicate IDs 2. Fix 5 files with null IDs 3. Consider why PRIMARY KEY uses 'id' instead of 'uid' 4. Implement ID validation tool for future prevention

# Acceptance Criteria

SQLite index builds without errors; All 408+ items indexed; No duplicate IDs remain; No null IDs remain; Index status shows correct item count

# Risks / Dependencies

Manual fixes may introduce new errors; Need to understand id vs uid design rationale before making schema changes

# Worklog

2026-01-24 22:55 [agent=opencode] Created item