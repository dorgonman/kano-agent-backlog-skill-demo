---
id: KABSD-TSK-0312
uid: 019bf7b2-0c12-7518-816b-ffbbfd511489
type: Task
title: "Refine Ready Gate definitions by item type"
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

The initial Ready Gate implementation only enforced checks for Tasks and Bugs, leaving Epics and Features unchecked. Conversely, applying the strict Task-level requirements (Approach, Risks) to Epics leads to Goodhart's Law: users filling fields with "TBD" just to pass the gate.

# Goal

Implement granular Ready Gate definitions tailored to each item type's abstraction level to ensure meaningful quality control without enforcing irrelevant details.

# Approach

Modify `kano_backlog_core.validation.is_ready()` to apply different rules:
1. **Epic**: Requires `Context`, `Goal` (Why & What).
2. **Feature/UserStory**: Requires `Context`, `Goal`, `Acceptance Criteria` (Scope).
3. **Task/Bug**: Requires `Context`, `Goal`, `Approach`, `Acceptance Criteria`, `Risks` (Execution).

Update tests to verify each type's specific requirements.

# Acceptance Criteria

- Epic validates with only Context+Goal.
- Feature validates with Context+Goal+AC.
- Task fails if Approach/Risks are missing.
- Unit tests cover all 5 types (Epic, Feature, Story, Task, Bug).

# Risks / Dependencies

- **Risk**: Existing items might fail new validation rules (mitigate: validation is mostly on state transition/creation, not retroactive scan).
- **Dependency**: None.

# Worklog

2026-01-26 08:26 [agent=opencode] Created item [Parent Ready gate validated]

2026-01-26 08:28 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-01-26 08:30 [agent=opencode] State -> Done.
