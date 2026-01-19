---
id: KABSD-USR-0015
uid: 019b8f52-9f4a-754d-8d3a-81c5e41c131a
type: UserStory
title: Generate embeddings for backlog items (derivative index)
state: Done
priority: P4
parent: KABSD-FTR-0007
area: rag
iteration: null
tags:
- embedding
- rag
- index
created: 2026-01-05
updated: 2026-01-09
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
original_type: UserStory
---

# Context

Embeddings can improve retrieval (RAG) across decisions/worklogs without expanding prompt size.

# Goal

As a user, I want a hybrid retrieval pipeline that combines semantic search (embeddings) and full-text search (FTS5) across all repo artifacts (WorkItems, ADRs, Logs, Docs, Worksets) so agents can retrieve relevant context with high precision and recall.

# Approach

- Follow **Route B** (Sidecar ANN Index) as decided in [ADR-0009](_kano/backlog/products/kano-agent-backlog-skill/decisions/ADR-0009_local-first-embedding-search-architecture.md).
- Implement a **Unified Ingester** (`ingest.py`) covering multiple DocTypes with specialized chunking strategies.
- Use **SQLite FTS5** for keyword-based BM25 ranking.
- Use **ANN Sidecar** (HNSWlib/FAISS) for semantic similarity.
- Implement **Hybrid Ranking** that fuses keyword, semantic, and metadata weights (recency, doctype).
- Support **Incremental Updates** via content hashing to minimize API costs.

- Optionally expand via a derived Context Graph (seed + neighbors) for traceability; see ADR-0011 / KABSD-FTR-0023.
# Alternatives

# Acceptance Criteria

- A script can generate embeddings from a file backlog (or DB index) and write them to a local artifact store.
- Metadata includes item id/type/state/updated and source path.

# Risks / Dependencies

# Worklog

2026-01-05 08:30 [agent=codex] Created from template.
2026-01-09 11:20 [agent=codex] Linked embeddings pipeline to Graph-assisted retrieval (Context Graph) planning.
2026-01-09 17:37 [agent=copilot] Auto-sync from child KABSD-TSK-0056 -> InProgress.
2026-01-09 20:46 [agent=copilot] Auto-sync from child KABSD-TSK-0124 -> Done.
