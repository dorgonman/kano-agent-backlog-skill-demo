---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-USR-0029
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-EPIC-0003
priority: P2
state: Done
tags: []
title: Chunking and token-budget embedding pipeline MVP
type: UserStory
uid: 019bc754-30c3-70fa-8740-c643948c9a9d
updated: 2026-01-23
---

# Context

As a user, I want documents chunked deterministically within a token budget so embeddings can be built and queried reliably.

# Goal

Provide an MVP chunking + token-budget pipeline that produces stable chunk IDs and respects model limits.

# Approach

- Use the contract specified in KABSD-TSK-0207 (normalization, boundary rules, overlap, chunk IDs).
- Implement token budget fitting with safety margin and trimming policy.
- Validate with three cases (short ASCII, long English, CJK) and deterministic IDs.

# Acceptance Criteria

- Stable chunk IDs for identical inputs.
- Token budget not exceeded in all cases.
- Trimming follows the defined policy and preserves metadata when present.
- Tests cover the three MVP cases.

# Risks / Dependencies

Tokenizer mismatch across models may undercount tokens; CJK token inflation reduces effective context.

# Worklog

2026-01-16 23:02 [agent=codex] [model=unknown] Created item
2026-01-16 23:08 [agent=codex] [model=gpt-5.2-codex] Parent updated: null -> KABSD-EPIC-0003.
2026-01-16 23:54 [agent=codex] [model=unknown] Auto parent sync: child KABSD-TSK-0238 -> InProgress; parent -> InProgress.
2026-01-23 01:45 [agent=kiro] State -> Done.
