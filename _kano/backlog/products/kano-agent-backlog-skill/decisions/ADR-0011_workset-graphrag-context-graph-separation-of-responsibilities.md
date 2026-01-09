---
id: ADR-0011
title: "Workset vs GraphRAG / Context Graph — Separation of Responsibilities"
status: Proposed
date: 2026-01-09
related_items: [KABSD-TSK-0132, KABSD-FTR-0013, KABSD-FTR-0015, ADR-0004, ADR-0009]
supersedes: null
superseded_by: null
deciders:
  - agent=copilot
---

# Decision

We adopt a clear separation of responsibilities between:
1. **Workset**: Per-agent/per-task materialized cache bundle (local, ephemeral, task-scoped)
2. **GraphRAG / Metadata Graph**: Repo-level derived navigation/retrieval structure (nodes + edges, shared, rebuildable)
3. **Context Graph**: Either knowledge graph (same as GraphRAG) or agent workflow/planning graph (different layer, no conflict)

**Core Principle**: Workset and Graph are BOTH derived data. Neither is the source of truth. The canonical backlog/ADR files remain the single system of record.

# Context and Problem Statement

As Kano evolves to support:
- Multi-agent collaboration with context management (KABSD-FTR-0013, KABSD-FTR-0015)
- Graph-based retrieval and semantic search (ADR-0009)
- Workset-based execution memory (workset_evaluation_report.md)

We face a critical architectural risk: **role confusion** between components.

## The Risk: Role Confusion

Without clear boundaries, future implementations might:
- Treat per-agent worksets as the "truth" instead of rebuildable cache
- Store the authoritative graph structure ONLY inside worksets (leading to divergence across agents)
- Mix retrieval logic (graph expansion) with cache storage (workset)
- Create worksets that cannot be rebuilt from canonical data

This ADR prevents these failure modes by establishing hard constraints and data flow patterns.

# Definitions

## 1. Workset (Working Set)

**What it is**:
- A **materialized bundle** (typically a SQLite file + optional filesystem cache) containing a selected subset of items, chunks, and summaries.
- Usually **per-agent** or **per-task**, scoped to a specific time window or work session.
- Stored in `.cache/worksets/<agent_or_task>/` and **NOT tracked in Git**.

**Purpose**:
- Maximize context relevance and reduce repeated retrieval cost during task execution.
- Provide stable, fast access to "current working context" without re-querying repo-level indices.
- Support execution-layer memory patterns (plan.md, notes.md, deliverable.md) as described in workset_evaluation_report.md.

**Key Properties**:
- **Derived**: Built from canonical files + repo-level derived index
- **Rebuildable**: Can be deleted and reconstructed at any time
- **Ephemeral**: May have TTL (time-to-live) and automatic cleanup
- **Local**: Not the source of truth; promotes back to canonical on important updates

**What it is NOT**:
- NOT the system of record (canonical files are)
- NOT the authoritative graph store (repo-level graph index is)
- NOT shared across agents (each agent/task has its own)
- NOT version-controlled in Git

## 2. GraphRAG / Metadata Graph

**What it is**:
- A **derived navigation/index structure** with nodes and edges:
  - **Nodes**: workitems, ADRs (optionally commits, worklog entries, skill docs later)
  - **Edges**: parent_of, references, depends_on, blocked_by, relates_to
- Used for **retrieval expansion** and **context assembly**.
- Stored at **repo level** (e.g., in SQLite `links` table, or separate graph DB file).

**Purpose**:
- Enable graph-based queries: "Find all tasks blocking feature X"
- Support k-hop expansion: "Given seed items, expand to related context"
- Provide structured navigation for RAG (Retrieval-Augmented Generation)

**Key Properties**:
- **Shared**: One graph per product/repo (not per-agent)
- **Derived**: Built from canonical file frontmatter (parent, links.relates, etc.)
- **Rebuildable**: Can be rebuilt from files + frontmatter
- **Queryable**: Supports graph queries, traversal, expansion

