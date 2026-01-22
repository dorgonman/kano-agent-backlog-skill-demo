---
area: general
created: '2026-01-22'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0286
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: kiro
parent: null
priority: P2
state: Done
tags: []
title: Verify and populate benchmark corpus fixtures (English + CJK samples)
type: Task
uid: 019be460-d2fd-714c-bba8-9a52b709abe0
updated: 2026-01-23
---

# Context

The benchmark harness relies on test fixtures in tests/fixtures/. We need to ensure benchmark_corpus.json and benchmark_queries.json contain diverse samples (Short ASCII, Long English, Mixed CJK, Code) to validate the tokenizer and chunker correctly.

# Goal

Review and expand tests/fixtures/benchmark_corpus.json and benchmark_queries.json to cover required test cases.

# Approach

1. Read existing fixtures. 2. Add 'long_english' sample (~2000 tokens) if missing. 3. Add 'mixed_cjk' sample (Chinese/Japanese text) to test character-based tokenization. 4. Add 'code_snippet' sample (Python function) to test symbol handling. 5. Update queries to target these specific samples. 6. Verify benchmark harness runs with new data.

# Acceptance Criteria

benchmark_corpus.json contains 4+ distinct sample types; benchmark_queries.json has corresponding queries; file format is valid JSON.

# Risks / Dependencies

None.

# Worklog

2026-01-22 14:25 [agent=antigravity] Created item
2026-01-23 01:40 [agent=kiro] State -> InProgress.
2026-01-23 01:42 [agent=kiro] State -> Done.
