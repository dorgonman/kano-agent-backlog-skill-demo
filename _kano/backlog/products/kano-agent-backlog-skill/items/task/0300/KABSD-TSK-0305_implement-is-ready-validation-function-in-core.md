---
id: KABSD-TSK-0305
uid: 019bf654-a745-70bd-9c86-190eb9484a6b
type: Task
title: "Implement is_ready() validation function in core"
state: Done
priority: P2
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

Ready gate validation requires a core function that can check if an item meets the Ready gate criteria. This function will be used by CLI commands (update-state, create, check-ready) to enforce the discipline.

Currently there's no centralized validation logic, making it hard to consistently enforce Ready gate across different commands.

# Goal

Implement `is_ready()` validation function in `kano_backlog_core` that checks if an item has all required Ready gate fields filled (Context, Goal, Approach, Acceptance Criteria, Risks/Dependencies).

# Approach

1. Add `is_ready(item) -> tuple[bool, list[str]]` function to `kano_backlog_core/validation.py` (new module)
2. Check required fields: context, goal, approach, acceptance_criteria, risks (or risks_dependencies)
3. Field is considered "filled" if non-None and non-empty after stripping whitespace
4. Return (True, []) if ready, (False, [missing_fields]) if not ready
5. Add unit tests covering: ready item, missing single field, missing multiple fields, whitespace-only fields
6. Document function behavior and field requirements

# Acceptance Criteria

- `is_ready(item)` returns (True, []) for items with all required fields filled
- `is_ready(item)` returns (False, ['context', 'goal']) for items missing context and goal
- Whitespace-only fields are treated as empty
- Function works with all item types (Epic, Feature, UserStory, Task, Bug)
- Unit tests cover all scenarios
- Function is importable from `kano_backlog_core.validation`

# Risks / Dependencies

**Risks**:
- Field name variations (risks vs risks_dependencies) need to be handled
- Different item types might have different required fields (mitigate: start with common set)
- Whitespace detection might be too strict or too loose (mitigate: test with real examples)

**Dependencies**:
- Item model must have consistent field names
- Need to decide if Non-Goals and Alternatives are required (current: optional)

# Worklog

2026-01-26 02:05 [agent=opencode] Created item
2026-01-26 06:43 [agent=opencode] State -> InProgress.
2026-01-26 06:44 [agent=opencode] State -> Done.
