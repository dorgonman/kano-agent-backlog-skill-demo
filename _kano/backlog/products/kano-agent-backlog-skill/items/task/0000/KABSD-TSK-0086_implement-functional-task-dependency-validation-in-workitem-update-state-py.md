---
id: KABSD-TSK-0086
uid: 019b9408-ec5e-71ff-aab6-959a653187e2
type: Task
title: "Implement functional task dependency validation in workitem_update_state.py"
state: Done
priority: P2
parent: KABSD-FTR-0042
area: general
iteration: null
tags: []
created: 2026-01-06
updated: 2026-01-07
owner: null
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

The backlog schema supports `blocks` and `blocked_by` links in the frontmatter, but the `workitem_update_state.py` script does not currently enforce these dependencies. This allows tasks to be moved to `InProgress` even if they are blocked by incomplete items.

# Goal

Prevent a work item from transitioning to `InProgress` if any item in its `blocked_by` list is not in a `Closed` or `Completed` state.

# Non-Goals

- Implementing circular dependency detection (to be addressed by CLI tool).
- Cross-product dependency validation (initial version focuses on same-product dependencies).

# Approach

1.  Update `workitem_update_state.py` to load the SQLite index or scan files to resolve IDs in `blocked_by`.
2.  Implement a check in the state transition logic (specifically when moving to `InProgress`).
3.  If any blocking item is not in an end-state, raise a validation error and abort the transition.

# Alternatives

# Acceptance Criteria

- [x] Moving a task to `InProgress` fails if it has unresolved `blocked_by` dependencies.
- [x] Error message clearly identifies which items are blocking the transition.
- [x] Moving a task to `InProgress` succeeds if all `blocked_by` items are `Closed` or `Completed`.
- [x] Items with no `blocked_by` links are unaffected.
- [x] Non-Epic items are blocked from entering `Ready` state if `parent` is null.

# Risks / Dependencies

- Potential performance impact if file scanning is required (prefer using SQLite index).

# Worklog

2026-01-06 23:59 [agent=antigravity] Created from template.
2026-01-07 02:20 [agent=antigravity] Filled in goal and approach.
2026-01-07 08:18 [agent=antigravity] Implemented functional dependency validation and orphanage prevention in Ready gate.
2026-01-07 08:36 [agent=antigravity] Integrated parent and dependency validation with the existing --force flag. Force now acts as the master skip flag for: 1) Ready gate layout, 2) Blocked-by status, and 3) Parent ID resolution/collision-safety.
