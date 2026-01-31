---
area: documentation
created: '2026-01-31'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0335
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: KABSD-FTR-0065
priority: P1
state: Done
tags:
- documentation
- id-management
- agent-guidance
title: Document ID allocation mechanism and sync-sequences workflow in SKILL.md
type: Task
uid: 019c11ee-3b95-73d5-9839-9dd845b3a39e
updated: 2026-01-31
---

# Context

Agent created duplicate ID (KABSD-TSK-0001) when system already had 333 tasks. Root cause: SKILL.md does not document ID allocation mechanism, sync-sequences command, or UID vs Display ID distinction. This led to ID collision and incorrect file deletion.

# Goal

Add comprehensive documentation to SKILL.md explaining ID allocation, DB sequences, UID vs Display ID, and the sync-sequences workflow to prevent future ID collisions.

# Approach

1. Add new section 'ID Allocation and Sequence Management' to SKILL.md
2. Document UID (UUID) as true unique identifier vs Display ID (human-readable)
3. Explain sync-sequences command and when to use it
4. Add workflow: sync-sequences before creating items
5. Document trash command for handling ID conflicts
6. Add examples and anti-patterns
7. Update workflow.md with ID management best practices

# Acceptance Criteria

- SKILL.md has new section on ID allocation mechanism
- Documents UID vs Display ID distinction clearly
- Explains sync-sequences command and usage
- Provides workflow examples (before item creation)
- Documents trash command for conflict resolution
- Includes anti-patterns (don't delete files manually)
- workflow.md updated with ID management rules

# Risks / Dependencies

None - pure documentation task

# Worklog

2026-01-31 10:42 [agent=opencode] Created item
2026-01-31 10:46 [agent=opencode] Parent updated: null -> KABSD-FTR-0065.
2026-01-31 11:50 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-01-31 11:51 [agent=opencode] Added comprehensive ID allocation documentation to SKILL.md and workflow.md. Covers UID vs Display ID, sequence sync, correct workflows, conflict handling, and best practices.
