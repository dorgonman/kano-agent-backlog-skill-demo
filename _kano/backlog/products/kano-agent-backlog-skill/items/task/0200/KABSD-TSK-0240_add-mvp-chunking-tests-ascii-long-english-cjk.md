---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0240
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: KABSD-USR-0029
priority: P2
state: InProgress
tags: []
title: Add MVP chunking tests (ASCII, long English, CJK)
type: Task
uid: 019bc76b-8329-7197-a3dc-65930667a10a
updated: '2026-01-17'
---

# Context

Add MVP tests for the three required cases (ASCII short, long English, CJK) for chunking + budget.

# Goal

Lock in expected behavior for chunk boundaries, IDs, and trimming.

# Approach

- Create fixtures for each case.
- Assert deterministic chunk IDs and budget compliance.
- Validate overlap and trimming behavior.

# Acceptance Criteria

- Tests cover all three cases.
- Tests pass and are deterministic.

# Risks / Dependencies

Tokenizer variability may require mock adapters; keep tests isolated.

# Worklog

2026-01-16 23:27 [agent=codex] [model=unknown] Created item
2026-01-16 23:28 [agent=codex] [model=gpt-5.2-codex] Parent updated: null -> KABSD-USR-0029.
2026-01-17 11:20 [agent=codex] [model=unknown] State -> InProgress.
2026-01-17 11:23 [agent=codex] [model=gpt-5.2-codex] Added MVP chunking tests for ASCII short, long English, and CJK trimming in tests/test_chunking_mvp.py using kano_backlog_core chunking + token budget modules.