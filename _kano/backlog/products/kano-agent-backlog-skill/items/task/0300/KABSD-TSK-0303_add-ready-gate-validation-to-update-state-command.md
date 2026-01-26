---
id: KABSD-TSK-0303
uid: 019bf654-a72f-73f7-bb25-bd9bb0f9991c
type: Task
title: "Add Ready gate validation to update-state command"
state: Done
priority: P1
parent: KABSD-FTR-0059
area: general
iteration: backlog
tags: []
created: 2026-01-26
updated: 2026-01-26
owner: opencode
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
---

# Context

The most critical enforcement point is state transitions, especially Proposed → InProgress. This is where KABSD-FTR-0058 violation occurred: KABSD-TSK-0298 transitioned to InProgress without checking if parent Feature was Ready.

Without validation at state transition, agents can start work on items that don't meet Ready gate criteria.

# Goal

Add Ready gate validation to `kano-backlog item update-state` command that blocks transitions to InProgress unless item (and parent, if not null) meet Ready gate criteria.

# Approach

1. Modify `update-state` command to check Ready gate before state transition
2. When transitioning to InProgress: call `is_ready(item)` and check parent if parent is not null
3. If validation fails: print error with missing fields and exit with code 1
4. Add `--force` flag to bypass validation (records warning in Worklog)
5. Record validation result in Worklog: "Ready gate validated" or "Ready gate bypassed (--force)"
6. Add integration tests

# Acceptance Criteria

- `kano-backlog item update-state KABSD-TSK-0001 --state InProcks if item not Ready
- Command blocks if parent exists and parent not Ready
- Command succeeds if parent is null (standalone item)
- `--force` flag bypasses validation but records warning in Worklog
- Error message clearly lists missing fields for both item and parent
- Worklog entry records validation result
- Integration tests cover: ready item, non-ready item, non-ready parent, null parent, --force bypass

# Risks / Dependencies

**Risks**:
- Too strict validation might block legitimate work (mitigate: --force escape hatch)
- Agents might abuse --force (mitigate: Worklog audit trail, periodic review)
- Only validates InProgress transition, not other states (mitigate: document this limitation, extend later if needed)

**Dependencies**:
- KABSD-TSK-0305 (is_ready function) must be implemented first
- Worklog append functionality must work reliably

# Worklog

2026-01-26 02:05 [agent=opencode] Created item

2026-01-26 06:48 [agent=opencode] State -> InProgress.
2026-01-26 08:20 [agent=opencode] State -> Done.
