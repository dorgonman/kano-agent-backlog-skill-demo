---
area: general
created: '2026-01-22'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0284
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Done
tags: []
title: Implement embedding E2E pipeline integration function (chunk-embed-upsert)
type: Task
uid: 019be460-ca91-7622-9946-b987a06f9cce
updated: '2026-01-23'
---

# Context

Individual components (chunking, tokenizer, embedding adapter, vector backend) are implemented but there is no single integration function that chains them together. Agents need a simple API: given a document, chunk it, embed it, and store in vector DB.

# Goal

Implement a new function index_document() in kano_backlog_ops that takes (source_id, text, pipeline_config) and performs: chunk -> budget -> embed -> upsert to vector backend. Return indexing telemetry.

# Approach

1. Create kano_backlog_ops/vector_index.py if not exists. 2. Implement index_document(source_id, text, config) function. 3. Use PipelineConfig to resolve tokenizer, embedder, backend. 4. Call budget_chunks() to get budgeted chunks. 5. Call embedder.embed_batch() on chunk texts. 6. Create VectorChunk objects and call backend.upsert(). 7. Return IndexResult dataclass with telemetry (chunks_count, tokens_total, duration_ms). 8. Add unit test in tests/test_vector_index.py using NoOp adapters.

# Acceptance Criteria

index_document() function exists; returns IndexResult with chunk count and telemetry; works with noop embedder and sqlite backend; unit test passes.

# Risks / Dependencies

Error handling for embedding failures; partial upsert recovery.

# Worklog

2026-01-22 14:25 [agent=antigravity] Created item
2026-01-23 16:30 [agent=kiro] Implemented index_document() E2E pipeline integration function in kano_backlog_ops/vector_index.py. Function takes (source_id, text, config) and performs complete pipeline: chunk -> budget -> embed -> upsert. Added IndexResult dataclass for telemetry. Created comprehensive test suite tests/test_vector_index.py with 21 test cases covering basic functionality, error handling, different text types, chunking strategies, and backend integration. All tests pass. Task completed successfully.