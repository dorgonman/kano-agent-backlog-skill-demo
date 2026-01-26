---
area: rag
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0042
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-EPIC-0003
priority: P2
state: Done
tags:
- embedding
- tokenizer
- benchmark
- telemetry
- config
title: Embedding providers, tokenizers, and benchmark harness
type: Feature
uid: 019bcbef-dc2a-778e-8c87-d5619170230c
updated: '2026-01-26'
---

# Context

The active topic 'embedding-preprocessing-and-vector-backend-research' surfaced gaps in our current implementation: no embedding adapter interface, only heuristic token counting, and no systematic benchmark harness. We also need a config-driven way to switch providers and strategies for evaluation.

# Goal

Provide a pluggable, local-first embedding pipeline surface (tokenizers + embedders + telemetry) and a small benchmark harness so we can rapidly compare implementations and make ADR-backed decisions.

# Approach

1) Define provider-agnostic interfaces (tokenizer + embedder) with structured telemetry (token counts, truncation, model window). 2) Add config schema and resolver so chunking/tokenizer/embedder/vector backend can be swapped via TOML layers (defaults -> product -> topic/workset). 3) Implement minimal reference providers (noop + local/counted) and keep heavy deps optional. 4) Add a benchmark harness that runs on a small multilingual sample set and records latency, memory, disk footprint, and qualitative retrieval checks.

# Acceptance Criteria

- New UserStories and Tasks exist under this Feature to cover embedder interface, tokenizer adapters, config switching, and benchmarking. - The default path remains local-first and runnable without server components. - Benchmark output format is specified and reproducible.

# Risks / Dependencies

Optional dependencies (tiktoken, transformers, sentence-transformers) may be platform-sensitive; keep them optional and gated. Benchmark quality is noisy; keep a small, deterministic corpus and record methodology. Cross-lingual requirements may change index strategy; capture via ADRs.

# Worklog

2026-01-17 20:30 [agent=copilot] [model=unknown] Created item
2026-01-19 03:00 [agent=opencode] [model=unknown] Auto parent sync: child KABSD-USR-0031 -> InProgress; parent -> InProgress.
2026-01-26 10:07 [agent=opencode] [model=unknown] All child user stories complete: USR-0031 (Done), USR-0032 (Done), USR-0033 (Done), USR-0034 (Done), USR-0035 (Done). Feature acceptance criteria met: embedding adapter interface exists, tokenizer adapters implemented, config-driven switching working, benchmark harness available, cross-lingual strategy documented in ADRs.