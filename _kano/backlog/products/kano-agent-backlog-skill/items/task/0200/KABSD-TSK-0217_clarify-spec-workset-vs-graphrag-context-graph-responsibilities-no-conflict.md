---
area: architecture
created: 2026-01-09
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0217
iteration: null
links:
  blocked_by: []
  blocks: []
  relates:
  - KABSD-FTR-0013
  - KABSD-FTR-0015
  - ADR-0004
  - ADR-0009
owner: copilot
parent: KABSD-FTR-0013
priority: P1
state: Done
tags:
- spec
- architecture
- workset
- graphrag
- documentation
title: Clarify & Spec — Workset vs GraphRAG / Context Graph Responsibilities (No Conflict)
type: Task
uid: 019bf086-c324-73eb-adc7-428ad81771e5
updated: 2026-01-12
---

# Context

We are introducing the following concepts into Kano local-first backlog system:
- **Workset (working set)**: a task/agent-specific local cache bundle to maximize context and reduce repeated retrieval cost.
- **Graph RAG / RAG Graph**: a graph-based retrieval/navigation structure (nodes + edges) used to expand from seeds (e.g., workitems, ADRs) through relations (parent chain, references, dependencies).
- **Context Graph**: can mean either (a) the knowledge graph used for retrieval, or (b) the agent workflow/planning graph. Both should coexist with workset without conceptual conflict.

We need a clear spec to prevent future implementation from mixing responsibilities (e.g., treating per-agent worksets as global truth, or embedding full graph state only inside worksets).

Existing related work:
- KABSD-FTR-0013: Add derived index/cache layer and per‑Agent workset cache (TTL)
- KABSD-FTR-0015: Execution Layer: Workset Cache + Promote
- ADR-0004: File-First Architecture with SQLite Index
- ADR-0009: Local-First Embedding Search Strategic Evaluation
- Workset evaluation report (artifacts/workset_evaluation_report.md)

# Goal

Document and enforce the correct separation of responsibilities:
- Graph structures exist primarily to select / expand / navigate relevant context.
- Worksets exist to materialize / cache a chosen subset of context for a given task/agent/time window.
- Both are derived data; the source of truth remains the canonical backlog/ADR files.

Create a specification document (ADR or architecture spec) that includes:
- Definitions (Workset, GraphRAG/metadata graph, Context Graph)
- Non-goals
- Hard constraints
- Recommended data flow & retrieval strategy
- Clear statement that workset and graph do not conflict and why

# Non-Goals

- Do not implement server/MCP (local-first constraint).
- Do not implement "strong graph" entity extraction (LLM-based KG building) in this ticket.
- Do not treat workset as the global indexing authority.

# Approach

1. Create ADR-0011 (or similar spec document) that covers:
   - **Definitions**: Workset, Graph (GraphRAG/metadata graph), Context Graph (both meanings)
   - **Non-goals**: What we're NOT doing
   - **Hard constraints**:
     - Source of truth = canonical backlog/ADR files
     - Graph and workset are derived and must be rebuildable
     - Workset must not become the only place where graph truth lives
     - Repo-level graph index (shared derived) is the primary graph
     - Workset may include only a subgraph slice or expansion results, not the authoritative full graph
   - **Retrieval strategy**:
     - Workset-first (fast, stable context)
     - Fallback to repo-level derived index (vector/fts/graph) when insufficient
     - Optionally "incrementally enrich" the workset after fallback
   - **Data flow architecture**:
     - Build/maintain repo-level derived index (includes graph tables or separate graph DB)
     - Build workset using a profile recipe (select seeds, expand via graph k-hop closure, materialize into SQLite workset)
     - Query path (workset → repo index → optionally update workset)

2. Update related documentation if needed (KABSD-FTR-0013, KABSD-FTR-0015 context sections).

3. Verify deliverables meet acceptance criteria.

# Alternatives

- Don't create a spec document and let implementation evolve organically (rejected: high risk of role confusion)
- Create multiple smaller ADRs for each component (rejected: the key value is seeing the integration picture)
- Implement code first, document later (rejected: spec-first prevents mistakes)

# Acceptance Criteria

- [x] Created backlog task (KABSD-TSK-0217)
- [x] The doc/spec clearly states that workset and graph do not conflict and explains why
- [x] Responsibilities are unambiguous:
  - Graph = selection/expansion structure
  - Workset = materialized cache bundle
- [x] Hard constraints are explicitly listed and enforceable in future tickets
- [x] Retrieval strategy (workset-first, repo-index fallback) is documented
- [x] Document is saved as ADR-0011 in decisions/ directory
- [x] Related items (KABSD-FTR-0013, KABSD-FTR-0015) reference this ADR in their context or decisions fields

# Risks / Dependencies

- The biggest future failure mode is role confusion:
  - per-agent worksets diverge and become "truth"
  - graph only stored inside worksets (inconsistent across agents)
- Mitigation: Keep graph as repo-level derived index; keep workset as per-task derived cache.

# Worklog

2026-01-09 04:00 [agent=copilot] Created task based on problem statement. State -> InProgress.
2026-01-09 04:10 [agent=copilot] Created ADR-0011 specification document covering all required aspects: definitions, non-goals, hard constraints, responsibilities, retrieval strategy, and data flow architecture.
2026-01-09 04:15 [agent=copilot] Updated KABSD-FTR-0013 and KABSD-FTR-0015 to reference ADR-0011 in their decisions and context sections. All acceptance criteria met. State -> Done.
2026-01-12 02:55 [agent=codex-cli] Start artifact migration: classify legacy _kano/backlog/artifacts and move into product or _shared as appropriate.
2026-01-12 02:55 [agent=codex-cli] Correcting mistaken state flip caused by ID collision; item remains completed.
2026-01-12 07:20 [agent=copilot] Done: Shared artifacts migration complete. _kano/backlog/_shared/artifacts/ established as cross-product artifact root. All legacy artifacts migrated to product or shared locations. Acceptance criteria verified.
2026-01-16 11:42 [agent=codex] [model=GPT-5.2-Codex] Remapped ID: KABSD-TSK-0132 -> KABSD-TSK-0217.
2026-01-16 13:11 [agent=codex] [model=unknown] Remapped ID: KABSD-TSK-0217 -> KABSD-TSK-0217.
