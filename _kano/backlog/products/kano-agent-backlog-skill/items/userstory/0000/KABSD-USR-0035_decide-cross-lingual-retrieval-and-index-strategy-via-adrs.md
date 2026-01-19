---
area: general
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-USR-0035
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: KABSD-FTR-0042
priority: P2
state: Done
tags:
- adr
- decision
- cross-lingual
- index-strategy
title: Decide cross-lingual retrieval and index strategy via ADRs
type: UserStory
uid: 019bcbf4-aed0-77ec-8d79-15407c5db49a
updated: 2026-01-19
---

# Context

The topic has two decision candidates that drive architecture and benchmarks: (1) whether cross-lingual retrieval is required; (2) whether to build a single model-agnostic index (chunk to smallest window) or per-model indexes (different windows/dims). These choices affect chunking targets, storage, and provider selection.

# Goal

As a maintainer, I have ADR-backed decisions for cross-lingual retrieval requirements and index strategy so implementation and benchmarking converge on a stable direction.

# Approach

Draft two ADRs: ADR-A (Cross-lingual requirement and default embedder policy) and ADR-B (Index strategy: model-agnostic vs per-model). Each ADR should include: decision, status, context, options considered, trade-offs, consequences, and how we will validate via benchmarks.

# Acceptance Criteria

- Two ADR tasks exist and are linked from this user story. - Each ADR clearly states assumptions (languages, privacy/offline constraints), decision, and consequences. - The benchmark harness references ADR validation criteria.

# Risks / Dependencies

Decisions may need revisiting if requirements change; keep ADRs explicit about triggers for re-evaluation (e.g., multilingual corpus, new embedder constraints).

# Worklog

2026-01-17 20:36 [agent=copilot] [model=unknown] Created item
2026-01-19 03:35 [agent=opencode] [model=unknown] Review ADR-0035 and ADR-0036, ensure consequences and validation criteria align with implemented embedding_space_id and benchmark harness.
2026-01-19 03:36 [agent=opencode] [model=unknown] ADR-0035 and ADR-0036 updated to Accepted. ADR-0035 states cross-lingual requirement and benchmark validation. ADR-0036 confirms per-model index strategy via embedding_space_id; implementation uses embedding_space_id in vector indexing and benchmark harness.
