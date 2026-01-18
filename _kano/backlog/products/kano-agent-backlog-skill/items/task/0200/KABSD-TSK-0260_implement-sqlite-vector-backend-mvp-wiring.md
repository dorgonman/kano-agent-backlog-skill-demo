---
area: general
created: '2026-01-19'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0260
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: InProgress
tags: []
title: Implement sqlite vector backend MVP wiring
type: Task
uid: 019bd27a-4a5c-708c-9943-e3509ee6de22
updated: 2026-01-19
---

# Context

USR-0030 requires a pluggable local-first vector backend implementation that can build/query/rebuild. Code has vector adapter interfaces and a sqlite backend module, but we need end-to-end MVP wiring + tests for consistent results and persistence.

# Goal

Implement sqlite-based vector backend MVP that satisfies the vector adapter contract (prepare/upsert/delete/query/persist/load) and is selectable by config, enabling offline indexing and query.

# Approach

1) Inspect existing kano_backlog_core.vector.* interfaces and sqlite_backend implementation. 2) Fill missing contract methods and ensure deterministic persistence format. 3) Update factory to resolve backend by name/config. 4) Add minimal tests for build->query->persist->load->query consistency and per-embedding_space_id separation.

# Acceptance Criteria

- sqlite backend implements required interface methods and can be resolved via factory by name. - Can upsert vectors, query top-k, persist to disk, reload and reproduce query results. - Unit tests cover persistence + consistency + dimension mismatch errors. - No server runtime; all local file paths under product root.

# Risks / Dependencies

SQLite extension/vec maturity varies; keep MVP dependency-free using plain sqlite tables + simple distance computation or existing schema; performance is not the priority, correctness and portability are.

# Worklog

2026-01-19 02:59 [agent=opencode] [model=unknown] Created item
2026-01-19 03:00 [agent=opencode] [model=unknown] Start: implement sqlite vector backend MVP wiring and tests.
