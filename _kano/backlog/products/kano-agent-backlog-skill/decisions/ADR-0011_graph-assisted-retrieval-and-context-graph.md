---
date: 2026-01-09
id: ADR-0011
related_items:
- KABSD-FTR-0023
- KABSD-FTR-0007
- KABSD-USR-0015
status: Proposed
title: Graph-assisted retrieval with a derived Context Graph (weak graph first)
uid: 019bc5dc-68e2-7002-b803-1ef953c0a991
---

# Decision

Adopt **Graph-assisted retrieval** as a minimal, local-first improvement to context quality:

- Use **FTS/embeddings** to retrieve *seed* nodes
- Use a **derived Context Graph** to expand to *load-bearing neighbors* (k-hop traversal)
- Keep everything **derived/rebuildable** from canonical Markdown (file-first)

This ADR explicitly chooses **weak graph first**: only structured relationships (no LLM entity extraction).

# Context

We already have a file-first backlog with optional derived indexes (SQLite / FTS / embeddings).
Vector-only retrieval often returns text-similar chunks but misses the structural context (parents, ADR decisions, dependency chains).

We want a deterministic, auditable way to expand context that is:

- local-first
- derived/rebuildable
- incrementally maintainable
- safe (bounded expansion to avoid prompt bloat)

# Definitions

- **Context Graph**: a derived, typed graph of artifact relationships (items, ADRs, dependencies, etc.).
- **Seed set**: top-N nodes from FTS/embedding retrieval.
- **Graph expansion**: k-hop traversal from seeds over allowlisted edges with limits.

# Graph model (v1)

## Nodes

Minimum node types:

- `work_item` (Epic/Feature/UserStory/Task/Bug)
- `adr`

Optional (for embedding/fts pipelines):

- `chunk` (document chunk tied to a parent doc)

## Edges

Minimum edge types:

- `parent` (child -> parent)
- `decision_ref` (work_item -> adr)
- `relates` (work_item -> work_item)
- `blocks` / `blocked_by`

# Storage (derived)

The Context Graph is derived data. Implementations may:

1) **Materialize into SQLite**
   - reuse `items` as the node registry
   - store edges in a `links`-style table (`source_uid`, `target_uid`, `type`, optional `weight`, `source_path`)

2) **Sidecar graph artifacts**
   - `<backlog-root>/_index/graph_nodes.jsonl`
   - `<backlog-root>/_index/graph_edges.jsonl`

Both must be safe to delete and rebuild.

# Retrieval strategy (Graph-assisted RAG)

1. **Seed retrieval**
   - FTS and/or embeddings return top-N seed nodes/chunks
2. **Expand**
   - traverse k-hop (default k=1)
   - edge allowlist and fanout caps
3. **Re-rank**
   - weights by doctype and section (ADR decision > item title/acceptance > worklog)
   - optionally prioritize `Ready/InProgress` items
4. **Context packing**
   - emit a context pack describing:
     - seeds (why selected)
     - neighbors (which edge pulled them in)
     - minimal excerpts/anchors (title/ids/links)

# Config surface (indicative)

- `retrieval.graph.enabled`
- `retrieval.graph.k_hop`
- `retrieval.graph.edge_allowlist`
- `retrieval.graph.max_neighbors_per_seed`
- `retrieval.weights.*` (doctype/section/state weights)

# Consequences

- Graph-assisted retrieval becomes the preferred way to preserve traceability (seed + neighbors).
- Tooling must keep expansion bounded to avoid context explosions.
- The design stays compatible with file-scan fallback and optional SQLite/embedding acceleration.

# Non-goals

- LLM/NLP entity extraction and automatic relation mining
- server/MCP mode or cross-repo graphs

# References

- [[ADR-0004_file-first-architecture-with-sqlite-index.md|ADR-0004 File-first + SQLite index]]
- [[ADR-0009_local-first-embedding-search-architecture.md|ADR-0009 Local-first embedding search]]
- [[../items/feature/0000/KABSD-FTR-0007_optional-db-index-and-embedding-rag-pipeline.md|KABSD-FTR-0007 Optional DB index and embedding/RAG pipeline]]
- [[../items/feature/0000/KABSD-FTR-0023_graph-assisted-rag-planning-and-minimal-implementation.md|KABSD-FTR-0023 Graph-assisted RAG planning]]