**What it is NOT**:
- NOT stored only inside worksets (worksets may include subgraph slices, but the authoritative graph is repo-level)
- NOT "strong KG" with LLM-extracted entities (that's a future enhancement, not the base metadata graph)
- NOT the source of truth (canonical files are)

## 3. Context Graph (Dual Meaning)

The term "Context Graph" can mean two different things, both valid and non-conflicting:

### 3a. Context Graph = Knowledge Graph (Same as GraphRAG)
In RAG/retrieval contexts, "context graph" often means the knowledge graph used for retrieval.
- **Same as**: GraphRAG / Metadata Graph (defined above)
- **Purpose**: Navigate and expand context for LLM queries

### 3b. Context Graph = Agent Workflow / Planning Graph
In agent orchestration contexts, "context graph" can mean the DAG (Directed Acyclic Graph) of agent tasks/steps.
- **Different layer**: This is about agent execution flow, not backlog item relationships
- **Purpose**: Plan and coordinate multi-step agent workflows
- **No conflict with Workset or GraphRAG**: This is a workflow orchestration concept, not a data indexing concept

**Clarification**: Both meanings are valid. They address different layers and do not conflict with the Workset/GraphRAG separation.

# Hard Constraints (Enforceable in Future Tickets)

1. **Source of Truth = Canonical Backlog/ADR Files**
   - All writes MUST go to Markdown files in `_kano/backlog/products/<product>/items/` or `decisions/`
   - Neither Workset nor Graph can become the primary write target

2. **Graph and Workset are Derived and Must be Rebuildable**
   - Both can be deleted and reconstructed from canonical files
   - No essential data lives ONLY in cache or index

3. **Workset Must Not Become the Only Place Where Graph Truth Lives**
   - Repo-level graph index (shared derived) is the **primary graph**
   - Workset may include only a **subgraph slice** or expansion results
   - Workset does NOT store the authoritative full graph

4. **Retrieval Strategy (Workset-First with Fallback)**
   - Query workset first (fast, stable context)
   - Fallback to repo-level derived index (vector/FTS/graph) when insufficient
   - Optionally "incrementally enrich" the workset after fallback
   - Never skip repo-level index and rely solely on workset

# Non-Goals

This specification explicitly does NOT include:

- **Server/MCP implementation**: This is a local-first spec (per AGENTS.md temporary clause)
- **Strong graph / LLM-based KG**: Entity extraction, relationship mining via LLM (future enhancement)
- **Workset as global indexing authority**: Worksets are local/ephemeral, not authoritative
- **Real-time sync between worksets**: Each agent/task workset is independent
- **Graph database engine choice**: This spec is agnostic to implementation (SQLite, Neo4j, plain files)

# Data Flow Architecture

## 1. Build/Maintain Repo-Level Derived Index

```
Canonical Files (Markdown + frontmatter)
    ↓
  Parse & Extract
    ↓
Repo-Level Derived Index (SQLite + sidecar ANN)
├── items table (metadata)
├── links table (graph edges)  ← PRIMARY GRAPH
├── chunks table (text chunks)
├── FTS5 index (keyword search)
└── Sidecar ANN (vector embeddings) ← per ADR-0009
```

**Graph Tables** (in SQLite or separate graph DB):
- `links(source_uid, target_uid, type)` stores all edges
- Rebuilt from frontmatter: `parent`, `links.relates`, `links.blocks`, `links.blocked_by`

## 2. Build Workset Using Profile Recipe

```
Workset Build Process:
1. Select seeds (e.g., active/in-progress/claimed/recent items)
2. Expand via graph k-hop closure:
   - Follow parent chain upward
   - Follow references (links.relates)
   - Follow dependencies (links.depends_on, links.blocks)
3. Materialize into SQLite workset:
   - Copy relevant items/chunks from repo index
   - Include subgraph slice (only edges relevant to this workset)
   - Add workset manifest (seeds, expansion params, timestamp)
```

**Workset Structure** (SQLite file):
```sql
-- Workset metadata
CREATE TABLE workset_manifest (
  workset_id TEXT PRIMARY KEY,
  agent TEXT,
  task_id TEXT,
  created_at TEXT,
  ttl_hours INTEGER,
  seed_items TEXT -- JSON array of seed UIDs
);

-- Cached items (subset from repo index)
CREATE TABLE cached_items (
  uid TEXT PRIMARY KEY,
  -- ... copy of repo index item fields
);

-- Subgraph slice (only edges relevant to this workset)
CREATE TABLE cached_links (
  source_uid TEXT,
  target_uid TEXT,
  type TEXT,
  PRIMARY KEY (source_uid, target_uid, type)
);

-- Cached chunks (for semantic search within workset)
CREATE TABLE cached_chunks (
  chunk_id TEXT PRIMARY KEY,
  parent_uid TEXT,
  content TEXT,
  -- ... copy of repo index chunk fields
);

-- Optional: execution memory (plan, notes, deliverable)
-- per workset_evaluation_report.md
```

## 3. Query Path

```
Agent Query
    ↓
1. Search Workset (local SQLite)
   ├── Fast: all relevant context already materialized
   └── If sufficient → Return results
    ↓
2. Fallback to Repo-Level Index (if workset insufficient)
   ├── Query repo-level SQLite (items, links, chunks, FTS5)
   ├── Query sidecar ANN (vector search)
   └── Expand via repo-level graph (k-hop from new seeds)
    ↓
3. Optionally Update Workset (incremental enrichment)
   ├── Add newly discovered items/chunks to workset
   └── Extend subgraph slice with new edges
    ↓
Return results to agent
```

# Responsibilities (Unambiguous)

| Component | Responsibility | What It Is | What It Is NOT |
|-----------|---------------|------------|----------------|
| **Canonical Files** | Source of truth | Markdown + frontmatter in Git | NOT queryable at scale |
| **Repo-Level Graph** | Primary graph structure | Shared, rebuildable index of all edges | NOT per-agent cache |
| **Workset** | Per-task cache bundle | Local, ephemeral, task-scoped materialized context | NOT source of truth, NOT authoritative graph |
| **Sidecar ANN** | Vector similarity search | Fast semantic search (per ADR-0009) | NOT metadata store |
| **SQLite Index** | Fast relational queries | Derived metadata + FTS (per ADR-0004) | NOT source of truth |

# Retrieval Strategy (Detailed)

## Workset-First Strategy

**When to use Workset-first**:
- During active task execution (agent has claimed a task)
- When workset is fresh (within TTL window)
- When working context is stable (no major scope changes)

**Benefits**:
- Fast: No re-querying repo-level index
- Stable: Context doesn't change mid-task
- Offline-friendly: Workset can be pre-built and used offline

## Repo-Index Fallback

**When to fallback to repo-level index**:
- Workset expired or missing
- Query requires cross-cutting view (e.g., "all items blocking any active task")
- New information needed that wasn't in initial workset seeds

**Fallback process**:
1. Query repo-level SQLite (items, links, chunks, FTS5)
2. Query sidecar ANN if semantic search needed
3. Expand via graph if relationship traversal needed
4. Cache results in workset for future queries (optional incremental enrichment)

## Incremental Enrichment (Optional)

After fallback, agent MAY update workset:
- Add newly discovered items/chunks
- Extend subgraph slice with new edges
- Update workset manifest (enrichment timestamp)

**Guardrails**:
- Workset size limits (prevent unbounded growth)
- Enrichment policy (e.g., only add items within 2-hop distance)
- TTL still applies (workset expires regardless of enrichment)

# Trade-offs

| Trade-off | Description |
|-----------|-------------|
| **Workset Staleness** | Workset may become stale if canonical files change during task execution. Mitigation: TTL + periodic rebuild. |
| **Dual Maintenance** | Need to maintain both repo-level index and workset build logic. Mitigation: Shared indexing code, clear derivation rules. |
| **Subgraph Slice Complexity** | Deciding which edges to include in workset subgraph is non-trivial. Mitigation: Start with simple k-hop expansion, iterate. |
| **Storage Overhead** | Worksets duplicate data from repo index. Mitigation: Worksets are ephemeral, cleaned up by TTL. |

# Consequences

## Positive

- **Clear Boundaries**: No ambiguity about which component owns what
- **Rebuildable**: All derived data can be deleted and reconstructed
- **Scalable**: Worksets enable efficient multi-agent collaboration without index contention
- **Composable**: Graph, vector search, and worksets work together without conflict

## Negative

- **Complexity**: More components to understand and maintain
- **Sync Logic**: Need careful handling of cache invalidation and TTL
- **Learning Curve**: Developers must understand the distinction between repo-level and workset-level data

## Mitigations

- **Documentation**: This ADR + inline code comments
- **Tooling**: Scripts to rebuild indices, inspect worksets, validate consistency
- **Defaults**: Worksets are optional; can disable for simple single-agent scenarios

# References

- [KABSD-FTR-0013: Add derived index/cache layer and per‑Agent workset cache (TTL)](../items/feature/0000/KABSD-FTR-0013_add-derived-index-cache-layer-and-peragent-workset-cache-ttl.md)
- [KABSD-FTR-0015: Execution Layer: Workset Cache + Promote](../items/feature/0000/KABSD-FTR-0015_execution-layer-workset-cache-promote.md)
- [ADR-0004: File-First Architecture with SQLite Index](ADR-0004_file-first-architecture-with-sqlite-index.md)
- [ADR-0009: Local-First Embedding Search Strategic Evaluation](ADR-0009_local-first-embedding-search-architecture.md)
- [Workset Evaluation Report](../artifacts/workset_evaluation_report.md)
- [KABSD-TSK-0132: Task tracking this specification](../items/task/0100/KABSD-TSK-0132_clarify-workset-graphrag-context-graph-responsibilities.md)

# Future Work

This ADR establishes the foundation. Future enhancements may include:

1. **Strong Graph / Entity Extraction**: LLM-based relationship mining beyond frontmatter
2. **Multi-Agent Workset Coordination**: Shared worksets for pair programming scenarios
3. **Workset Templates**: Pre-configured recipes for common task types
4. **Graph Visualization**: Tools to visualize repo-level graph and workset subgraphs
5. **Performance Benchmarks**: Measure workset-first vs repo-index-first query performance

# Decision Rationale

**Why separate Workset and Graph?**
- Different lifecycles: Graph is long-lived and shared; Workset is ephemeral and local
- Different query patterns: Graph is for exploration/expansion; Workset is for stable task context
- Different consistency models: Graph must stay in sync with canonical files; Workset can be stale within TTL

**Why NOT merge them?**
- Merging would force either (a) graph to be per-agent (duplication, inconsistency) or (b) workset to be shared (defeats the purpose of local cache)
- Clear separation enables independent evolution and optimization of each component

**Why repo-level graph is primary?**
- Graph relationships are project-wide knowledge (e.g., "what blocks what")
- Per-agent graphs would diverge and create confusion
- Worksets can include subgraph slices for fast local queries, but authoritative graph must be shared

# Status

**Proposed** (2026-01-09)

This ADR is proposed for review. Once accepted, it becomes the architectural constraint for all future Workset and GraphRAG implementation work.

---

*This ADR was created as part of [KABSD-TSK-0132](../items/task/0100/KABSD-TSK-0132_clarify-workset-graphrag-context-graph-responsibilities.md) to prevent role confusion between Workset, GraphRAG, and Context Graph.*
