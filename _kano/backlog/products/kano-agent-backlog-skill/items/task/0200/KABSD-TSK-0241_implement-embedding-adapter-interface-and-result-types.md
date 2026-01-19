---
area: rag
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0241
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: KABSD-USR-0031
priority: P1
state: Done
tags:
- embedding
- adapter
- types
title: Implement embedding adapter interface and result types
type: Task
uid: 019bcbf5-154a-742c-b393-01c9b57827d2
updated: 2026-01-19
---

# Context

We need a provider-agnostic interface for embedding generation so we can swap providers and compare implementations while keeping chunking and vector indexing stable.

# Goal

Define and implement core embedding adapter interfaces and data models that are stable and testable.

# Approach

Add an EmbeddingAdapter abstract base class, an EmbeddingRequest/EmbeddingResult (or equivalent) dataclass payload, and error/telemetry fields (provider_id, model_name, dims, token_count, max_tokens, trimmed). Keep this dependency-free and local-first.

# Acceptance Criteria

- Interface and types exist in the correct package boundary (core vs adapters). - Types can represent batch embedding and per-text telemetry. - Unit tests cover type validation and a minimal noop implementation.

# Risks / Dependencies

If we place the interface in the wrong package boundary it will be hard to evolve; follow ADR-0013 module rules.

# Worklog

2026-01-17 20:36 [agent=copilot] [model=unknown] Created item
2026-01-19 03:00 [agent=opencode] [model=unknown] Start: implement embedding adapter interface and result types.
2026-01-19 03:18 [agent=opencode] [model=unknown] Implemented embedding adapter interface/types updates (telemetry now carries TokenCount + budget fields) and fixed OpenAI adapter imports.
