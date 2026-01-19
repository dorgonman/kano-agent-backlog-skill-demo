---
date: 2026-01-07
deciders:
- agent=antigravity
- user
id: ADR-0009
status: Proposed
title: Local-First Embedding Search Strategic Evaluation
uid: 019bc5dc-68e1-72f0-bffa-18ae99b7de13
---

# Local-First Embedding Search Strategic Evaluation

## Context and Problem Statement

As the backlog grows with hundreds of items, agents need a way to perform semantic search to find relevant context (e.g., "Why did we decide to use ULID?" or "Find similar tasks for refactoring the indexer"). 

Our architecture is "Local-First":
- **Canonical Store**: Markdown files.
- **Derived Store**: SQLite index (rebuildable).

We need an embedding search solution that:
1.  Integrates well with the existing local-first workflow.
2.  Minimizes complex binary dependencies for cross-platform support.
3.  Follows the "derived data" philosophy (indices can be thrown away and rebuilt).

## Decision Drivers

- **Deployment Simplicity**: Zero-install or easy-install on developer machines.
- **Consistency**: The vector index must stay in sync with the Markdown/SQLite data.
- **Philosophical Alignment**: Keep the source of truth in files; everything else is a performance optimization.

## Considered Options

### Route A: SQLite + Vector Extension (e.g., `sqlite-vec`)

Use a SQLite extension to handle vector storage and ANN (Approximate Nearest Neighbor) search directly in the database.

- **Good**, because: Single database item; relational + vector joins in one query.
- **Bad**, because: Loading binary extensions in Python (`sqlite3.load_extension`) is notoriously finicky across platforms (Windows vs Linux vs macOS). Packaging these binaries into the skill makes it "heavy".

### Route B: SQLite (Metadata) + Sidecar ANN Index (e.g., FAISS / HNSWlib)

Keep the metadata (ID, title, state) in the existing SQLite index. Store the high-dimensional vectors in a separate, dedicated index file (sidecar).

- **Good**, because:
    - Highly decoupled: We can swap FAISS for HNSWlib or even a plain NumPy file without touching the SQLite schema.
    - Fits the "Kano Philosophy": The vector index is just another derived artifact.
    - Performance: Sidecar indices like HNSWlib are extremely fast for mmap-based local search.
- **Bad**, because: Requires a "two-step" lookup (Search Sidecar -> Map IDs -> Fetch SQLite) and a dual-sync process during ingestion.

### Route C: Postgres + pgvector (Shared Derived Store)

Move the derived index to a remote Postgres instance with the `pgvector` extension.

- **Good**, because: Perfect for multi-agent/multi-remote collaboration where a shared "claim" or "lock" system is needed anyway.
- **Bad**, because: Requires a server. Not "local-first" in the spirit of the project. High latency for simple local tasks.

## Decision Outcome

Chosen option: **Route B (Sidecar ANN Index)** for local-first environments, with an optional path to **Route C** for shared/remote usage.

### Implementation Strategy

1.  **Unified Ingestion**:
    - **DocTypes**: Cover `WorkItem`, `ADR`, `Worklog`, `Workset` (local cache), and `Skill Docs`.
    - **Metadata Store**: SQLite `documents` table tracks `uid`, `doctype`, `product`, `path`, and `content_hash`.
    - **Chunking**: Document-aware chunking (e.g., ADR sections, Worklog per-day). Stores in `chunks` table with `parent_doc` and `section` metadata.
    - **FTS5**: Index chunk text in SQLite FTS5 for sub-millisecond keyword search and BM25 ranking.

2.  **Embedding & Vector Sidecar**:
    - **Sidecar**: HNSWlib or FAISS index file (`index_<product>.bin`).
    - **Incremental Sync**: Only compute embeddings for chunks where `text_hash` has changed.
    - **Mapping**: SQLite stores `chunk_id -> vector_id` to bridge the sidecar back to metadata.

3.  **Hybrid Search & Ranking**:
    - **Query Path**:
        - `Structural`: SQLite B-Tree (product/type/status).
        - `Keyword`: SQLite FTS5 (BM25).
        - `Semantic`: Sidecar ANN (Cosine similarity).
    - **Fusion**: Combine scores using weighted logic:
        - `w_exact`: High weight for ID matches.
        - `w_type`: Priority for ADR Decisions and WorkItem Titles.
        - `w_recency`: Decay score for older content.
        - `w_visibility`: Distinguish between `canonical` and `local_cache`.

## Pros and Cons of the Consequences

### Good
- **Portable**: The sidecar can be shared or ignored by git easily.
- **Fast**: Local search is sub-millisecond.
- **Robust**: If the sidecar breaks, we just delete it and rerun the indexing script.
- **Comprehensive**: Covers "everything" in the repo while preserving visibility boundaries (Local Workset vs Canonical ADRs).

### Bad
- **Sync Logic**: Need to handle incremental updates (delete old vectors if file is deleted/moved).
- **Tooling**: Requires an ANN library in the dependencies (e.g., `hnswlib` or `sentence-transformers`/`faiss-cpu`).

## References

- [KABSD-USR-0015: Generate embeddings for backlog items](../items/userstory/0000/KABSD-USR-0015_generate-embeddings-for-backlog-items-derivative-index.md)
- [ADR-0004: File-first architecture with SQLite index](ADR-0004_file-first-architecture-with-sqlite-index.md)


## Graph-assisted retrieval (Context Graph)

In addition to keyword/semantic retrieval, we can improve precision and traceability by expanding the seed set
via a derived Context Graph (parent chain, ADR refs, dependency links).

Minimal strategy:
- Retrieve seeds via FTS/ANN
- Expand k-hop over allowlisted edges
- Re-rank and pack context (seed + neighbors)

See:
- [[ADR-0011_graph-assisted-retrieval-and-context-graph.md|ADR-0011 Graph-assisted retrieval with a derived Context Graph]]
- [[../items/feature/0000/KABSD-FTR-0023_graph-assisted-rag-planning-and-minimal-implementation.md|KABSD-FTR-0023 Graph-assisted RAG planning]]