---
id: KABSD-TSK-0036
uid: 019b8f52-9f9d-76cc-98bc-bcd947dfe229
type: Task
title: Sync parent state from child status changes
state: Done
priority: P2
parent: KABSD-FTR-0001
area: workflow
iteration: null
tags:
- state
- sync
created: 2026-01-05
updated: '2026-01-06'
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

Parent items remain in Proposed/Planned even when children progress to InProgress or Done, which makes the tree look inconsistent.

# Goal

Auto-advance parent states (forward-only) when child items move through states, without ever downgrading parents or touching child states.

# Non-Goals

- Enforcing strict if-and-only-if state equality across levels.
- Auto-downshifting parent state when children move backward.
- Forcing child states based on parent edits.

# Approach

- Extend update_state to optionally sync ancestors based on child states.
- Use forward-only rules: Proposed -> Planned -> InProgress -> Done (no downgrade).
- Treat Ready/Review/Blocked as part of the child-to-parent roll-up mapping.

# Alternatives

Manually update parent states after each child change.

# Acceptance Criteria

- Updating a child state can auto-advance parent states.
- Parents are never auto-downgraded.
- Child states are never changed by parent edits.

# Risks / Dependencies

- Requires careful roll-up rules to avoid surprising state jumps.

# Worklog

2026-01-05 00:18 [agent=codex] Created from template.
2026-01-05 00:18 [agent=codex] Filled Ready sections for parent state sync.
2026-01-05 00:18 [agent=codex] State -> Ready.
2026-01-05 00:19 [agent=codex] Implementing forward-only parent state sync in update_state.
2026-01-05 00:21 [agent=codex] Added forward-only parent sync rules to update_state and documented state semantics.
