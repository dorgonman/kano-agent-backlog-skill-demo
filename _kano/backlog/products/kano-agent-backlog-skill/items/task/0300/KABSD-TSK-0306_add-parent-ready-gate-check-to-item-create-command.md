---
id: KABSD-TSK-0306
uid: 019bf654-a727-7181-9063-2c680e65a5b1
type: Task
title: "Add parent Ready gate check to item create command"
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

The KABSD-FTR-0058 violation occurred because child Tasks were created under a Feature with empty Ready gate fields. This violates the principle that parent planning must be complete before decomposing into child items.

Without validation at item creation, agents can create child items under non-Ready parents, leading to incomplete context and poor planning.

# Goal

Add parent Ready gate validation to `kano-backlog item create` command that blocks child item creation if parent exists and is not Ready.

# Approach

1. Modify `item create` command to check parent Ready gate when `--parent <ID>` is specified
2. If parent is not null: load parent and call `is_ready(parent)`
3. If parent validation fails: print error with missing fields and exit with code 1
4. If parent is null: skip parent check (standalone item)
5. Add `--force` flag to bypass validation (records warning in Worklog)
6. Record validation result in child item's Worklog: "Parent Ready gate validated" or "Parent check bypassed (--force)"
7. Add integration tests

# Acceptance Criteria

- `kano-backlog item create --parent KABSD-FTR-0001 --type task ...` blocks if parent not Ready
- `kano-backlog item create --parent null --type task ...` succeeds without parent check
- `--force` flag bypasses validation but records warning in child Worklog
- Error message clearly lists missing fields in parent
- Child item Worklog records parent validation result
- Integration tests cover: ready parent, non-ready parent, null parent, --force bypass

# Risks / Dependencies

**Risks**:
- Too strict validation might block exploratory work (mitigate: allow parent: null for standalone items, --force escape hatch)
- Agents might create items with parent: null to bypass check (mitigate: document when null is appropriate, audit trail)
- Only checks at creation, not when parent is changed later (mitigate: document this limitation)

**Dependencies**:
- KABSD-TSK-0305 (is_ready function) must be implemented first
- Item creation workflow must support validation hooks

# Worklog

2026-01-26 02:05 [agent=opencode] Created item
2026-01-26 02:06 [agent=opencode] ID collision detected: duplicate KABSD-TSK-0302. Renumbered to KABSD-TSK-0306.

2026-01-26 08:20 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-01-26 08:21 [agent=opencode] State -> Done.
