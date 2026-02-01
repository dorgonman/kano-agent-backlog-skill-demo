---
area: general
created: '2026-02-01'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0349
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
title: Benchmark paid OpenAI embeddings vs local sentence-transformers
type: Task
uid: 019c18d9-7d16-779e-9855-b00a1aa3d724
updated: 2026-02-01
---

# Context

After local sentence-transformers embedding provider exists, we want to compare quality/latency/cost against paid OpenAI embeddings. This requires a repeatable way to run the same corpus through multiple pipeline configs and record results.

# Goal

Run a small benchmark comparing local sentence-transformers vs OpenAI paid embeddings and record results as an artifact with config snapshots.

# Approach

1. Define benchmark corpus and evaluation queries (reuse existing benchmark harness if present). 2. Run two profiles: local (sentence-transformers) and paid (openai). 3. Capture effective config snapshot, timing, disk, and a small qualitative retrieval sanity check. 4. Write results under backlog artifacts.

# Acceptance Criteria

1. Benchmark report exists with side-by-side comparison. 2. Report includes effective config snapshots for both runs. 3. Clear instructions for reproducing (including how to supply OpenAI key).

# Risks / Dependencies

Requires secret (OpenAI key); keep instructions but do not store secrets. Results depend on model choices; keep methodology explicit.

# Worklog

2026-02-01 18:57 [agent=opencode] Created item
2026-02-01 20:24 [agent=opencode] Ready: benchmark plan is well-specified; proceeding to execution.
2026-02-01 20:24 [agent=opencode] Start: implement benchmark harness profile support + run local baseline. [Ready gate validated]
2026-02-01 20:28 [agent=opencode] [model=unknown] Add benchmark plumbing: --profile support, deterministic run dirs; add OpenAI profile openai-text-embedding-3-small (api_key via env:OPENAI_API_KEY).
2026-02-01 20:29 [agent=opencode] [model=unknown] Local sentence-transformers benchmark run complete: _kano/backlog/products/kano-agent-backlog-skill/artifacts/KABSD-TSK-0349/runs/f8e0ed303610/sentence-transformers-sentence-transformers-all-MiniLM-L6-v2-d384/report.md
2026-02-01 20:31 [agent=opencode] [model=unknown] Created comparison artifact: _kano/backlog/products/kano-agent-backlog-skill/artifacts/KABSD-TSK-0349/benchmark_comparison.md (local run populated; OpenAI pending).
2026-02-01 23:39 [agent=opencode] [model=unknown] OpenAI benchmark run complete: _kano/backlog/products/kano-agent-backlog-skill/artifacts/KABSD-TSK-0349/runs/f8e0ed303610/openai-text-embedding-3-small-d1536/report.md (comparison artifact updated).
2026-02-01 23:39 [agent=opencode] Done: benchmark comparison + reproducible steps captured under artifacts/KABSD-TSK-0349/.
