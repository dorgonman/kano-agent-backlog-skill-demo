---
area: general
created: 2026-01-05
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0006
iteration: null
links:
  blocked_by: []
  blocks: []
  relates: []
owner: null
parent: KABSD-EPIC-0001
priority: P2
state: Proposed
tags: []
title: Conflict Prevention Mechanism
type: Feature
uid: 019bac4a-684e-77f1-ac91-9f72da242359
updated: 2026-01-05
---

# Context

Currently, multiple agents (or humans) can edit the same backlog item without any system-level coordination. If two agents pick up the same task, it results in wasted effort and merge conflicts.

# Goal

Prevent race conditions and double-handling of work by enforcing "Item Ownership".

# Non-Goals

- Complete locking of the file system (this is a logic-level check in scripts only).
- Handling manual edits (we can only guard script-based interactions).

# Approach

1.  **Auto-assign Owner**: When an agent moves an item to `InProgress` via `update_state.py`, automatically set the `owner` frontmatter to that agent.
2.  **Conflict Guard**: If an agent tries to `update_state.py` on an item that is already `InProgress` and owned by someone else, reject the operation with a helpful error.

# Acceptance Criteria

- [ ] `update_state.py --actions start` sets `owner: <agent>`.
- [ ] `update_state.py` blocks updates if `owner` mismatches and state is `InProgress`.
- [ ] Error message clearly indicates who owns the item.

# Risks / Dependencies

- Agents must identify themselves consistently (addressed by previous Feature 0005).

# Worklog

2026-01-05 00:03 [agent=antigravity] Created from template.