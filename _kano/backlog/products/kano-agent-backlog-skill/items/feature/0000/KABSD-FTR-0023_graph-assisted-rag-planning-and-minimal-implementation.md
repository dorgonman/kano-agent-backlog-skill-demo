---
id: KABSD-FTR-0023
uid: 019ba06c-2c6f-79ca-9753-aa4714e5302c
type: Feature
title: "Graph-assisted RAG planning and minimal implementation"
state: Proposed
priority: P1
parent: KABSD-EPIC-0004
area: retrieval
iteration: null
tags: ["graph-rag", "rag", "retrieval", "index"]
created: 2026-01-09
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
---

# Context

- Kano backlog is local-first with derived indexes (sqlite/fts/embedding).
- We need higher context quality by expanding via known work item and ADR links.

# Goal

- Deliver a minimal Graph-assisted retrieval flow.
- Use vector/fts for seed nodes, then k-hop expansion over structured relations.

# Non-Goals

- No LLM/NLP entity extraction or full GraphRAG pipeline.
- No server/MCP or cross-repo graph in v1.

# Approach

- Define a derived graph schema (nodes/edges/types) from existing metadata.
- Treat the Context Graph as derived data: rebuildable from canonical files or the SQLite index.
- Start with a weak/metadata graph only (no entity extraction): parent/child, ADR refs, and dependency edges.
- Retrieval flow: seed via FTS/vector -> k-hop expand (edge allowlist) -> re-rank -> context pack.
- Build/update graph from parent/child, ADR refs, and dependency links.
- Add retrieval mode flags (graph/hybrid) and context packing rules.
- Provide config for k-hop, edge allowlist, and weights.

# Links

- ADR: [[../decisions/ADR-0011_graph-assisted-retrieval-and-context-graph.md|ADR-0011 Graph-assisted retrieval with a derived Context Graph]]
- ADR: [[../decisions/ADR-0004_file-first-architecture-with-sqlite-index.md|ADR-0004 File-first + SQLite index]]
- ADR: [[../decisions/ADR-0009_local-first-embedding-search-architecture.md|ADR-0009 Local-first embedding search]]
- Feature: [[KABSD-FTR-0007_optional-db-index-and-embedding-rag-pipeline.md|KABSD-FTR-0007 Optional DB index and embedding/RAG pipeline]]
- UserStory: [[../userstory/0000/KABSD-USR-0015_generate-embeddings-for-backlog-items-derivative-index.md|KABSD-USR-0015 Embeddings/RAG (derivative index)]]

# Alternatives

- Keep vector/fts only (lower traceability).
- Jump to entity extraction (too heavy for local-first v1).

# Acceptance Criteria

- Graph can be built locally with parent/ref/depends edges.
- Query: ADR seed brings related work items; task seed brings epic chain + ADR.
- Graph is derived and rebuildable; incremental update uses mtime/hash.

# Risks / Dependencies

- Context bloat if k-hop/edge scope is not constrained.
- Ranking strategy must downweight noisy worklog content.

# Worklog

2026-01-09 09:43 [agent=codex] Created to capture Graph-assisted RAG planning scope and phased delivery.
2026-01-09 09:48 [agent=codex] Renumbered to KABSD-FTR-0023 to avoid ID collision with existing feature items.
2026-01-09 09:49 [agent=codex] Drafted planning scope, phases, and acceptance criteria for Graph-assisted RAG.
2026-01-09 11:19 [agent=codex] Added Context Graph/Graph-assisted retrieval links and clarified weak-graph approach.
