---
area: general
created: '2026-01-19'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0261
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
title: Implement deterministic benchmark harness for chunking/embedding/vector
type: Task
uid: 019bd28c-21f7-7064-b287-1d88cbb09794
updated: 2026-01-19
---

# Context

USR-0034 requires a repeatable local-first benchmark to compare chunking/tokenizer/embedding/vector configurations including multilingual/CJK token inflation and basic query sanity. We have chunking + token budget + embedder + vector backend pieces but lack a reproducible harness and deterministic reports.

# Goal

Provide a benchmark harness that runs locally and outputs deterministic reports (Markdown/JSON) including config snapshot, token stats, chunk stats, embedding latency/dims, truncation events, and optional vector query sanity checks.

# Approach

1) Add a kano_backlog_ops.benchmark_embeddings module that: loads effective config (including topic overrides), fingerprints corpus+queries, runs chunking/token budget, optionally runs embedding+vector indexing depending on provider/backend, and emits stable JSON/MD artifacts. 2) Add a CLI entrypoint under kano-backlog (likely in existing 'backlog' or new 'benchmark' group) that invokes the op. 3) Add tests for deterministic report structure and for chunk-only mode (no external deps).

# Acceptance Criteria

- Benchmark command exists and runs locally without server runtime. - Report includes: effective config snapshot, token stats per language (at least ASCII vs CJK), chunk stats, embed latency/dims, truncation events. - Supports chunk-only mode when embedding provider is noop or disabled. - Output is deterministic (sorted keys/rounded floats), suitable for diffing.

# Risks / Dependencies

Optional deps may be absent; harness must degrade gracefully. Quality evaluation is subjective; start with deterministic metrics and minimal qualitative checks.

# Worklog

2026-01-19 03:19 [agent=opencode] [model=unknown] Created item
2026-01-19 03:19 [agent=opencode] [model=unknown] Start: implement deterministic benchmark harness per USR-0034.
2026-01-19 03:35 [agent=opencode] [model=unknown] Implemented deterministic benchmark harness CLI (kano-backlog benchmark run) with chunk-only and embed+vector modes, deterministic JSON/MD outputs, and fixtures. Verified via pytest skills/kano-agent-backlog-skill/tests/test_benchmark_harness_deterministic.py and benchmark run producing report under artifacts/KABSD-TSK-0261/runs/.
