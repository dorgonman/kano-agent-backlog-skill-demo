# Workset Mechanism – Work Item Status Summary

- Generated: 2026-01-10
- Scope: Workset (Working Memory on Disk) related work items and decisions

## Workset in one paragraph

A **Workset** is a per-item, local execution cache used while an agent is implementing a Task/Bug.
It is designed to prevent drift and to keep short-term execution notes and drafts out of canonical work items.
Canonical Markdown files (work items and ADRs) remain the source of truth.

## Core principles

- Workset is **derived + ephemeral** (expected to be cleared via TTL cleanup)
- Workset lives under a cache path and is **not tracked by Git**
- Promotion is explicit:
  - decisions → ADR
  - progress → work item state + Worklog
  - deliverables → work item artifacts / PR description

## Key work items (ordered)

### 1) KABSD-TSK-0104 – Evaluate integrating working memory on disk

- State: Done
- Priority: P2
- Owner: antigravity
- Type: Task / Research / Evaluation

Purpose: compare `planning-with-files` with the Kano backlog approach.

Deliverable: `../products/kano-agent-backlog-skill/artifacts/workset_evaluation_report.md`

### 2) KABSD-FTR-0013 – Add derived index/cache layer and per-item workset cache (TTL)

- State: Planned
- Priority: P2
- Parent: KABSD-EPIC-0004 (Roadmap)
- Decisions:
  - `../products/kano-agent-backlog-skill/decisions/ADR-0011_workset-graphrag-context-graph-separation-of-responsibilities.md`
  - `../products/kano-agent-backlog-skill/decisions/ADR-0012_workset-db-canonical-schema-reuse.md`

Scope sketch:

- Derived index (SQLite) built from canonical Markdown frontmatter
- Workset cache (recommended base path per ADR-0011): `_kano/backlog/.cache/worksets/<item-id>/`
- TTL cleanup

### 3) KABSD-FTR-0015 – Execution layer: workset init/refresh/promote

- State: Planned
- Priority: P2
- Decisions: ADR-0011 / ADR-0012

Scope sketch:

- `workset_init.py`, `workset_refresh.py`, `workset_promote.py`, `workset_cleanup.py`
- Promote deliverables back to canonical items

### 4) KABSD-TSK-0217 – Clarify: Workset vs GraphRAG vs Context Graph

- State: Done
- Priority: P2

Key idea (summary):

- Workset = per-item execution cache (ephemeral)
- Repo-level derived index/graph = shared derived data for retrieval
- Context Graph can refer to (a) repo metadata graph or (b) an agent’s workflow graph; keep terminology explicit

### 5) KABSD-TSK-0115 – Core interfaces and module boundaries

- State: Done
- Priority: P1

Deliverable: `../products/kano-agent-backlog-skill/artifacts/KABSD-TSK-0115/core-interfaces-spec.md`

## High-level implementation plan

### Phase 1: Derived index foundation (FTR-0013)

- Accept ADR-0011 + ADR-0012
- Implement canonical SQLite schema (items/links/worklog/chunks/schema_meta)
- Implement `index_db.py --rebuild`
- Update `.gitignore` for `_index/` and cache paths

### Phase 2: Workset cache (FTR-0013 + FTR-0015)

- Finalize directory layout in docs/ADRs and keep scripts consistent
- Implement init/refresh/cleanup

### Phase 3: Promote + conflict considerations (FTR-0015)

- Promote deliverables and summaries back into canonical items
- Define conflict/locking strategy separately (out of scope for Workset itself)

## Related backlog items

- KABSD-TSK-0151 – Accept ADR-0011 and ADR-0012 for Workset Architecture
- KABSD-TSK-0152 – Resolve workset directory layout inconsistency
- KABSD-BUG-0002 – Add dependency links between FTR-0013 and FTR-0015
- KABSD-TSK-0153 – Verify canonical_schema.sql existence and consistency

---

End of Workset status summary.
