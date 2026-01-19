---
area: general
created: '2026-01-18'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-USR-0037
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: kiro
parent: KABSD-FTR-0044
priority: P2
state: Done
tags: []
title: Implement Lightweight Topic Cross-Reference System
type: UserStory
uid: 019bcccc-0127-7711-b693-a095588ecfcb
updated: 2026-01-18
---

# Context

Topics currently exist in isolation without any way to reference or link related topics. Users need a simple way to create lightweight references between topics without complex dependency management.

# Goal

Implement a simple cross-reference system that allows topics to reference related topics with bidirectional linking and automatic brief.md integration.

# Approach

1. Extend TopicManifest with related_topics field 2. Implement CLI commands for adding/removing references 3. Add bidirectional linking logic 4. Integrate references into brief.md generation 5. Add reference validation and cleanup

# Acceptance Criteria

CLI commands 'topic add-reference' and 'topic remove-reference' work, Bidirectional linking automatically maintained, References appear in brief.md Related Topics section, Reference validation prevents invalid links, Graceful handling of missing/deleted topics, Reference limit (5-10) to prevent overuse

# Risks / Dependencies

Reference overuse leading to noise - mitigate with limits and validation. Circular reference complexity - keep simple with basic cycle detection. Performance impact with many references - optimize lookup and validation.

# Worklog

2026-01-18 00:31 [agent=kiro] [model=unknown] Created item
2026-01-18 00:33 [agent=kiro] [model=unknown] State -> InProgress.
2026-01-18 00:36 [agent=kiro] [model=unknown] Cross-reference system implementation complete with bidirectional linking, CLI commands, and brief.md integration
