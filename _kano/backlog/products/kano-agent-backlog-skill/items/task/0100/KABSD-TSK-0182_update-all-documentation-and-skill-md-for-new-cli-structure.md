---
area: docs
created: '2026-01-12'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0182
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0035
priority: P2
state: Done
tags:
- docs
- migration
title: Update all documentation and SKILL.md for new CLI structure
type: Task
uid: 019bae59-604b-74d9-88a2-f7cc6d55eb21
updated: 2026-01-12
---

# Context

After renaming 'item' → 'workitem' and 'backlog' → 'admin', all documentation references are broken (SKILL.md, README, REFERENCE, templates, ADRs with examples).

# Goal

Update all documentation to reflect new command structure so users see correct examples and help.

# Approach

Search for 'kano-backlog item' and 'kano-backlog backlog' patterns; replace with 'kano-backlog workitem' and 'kano-backlog admin'; update help text in command files.

# Acceptance Criteria

SKILL.md canonical examples use new structure; templates use new structure; no broken command examples remain in user-facing docs; help --help output shows new group names.

# Risks / Dependencies

May miss some references; mitigated by comprehensive grep search and testing examples after update.

# Worklog

2026-01-12 02:37 [agent=copilot] Created item
2026-01-12 06:53 [agent=copilot] Started: updating all documentation for new CLI structure (workitem, admin).
2026-01-12 06:55 [agent=copilot] Done: updated all documentation references from 'item/backlog' to 'workitem/admin' (16 occurrences across SKILL.md, VERSIONING.md, templates).
