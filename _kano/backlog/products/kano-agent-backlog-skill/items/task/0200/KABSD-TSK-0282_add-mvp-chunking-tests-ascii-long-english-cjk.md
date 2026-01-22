---
area: general
created: '2026-01-22'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0282
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
title: Add MVP chunking tests (ASCII, long English, CJK)
type: Task
uid: 019be460-9965-7296-b447-d474884b2889
updated: '2026-01-23'
---

# Context

The chunking MVP (chunk_text, budget_chunks) is implemented in kano_backlog_core/chunking.py and token_budget.py but lacks dedicated test coverage. The spec requires three test cases: (1) short ASCII text, (2) long English text requiring multiple chunks, (3) CJK text with per-character tokenization.

# Goal

Create pytest test file tests/test_chunking_mvp.py with at least 3 test cases covering deterministic chunk IDs, boundary selection, overlap, and trimming behavior for ASCII, English, and CJK inputs.

# Approach

1. Create tests/test_chunking_mvp.py. 2. Import ChunkingOptions, chunk_text, budget_chunks from kano_backlog_core. 3. Write test_short_ascii: verify single chunk with stable ID. 4. Write test_long_english: verify multiple chunks with correct overlap. 5. Write test_cjk_text: verify per-character tokenization and stable IDs. 6. Run pytest and ensure all pass.

# Acceptance Criteria

tests/test_chunking_mvp.py exists; pytest tests/test_chunking_mvp.py passes; 3+ test functions covering ASCII, English, CJK; chunk IDs are deterministic (same input produces same ID across runs).

# Risks / Dependencies

Token count heuristics may differ from tiktoken; CJK edge cases with mixed scripts.

# Worklog

2026-01-22 14:24 [agent=antigravity] Created item
2026-01-23 15:30 [agent=kiro] Implemented tests/test_chunking_mvp.py with 8 comprehensive test cases covering ASCII, English, CJK, mixed text, budget integration, empty text handling, determinism validation, and boundary selection. All tests pass with 90% coverage on chunking.py and 61% on token_budget.py. Task completed successfully.