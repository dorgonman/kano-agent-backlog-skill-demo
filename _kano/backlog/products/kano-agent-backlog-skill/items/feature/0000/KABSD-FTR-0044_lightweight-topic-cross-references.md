---
area: general
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0044
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: kiro
parent: null
priority: P2
state: Done
tags: []
title: Lightweight Topic Cross-References
type: Feature
uid: 019bcc9c-1be1-75a8-aa38-ec132a693c73
updated: 2026-01-18
---

# Context

Enable simple cross-referencing between related topics

# Goal

Implement lightweight topic linking without complex dependency management

# Non-Goals

- Complex dependency tracking or blocking relationships
- Enforced execution order between topics
- State synchronization between topics
- Project management features (use backlog items for that)

# Approach

Add related_topics field to manifest, CLI commands for reference management, auto-generate links in brief.md

# Alternatives

- **Manual Links**: Users manually add links in brief.md (current state)
- **Tag-based**: Use tags to group related topics (less explicit)
- **Full Dependency System**: Complex but overkill for simple references

# Acceptance Criteria

CLI commands for add/remove references, bidirectional linking, brief.md integration, graceful handling of invalid references

# Risks / Dependencies

Risk of reference overuse - mitigate with 5-10 reference limit per topic

# Worklog

2026-01-17 23:39 [agent=amazonq] [model=unknown] Created item
2026-01-18 00:31 [agent=kiro] [model=unknown] Starting implementation of lightweight topic cross-references - Phase 2 of topic system enhancements
2026-01-18 00:36 [agent=kiro] [model=unknown] Auto parent sync: child KABSD-USR-0037 -> Done; parent -> Done.
2026-01-18 00:36 [agent=kiro] [model=unknown] Phase 2 complete: Lightweight topic cross-references implemented with all acceptance criteria met
