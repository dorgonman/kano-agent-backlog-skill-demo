---
area: general
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0046
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: kiro
parent: null
priority: P2
state: InProgress
tags: []
title: Topic Merge and Split Operations
type: Feature
uid: 019bcc9c-3beb-7183-98a3-9be0a6efea27
updated: 2026-01-18
---

# Context

Topics sometimes grow too large or need to be combined with related work. No current mechanism to reorganize topic boundaries while preserving history

# Goal

Enable splitting large topics into focused subtopics and merging related topics while maintaining audit trail and material references

# Approach

Implement merge/split operations that redistribute items, materials, and references while preserving history in worklog

# Acceptance Criteria

CLI commands for merge and split operations, history preservation in all affected topics, material redistribution with conflict resolution, reference updates across affected topics

# Risks / Dependencies

Complex operation with potential data loss - implement dry-run mode and comprehensive validation

# Worklog

2026-01-17 23:39 [agent=amazonq] [model=unknown] Created item
2026-01-18 00:52 [agent=kiro] [model=unknown] Starting Phase 3 Feature 2: Topic Merge and Split Operations implementation
