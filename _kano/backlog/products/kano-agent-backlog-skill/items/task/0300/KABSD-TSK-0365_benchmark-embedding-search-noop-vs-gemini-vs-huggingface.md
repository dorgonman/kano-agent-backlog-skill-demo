---
area: general
created: '2026-02-04'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0365
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
title: 'Benchmark embedding search: noop vs gemini vs huggingface'
type: Task
uid: 019c280e-5167-744f-8460-adebde1e0e9b
updated: 2026-02-04
---

# Context

Need a benchmark comparing search quality/perf across three embedding pipelines (noop, gemini, huggingface) using the same backlog corpus.

# Goal

Produce a topic-published report comparing retrieval quality, latency, cost, and operational tradeoffs for the three profiles. CLI --profile remains override.

# Approach

1) Build vector indexes sequentially for each profile using cache root. 2) Run search benchmark (existing benchmark command or scripted queries) with the same query set. 3) Capture metrics and summarize pros/cons. 4) Publish report under topic publish.

# Acceptance Criteria

- Report in topic publish with per-profile metrics + pros/cons. - Commands and paths documented. - Evidence of DB paths under .kano/cache/backlog.

# Risks / Dependencies

Gemini or HF API limits/download size; Windows SQLite locks if runs overlap.

# Worklog

2026-02-04 17:49 [agent=opencode] Created item
2026-02-04 17:50 [agent=opencode] Start embedding search benchmark (noop vs gemini vs huggingface) [Ready gate validated]
2026-02-04 17:54 [agent=opencode] [model=unknown] Benchmark complete. Report: _kano/backlog_sandbox/_tmp_tests/guide_test_backlog/topics/embedding-search-benchmark-0-0-3/publish/benchmark_embedding_search.md. Results: noop 0/7 hits (0.1729 ms/item), gemini 7/7 (247.3259 ms/item), sentence-transformers 7/7 (1283.2557 ms/item). Raw reports under publish/benchmark_runs/ f8e0ed303610.
2026-02-04 17:54 [agent=opencode] Benchmark report published
