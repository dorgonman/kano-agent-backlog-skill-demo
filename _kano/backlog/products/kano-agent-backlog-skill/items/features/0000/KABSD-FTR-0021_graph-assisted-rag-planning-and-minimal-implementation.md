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
- Build/update graph from parent/child, ADR refs, and dependency links.
- Add retrieval mode flags (graph/hybrid) and context packing rules.
- Provide config for k-hop, edge allowlist, and weights.

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
