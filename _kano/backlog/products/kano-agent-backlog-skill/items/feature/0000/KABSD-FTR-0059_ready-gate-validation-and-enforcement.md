---
id: KABSD-FTR-0059
uid: 019bf653-eb5d-70f5-bdfc-eaf966092352
type: Feature
title: "Ready Gate Validation and Enforcement"
state: Done
priority: P2
parent: null
area: general
iteration: backlog
tags: []
created: 2026-01-26
updated: 2026-01-26
owner: None
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

Current backlog system lacks automated Ready gate validation. This led to a process violation where KABSD-FTR-0058 was created with empty Ready gate fields, but child Tasks were created and implementation started anyway. This violates the core discipline of "plan before code" and creates incomplete context for future agents.

Without automated checks, agents can:
- Create child items under non-Ready parents
- Transition items to InProgress without filling Ready gate fields
- Skip Feature-level planning and go directly to Task decomposition

This undermines the backlog's value as a durable decision trail and makes it harder to understand "why" decisions were made.

# Goal

Implement automated Ready gate validation that prevents process violations while maintaining flexibility for legitimate use cases (standalone tasks, orphan features, emergency fixes).

Provide clear feedback when validation fails and record all gate checks in Worklog for audit trail.

# Non-Goals

- Blocking all work (provide --force escape hatch for emergencies)
- Validating content quality (only check non-empty fields)
- Enforcing strict hierarchy (allow parent: null for standalone items)
- Retroactive validation of existing items (focus on new operations)

# Approach

**Ready Gate Definition**:
- Required fields: Context, Goal, Approach, Acceptance Criteria, Risks/Dependencies
- All fields must be non-empty (not just whitespace)
- Field presence checked, not content quality

**Validation Points**:
1. State transition (Proposed → InProgress): Check self + parent (if not null)
2. Child item creation: Check parent (if specified)
3. Manual check command: Check self + parent (optional)

**Parent Check Logic**:
```
if parent is not null:
    check_parent_ready()
else:
    # Standalone item, only check self
    pass
```

**Implementation  Add `is_ready()` validation function to core
2. Add `item check-ready` CLI command
3. Integrate validation into `update-state` command
4. Integrate validation into `item create` command (parent check)
5. Add tests for all validation scenarios
6. Document Ready gate workflow and --force escape hatch

# Alternatives

**Alternative 1: Strict hierarchy enforcement (no parent: null)**
- Pros: Simpler validation, forces complete planning
- Cons: Too rigid, blocks legitimate standalone tasks and hotfixes

**Alternative 2: Content quality validation (check field substance)**
- Pros: Higher quality planning
- Cons: Subjective, hard to automate, would block too much work

**Alternative 3: Soft warnings instead of hard blocks**
- Pros: More flexible, doesn't block work
- Cons: Warnings get ignored, doesn't prevent violations

**Alternative 4: Post-hoc validation only**
- Pros: Doesn't block work
- Cons: Violations already happened, harder to fix retroactively

# Acceptance Criteria

- `kano-backlog item check-ready <ID>` validates Ready gate fields and reports missing fields
- `kano-backlog item check-ready <ID>` checks parent if parent is not null
- `kano-backlog item check-ready <ID> --no-check-parent` skips parent check
- `kano-backlog item update-state <ID> --state InProgress` blocks if Ready gate incomplete (unless --force)
- `kano-backlog item create --parent <ID>` blocks if parent Ready gate incomplete (unless --force)
- `kano-backlog item create --parent null` succeeds without parent check
- `--force` flag bypasses validation but records warning in Worklog
- All validation failures provide clear error messages listing missing fields
- Tests cover: ready item, non-ready item, null parent, non-null parent, --force bypass
- Documentation describes Ready gate workflow and when to use --force

# Risks / Dependencies

**Risks**:
- Too strict validation could block legitimate work (mitigate: --force escape hatch, allow parent: null)
- Agents might abuse --force to bypass checks (mitigate: Worklog audit trail, periodic review)
- Retroactive validation of existing items could reveal many violations (mitigate: focus on new operations only)
- Definition of "non-empty" might be too loose (mitigate: start simple, refine based on usage)

**Dependencies**:
- Core item loading and parsing must be stable
- Worklog append functionality must work reliably
- CLI command structure must support validation hooks

# Worklog

2026-01-26 02:04 [agent=opencode] Created item
2026-01-26 06:43 [agent=opencode] Auto parent sync: child KABSD-TSK-0305 -> InProgress; parent -> InProgress.
2026-01-26 08:23 [agent=opencode] Auto parent sync: child KABSD-TSK-0302 -> Done; parent -> Done.
2026-01-26 08:23 [agent=opencode] State -> Done.
