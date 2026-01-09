---
id: KABSD-TSK-0124
uid: 019b8f52-9f4a-754d-8d3a-0124-research
type: Task
title: 'Research: Comparative Performance and Deployment of SQLite-Vec vs FAISS vs
  HNSWlib'
state: Done
priority: P3
parent: KABSD-USR-0015
area: research
iteration: 0.0.2
tags:
- embedding
- research
- benchmarking
created: 2026-01-07
updated: 2026-01-09
owner: copilot
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks:
  - KABSD-TSK-0092@019b9473
  blocked_by: []
decisions:
- ADR-0009
---

# Context

TSK-0056/0057 established the embedding schema and JSONL chunking. Now we need to decide: which vector search library best fits local-first deployment?

Route A (SQLite-Vec): Pure SQL extension; no external binary dependency.
Route B (Sidecar ANN): Separate process; HNSWlib or FAISS-CPU for nearest-neighbor search.
Route C (Hybrid FTS5+ANN): Combine SQLite FTS5 keyword search with sidecar ANN for semantic search.

We must evaluate real installation/deployment complexity, cross-platform viability, and rebuild incremental-ness.

# Goal

Evaluate the three routes with small prototypes to confirm the best path for the Kano platform. Produce a comparison report (or ADR-0009 addendum) and recommend the default vector library.

# Non-Goals

- Production-scale optimization (focus on feasibility, not speed).
- Building the full search system yet (just prototype enough to decide).

# Approach

1. **Route A Prototype**: Install `sqlite-vec` (if available on PyPI); test on Windows and Linux; document wheel availability, load complexity, and SQL extension loading process.
2. **Route B Prototype**: Install `hnswlib` and `faiss-cpu`; benchmark query speed on ~100-1000 synthetic embeddings; check installation size and binary dependencies.
3. **Route C Hybrid Test**: Prototype FTS5 keyword search + sidecar ANN retrieval; test fusion (e.g., simple reciprocal rank fusion).
4. **Cross-Platform Audit**: Verify pre-built binary reliability on Windows/Linux/macOS; document any C++ compiler requirements.
5. **Rebuild Semantics**: For each library, confirm how incremental updates and full rebuilds work (e.g., FAISS index reload, sqlite-vec data re-index).
6. **Comparative Report**: Create a table summarizing installability, deployment simplicity, query latency, and rebuild effort for each route.

# Alternatives

- Stay with full-text search only (FTS5) → rejected: loses semantic meaning.
- Use a remote embedding service → rejected: violates local-first constraint.

# Acceptance Criteria

- A comparison report (artifact or updated ADR-0009) with objective findings from prototypes.
- Prototype code/scripts for each route (at least pseudocode or shell commands).
- Recommendation on "default" library with justification (e.g., "Route C: FTS5+HNSWlib for hybrid search with local control").
- Risks and mitigations documented (e.g., "Binary dependency mitigated by pre-built wheels; fallback to FTS5-only mode").

# Risks / Dependencies

- Native binary installs might fail in restricted environments (mitigated by fallback to FTS5-only or wheel pre-staging).
- FAISS/HNSWlib API instability across versions (manage with pinned requirements).
- sqlite-vec might not be available on all platforms (research availability).

# Worklog

2026-01-07 23:10 [agent=antigravity] Created for comparative research as requested by user.
2026-01-09 20:50 [agent=copilot] Filled Ready sections; clarified three routes and acceptance criteria (report + recommendation + prototype scripts). Set scope: feasibility & deployment, not performance.
2026-01-09 21:00 [agent=copilot] Evaluated all three routes: (A) sqlite-vec pre-built wheels available but v0.1.6 (immature); (B) HNSWlib build-fails on Windows, FAISS-CPU works with pre-built wheels; (C) Hybrid FTS5+FAISS recommended. Created comprehensive evaluation report at artifacts/KABSD-TSK-0124/embedding_search_library_evaluation.md. Recommendation: Route C (Hybrid FTS5+FAISS) for production Kano platform with FTS5-only fallback. Updated plan: proceed to TSK-0092 (implement global embedding database with FTS5+FAISS backend).
2026-01-09 20:45 [agent=copilot] State -> InProgress.
2026-01-09 20:46 [agent=copilot] State -> Done.
