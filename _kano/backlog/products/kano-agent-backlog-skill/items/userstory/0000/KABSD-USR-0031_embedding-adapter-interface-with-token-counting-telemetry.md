---
area: rag
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-USR-0031
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0042
priority: P1
state: Proposed
tags:
- embedding
- adapter
- telemetry
title: Embedding adapter interface with token-counting telemetry
type: UserStory
uid: 019bcbf0-58b4-7308-81e0-4aaed24cd43b
updated: '2026-01-17'
---

# Context

We currently have deterministic chunking and a vector backend adapter, but there is no embedding provider abstraction that can be swapped for evaluation. We also need observability around token counting and truncation so we can enforce model windows safely.

# Goal

As a developer, I can generate embeddings through a provider-agnostic adapter interface that returns vectors plus structured telemetry (token counts, truncation, model window) so indexing is reliable and comparable across providers.

# Approach

Define an EmbeddingAdapter contract (e.g., embed(texts) -> results) and an EmbeddingResult payload containing: provider_id, model_name, dims, vector, token_count (TokenCount), max_tokens, trimmed, warnings. Provide a small factory/resolver that selects the adapter by config. Implement a noop adapter for tests and an initial local adapter stub that can be extended later.

# Acceptance Criteria

A core adapter interface exists and is importable from the correct module boundary. A factory can resolve an adapter by config name. Telemetry fields are present and validated in tests, including truncation event reporting.

# Risks / Dependencies

Embedding libraries are heavy and optional; keep dependencies optional and adapters lazily imported. Token counting may be approximate for some providers; mark exact vs heuristic in telemetry.

# Worklog

2026-01-17 20:31 [agent=copilot] [model=unknown] Created item