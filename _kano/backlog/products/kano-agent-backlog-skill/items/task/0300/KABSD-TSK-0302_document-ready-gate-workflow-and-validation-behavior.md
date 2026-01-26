---
id: KABSD-TSK-0302
uid: 019bf654-a727-73d5-ae6a-32e9547fd08e
type: Task
title: "Document Ready gate workflow and validation behavior"
state: Done
priority: P2
parent: KABSD-FTR-0059
area: docs
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

Ready gate validation introduces new behavior and commands that agents and users need to understand. Without clear documentation, agents might not know when validation occurs, how to use --force appropriately, or what to do when validation fails.

# Goal

Document Ready gate workflow, validation behavior, and best practices in SKILL.md and references/workflow.md.

# Approach

1. Update SKILL.md with Ready gate overview and validation points
2. Update references/workflow.md with detailed workflow:
   - When validation occurs (state transition, item creation)
   - What fields are required (Context, Goal, Approach, Acceptance Criteria, Risks/Dependencies)
   - Parent check logic (checks parent if not null, skips if null)
   - How to use --force (emergency only, creates audit trail)
   - How to use check-ready command
3. Add examples of validation success and failure messages
4. Document when parent: null is appropriate (standalone tasks, top-level epics, exploratory work)
5. Link to KABSD-FTR-0058 as example of what validation prevents

# Acceptance Criteria

- SKILL.md describes Ready gate validation and links to detailed workflow
- references/workflow.md documents all validation points and behavior
- Documentation includes example commands and error messages
- Documentation explains when to use --force and when parent: null is appropriate
- Links to relevant work items (KABSD-FTR-0058, KABSD-FTR-0059)

# Risks / Dependencies

**Risks**:
- Documentation might become outdated if validation behavior changes (mitigate: keep docs minimal, point to --help output)
- Examples might not cover all edge cases (mitigate: iterate based on user feedback)

**Dependencies**:
- All validation tasks (KABSD-TSK-0303, 0304, 0305, 0306) should be implemented first to ensure accurate documentation

# Worklog

2026-01-26 02:05 [agent=opencode] Created item

2026-01-26 08:21 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-01-26 08:23 [agent=opencode] State -> Done.
