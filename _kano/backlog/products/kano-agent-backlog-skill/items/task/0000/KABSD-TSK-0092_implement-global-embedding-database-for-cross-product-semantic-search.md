---
id: KABSD-TSK-0092
uid: 019b9473-7b04-72ff-b8f9-583a4f9d916e
type: Task
title: "Implement global embedding database for cross-product semantic search"
state: Proposed
priority: P3
parent: KABSD-FTR-0011
area: feature
iteration: 0.0.2
tags: ["embedding", "search", "cross-product"]
created: 2026-01-07
updated: 2026-01-07
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
---

# Context

We are implementing Route B (Sidecar ANN) for local-first embedding search as per ADR-0009.

# Goal

Implement a functional global retrieval system (hybrid search) that works across products in the monorepo, using a sidecar vector file and SQLite FTS5.

# Non-Goals

- Building a remote server for embeddings (that's for another task).
- Complex multi-model management (start with one).

# Approach

1.  **Schema Migration**: Update SQLite schema to include `documents`, `chunks`, and `chunks_fts` tables.
2.  **Unified Ingester**: Create `scripts/indexing/ingest.py` to parse WorkItems, ADRs, Logs, and Docs into chunks.
3.  **Specialized Chunking**: Implement chunkers for each DocType (ADR sections, Worklog time-slices).
4.  **Embedding Generation**: Implement `scripts/indexing/embed.py` with incremental update logic (`text_hash` check).
5.  **Sidecar Integration**: Implement HNSWlib sidecar writer for vector storage.
6.  **Hybrid Search CLI**: Create `scripts/indexing/search.py` that performs FTS5 keyword search and ANN semantic search, then fuses results.

# Acceptance Criteria

- `kano ingest` populates `documents` and `chunks` across all known doctypes.
- `kano search --hybrid` returns results that combine keyword relevance and semantic meaning.
- Search respects `visibility` (e.g., local worksets are only in local index).

# Risks / Dependencies

- API cost for embedding generation.
- Dependency on `hnswlib` or `numpy`.

2026-01-07 01:55 [agent=copilot] Created from template.
