---
area: decision
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0254
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
- index-strategy
- vector
title: 'Draft ADR: index strategy (single model-agnostic vs per-model indexes)'
type: Task
uid: 019bcbf7-b34f-7797-8786-c657c426e9b1
updated: '2026-01-17'
---

# Context

If we support multiple embedders, they may have different max token windows and output dimensions. We need to decide whether to chunk to the smallest window and keep a single index, or keep per-model indexes to preserve larger windows and avoid dimensionality conflicts.

# Goal

Produce an ADR that decides index strategy (single model-agnostic vs per-model) with consequences for chunking, storage, and benchmarking.

# Approach

Write an ADR describing: options, pros/cons, storage and rebuild implications, compatibility constraints (dims/metric), and how to validate via benchmarks (rebuild time, storage footprint, quality). Clarify how chunk IDs and versioning interact with per-model indexes.

# Acceptance Criteria

- ADR draft exists under product decisions and is linked from this task. - ADR clearly states the chosen strategy and how to handle future provider changes. - Benchmark harness includes metrics relevant to the chosen strategy (storage, rebuild time, truncation rate).

# Risks / Dependencies

Per-model indexes increase complexity and storage; model-agnostic indexes may sacrifice quality for long-context models. Decision should be revisitable with clear triggers.

# Worklog

2026-01-17 20:39 [agent=copilot] [model=unknown] Created item