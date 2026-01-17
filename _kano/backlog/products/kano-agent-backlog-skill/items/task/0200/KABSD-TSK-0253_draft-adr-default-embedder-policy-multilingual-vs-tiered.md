---
area: decision
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0253
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-USR-0035
priority: P2
state: Proposed
tags:
- adr
- embedding
- multilingual
title: 'Draft ADR: default embedder policy (multilingual vs tiered)'
type: Task
uid: 019bcbf7-8557-76ab-bd43-1ff18aa398f5
updated: '2026-01-17'
---

# Context

We need to decide whether cross-lingual retrieval is required and, based on that, choose a default embedding model policy. This affects chunking targets, cost, and the benchmark criteria.

# Goal

Produce an ADR that selects a default embedder policy (single multilingual model vs tiered local-default with multilingual fallback) with clear trade-offs and validation steps.

# Approach

Write an ADR with: context (languages, offline constraints), options (single multilingual, tiered policy, English-only), decision, consequences, and how to validate via benchmark harness (token inflation, latency, retrieval spot checks). Include triggers for re-evaluation.

# Acceptance Criteria

- ADR draft exists under product decisions and is linked from this task. - Decision criteria are explicit and measurable via the benchmark harness. - The ADR states whether cross-lingual retrieval is a requirement or a non-goal for the current milestone.

# Risks / Dependencies

If requirements are unclear, the ADR may be premature; keep it explicit about assumptions and provide a path to revisit.

# Worklog

2026-01-17 20:39 [agent=copilot] [model=unknown] Created item