---
area: general
created: '2026-02-01'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0350
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: Done
tags: []
title: Add HuggingFace embedding provider (sentence-transformers) for local vectors
type: Task
uid: 019c18d9-7d20-71d5-932e-8f82ae7da1d2
updated: 2026-02-01
---

# Context

We already have tokenizer HuggingFace support (token counting), but we do not yet have a local HuggingFace embedding provider that downloads/loads a sentence-transformers model and produces vectors for the vector backend. For a complete local-first pipeline, we need an embedding provider option beyond noop.

# Goal

Add an embedding provider option that uses sentence-transformers (HuggingFace) to generate embeddings locally and store/query them via existing vector backend.

# Approach

1. Add embedding provider adapter id (e.g., 'sentence-transformers' or 'huggingface') to embedding adapter factory with lazy imports and clear missing-dependency errors. 2. Use HF cache (or configurable cache root) and ensure model downloads are not committed (gitignored). 3. Integrate with existing pipeline_config schema and flattened keys (embedding_provider, embedding_model, embedding_dimension). 4. Add a small deterministic e2e test that can run without network by allowing local model path; keep online download tests optional/skipped.

# Acceptance Criteria

1. Setting embedding_provider to local HF provider produces embeddings and indexing works. 2. Missing deps produce actionable error message. 3. Works with current config layering (shared/product/topic/workset). 4. Docs describe how to run with a local model path and where caching happens.

# Risks / Dependencies

Model downloads are large and network-dependent; keep optional and support local path. Windows path handling for model cache must be robust.

# Worklog

2026-02-01 18:57 [agent=opencode] Created item
2026-02-01 19:55 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-02-01 19:55 [agent=opencode] Workset initialized: D:\_work\_Kano\kano-agent-backlog-skill-demo\_kano\backlog\.cache\worksets\items\KABSD-TSK-0350
2026-02-01 20:17 [agent=opencode] State -> Done.
