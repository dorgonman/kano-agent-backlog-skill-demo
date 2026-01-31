---
area: cli
created: '2026-01-31'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0337
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0065
priority: P2
state: Proposed
tags:
- cli
- id-management
- ux
title: Add CLI warning when DB sequence is stale during item creation
type: Task
uid: 019c11f1-211d-74b2-9f97-229107b45951
updated: 2026-01-31
---

# Context

Agents may create items without running sync-sequences first, leading to ID collisions. The CLI should detect when DB sequence is stale and warn the user before allocating an ID.

# Goal

Add intelligent warning in 'item create' command that detects stale DB sequences and prompts user to run sync-sequences.

# Approach

1. Add staleness detection logic (compare DB max ID vs filesystem max ID)
2. In item create command, check staleness before ID allocation
3. If stale, print warning with suggested command
4. Allow user to proceed or abort
5. Add --skip-sequence-check flag for automation scenarios

# Acceptance Criteria

- item create detects stale DB sequences
- Warning message shows when stale (with sync-sequences command)
- User can proceed or abort
- --skip-sequence-check flag available
- Warning includes product name in suggested command
- Tests verify staleness detection logic

# Risks / Dependencies

False positives if filesystem scan is slow. Mitigation: cache filesystem max ID.

# Worklog

2026-01-31 10:45 [agent=opencode] Created item
2026-01-31 10:46 [agent=opencode] Parent updated: null -> KABSD-FTR-0065.
