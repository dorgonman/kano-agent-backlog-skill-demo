---
id: KCCS-TSK-0001
uid: 019c0001-0000-7000-8000-000000000001
type: Task
title: Test KCCS product isolation
state: New
priority: P2
parent: null
area: testing
iteration: null
tags:
- test
created: 2026-01-07
updated: 2026-01-07
owner: copilot
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
Test item for KCCS product to verify product isolation in SQLite index.

# Goal
Verify that KCCS items are indexed with product="kano-commit-convention-skill".

# Approach
Create item, rebuild index, query to verify product field.

# Acceptance Criteria
- [x] Item created in KCCS product directory.
- [ ] Index query shows product="kano-commit-convention-skill".

# Worklog
2026-01-07 02:00 [agent=copilot] Created test item for product isolation verification.
