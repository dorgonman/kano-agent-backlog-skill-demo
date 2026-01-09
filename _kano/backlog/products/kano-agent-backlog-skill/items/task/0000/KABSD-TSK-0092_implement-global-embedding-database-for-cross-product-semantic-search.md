---
id: KABSD-TSK-0092
uid: 019b9473-7b04-72ff-b8f9-583a4f9d916e
type: Task
title: "Implement global embedding database for cross-product semantic search"
state: Ready
priority: P3
parent: KABSD-FTR-0011
area: feature
iteration: 0.0.2
tags: ["embedding", "search", "cross-product"]
created: 2026-01-07
updated: 2026-01-09
owner: copilot
external:
  azure_id: null
  jira_key: null
links:
  relates:
  - KABSD-TSK-0056
  - KABSD-TSK-0057
  - KABSD-TSK-0124
  blocks: []
  blocked_by:
  - KABSD-TSK-0124
decisions:
- ADR-0009
---

# Context

TSK-0056/0057 built the embedding chunking schema and JSONL writer. TSK-0124 evaluated three vector library routes; **Route C (Hybrid FTS5+FAISS)** was recommended. Now implement a hybrid search system: SQLite FTS5 for keyword search + FAISS for semantic ANN search, with reciprocal rank fusion.

# Goal

Build a functional global embedding database and retrieval system (hybrid search) that works across products in the monorepo, using SQLite FTS5 (keyword) + FAISS-CPU (semantic ANN).

# Non-Goals

- Remote server for embeddings (local-first only; future task).
- Complex multi-model management (single sentence-transformers model).
- Graph-assisted retrieval (basic hybrid search only; graph features in TSK-0023).

# Approach

1. **Schema & Migration**: Add `documents`, `chunks`, `chunks_fts` (FTS5 virtual table) to SQLite schema; add migration file.
2. **Unified Ingester** (`ingest.py`): Read TSK-0057 JSONL chunks; populate documents, chunks, FTS5 index.
3. **Embedding Generation** (`embed.py`): Generate embeddings for chunks using sentence-transformers (all-MiniLM-L6-v2 or similar); store vectors in FAISS index; support incremental rebuild (text_hash tracking).
4. **Hybrid Search CLI** (`search.py`): 
   - Query FTS5 for keyword matches (BM25 scoring).
   - Query FAISS for semantic nearest neighbors.
   - Combine results via reciprocal rank fusion (RRF).
5. **Visibility & Scoping**: Support product/sandbox filters (e.g., local worksets only in local index).
6. **Fallback Mode**: Graceful degradation to FTS5-only if FAISS unavailable.

# Acceptance Criteria

- SQLite schema includes `documents`, `chunks`, `chunks_fts` tables with proper indices.
- `ingest.py` successfully ingests TSK-0057 JSONL chunks into SQLite (all metadata preserved).
- `embed.py` generates embeddings for ~2400 chunks using sentence-transformers; stores in FAISS index.
- `search.py --hybrid "query text"` returns top-10 results with combined keyword + semantic scoring.
- Test: Search for "embedding chunking" returns relevant chunks from TSK-0056/0057.
- Search respects product/sandbox filters (e.g., `--product kano-agent-backlog-skill`).
- FAISS index is rebuildable from scratch; incremental rebuild supported (via text_hash).

# Risks / Dependencies

- Embedding generation is CPU-intensive (~1-2s per 100 chunks on modern CPU).
- FAISS binary dependency (mitigated by TSK-0124 evaluation; pre-built wheels available).
- Memory usage: ~1.4GB for 2400 chunks + embeddings (384-dim vectors per chunk).
- Fallback mode if FAISS unavailable (feature flag to degrade to FTS5-only).

# Worklog

2026-01-07 01:55 [agent=copilot] Created from template.
2026-01-09 21:05 [agent=copilot] Updated context with TSK-0124 recommendation (Route C: Hybrid FTS5+FAISS). Clarified approach (use sentence-transformers for embeddings, FAISS for ANN, RRF for fusion). Added acceptance criteria (ingest TSK-0057 JSONL, generate embeddings, hybrid search + ranking). Updated dependencies/risks (embedding latency, FAISS binary dependency, memory usage). Ready for implementation in Phase 0.0.2.
