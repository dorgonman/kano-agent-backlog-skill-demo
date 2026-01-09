---
id: ADR-0012
uid: 019b9c80-0000-7000-8000-000000000001
title: "Workset DB Uses Canonical Schema (No Parallel Schema)"
status: Proposed
date: 2026-01-09
related_items: [KABSD-FTR-0013, KABSD-FTR-0015, KABSD-TSK-0132, KABSD-TSK-0046, ADR-0004, ADR-0008, ADR-0011]
supersedes: null
superseded_by: null
deciders:
  - agent=copilot
---

# Decision

**Workset DB must reuse the same system schema and semantics as the source-of-truth model**, rather than creating a separate "workset-only schema".

Workset DB is a **materialized subset view** of the canonical model, not a different model.

# Context and Problem Statement

We maintain canonical backlog data as local-first files (source of truth). We also plan to generate worksets (per-task/per-agent context bundles) as SQLite DBs for fast retrieval and stable context.

We want worksets to be derived data, rebuildable at any time, and we already rely on a globally unique UID for identity (ADR-0003).

**The Question**: Should workset DB have its own schema design, or should it reuse the canonical schema defined for the repo-level derived index?

**The Risk**: If workset has its own schema, it will inevitably diverge from the canonical data model, creating long-term maintenance cost, bugs, and integration friction.

# Rationale

## Why This Is Important

### 1. Avoid Schema Drift
- If workset has its own schema, it will diverge from the canonical data model over time
- Every schema evolution would require parallel changes in two places
- Different schemas lead to subtle semantic mismatches and data loss during translation

### 2. Portable Context with Zero Translation
- Agents/tools that understand the canonical schema can read a workset DB without custom mapping logic
- This reduces integration friction across tools (CLI, future server façade, GUI)
- A workset can be directly queried using the same queries used for the repo-level index

### 3. Deterministic Rebuild
- Workset is derived: it must be regeneratable from source-of-truth + derived indexes
- Reusing schema makes regeneration straightforward and verifiable
- Schema migrations (ADR-0008) apply uniformly to both repo index and worksets

### 4. Consistent Identity & References
- Workitems/ADRs keep the same UID and same link semantics across canonical and workset DB
- Edges (parent/ref/depends) remain consistent
- No need for ID translation or mapping tables

### 5. Future-Proofing for Graph-Assisted Retrieval
- Graph expansion can materialize a subgraph into workset without inventing new edge formats
- Workset becomes a "view slice" of the full graph, not a separate graph model

# Canonical Schema (Reused by Workset DB)

The canonical schema is defined in ADR-0004 and KABSD-TSK-0046. It represents:

## Core Entities

### `items` Table
Core metadata for all work items (Epic/Feature/Story/Task/Bug) and ADRs.

| Column | Type | Description |
|--------|------|-------------|
| `uid` | TEXT (PK) | UUIDv7 (globally unique, from frontmatter) |
| `id` | TEXT | Display ID (e.g., KABSD-TSK-0049) |
| `type` | TEXT | Work item type (Epic, Feature, UserStory, Task, Bug, ADR) |
| `state` | TEXT | Current state (Proposed, Ready, InProgress, Done, etc.) |
| `title` | TEXT | Item title |
| `path` | TEXT | Relative path to canonical file |
| `mtime` | REAL | File modification timestamp |
| `content_hash`| TEXT | Hash of content (for change detection) |
| `frontmatter` | JSON | Full frontmatter blob (flexibility) |
| `created` | TEXT | Creation date (ISO 8601) |
| `updated` | TEXT | Last updated date (ISO 8601) |
| `priority` | TEXT | Priority (P1, P2, P3, etc.) |
| `parent_uid` | TEXT | UID of parent item (null if root) |
| `owner` | TEXT | Current owner/assignee |
| `area` | TEXT | Functional area |
| `iteration` | TEXT | Iteration/sprint identifier |
| `tags` | JSON | Array of tags |

### `links` Table
Tracks typed relationships for graph queries.

| Column | Type | Description |
|--------|------|-------------|
| `source_uid` | TEXT | Link source (referencing item) |
| `target_uid` | TEXT | Link target (referenced item) |
| `type` | TEXT | Link type: "parent", "relates_to", "blocks", "blocked_by", "decision_ref" |
| PRIMARY KEY | | (source_uid, target_uid, type) |

### `worklog` Table (Optional but Canonical)
Stores append-only worklog entries.

| Column | Type | Description |
|--------|------|-------------|
| `uid` | TEXT (PK) | Unique worklog entry ID |
| `item_uid` | TEXT | UID of parent item |
| `timestamp` | TEXT | ISO 8601 timestamp |
| `agent` | TEXT | Agent/user who created entry |
| `content` | TEXT | Worklog entry text |

### `chunks` Table (For Embedding/FTS)
Stores content chunks for semantic search.

| Column | Type | Description |
|--------|------|-------------|
| `chunk_id` | TEXT (PK) | Unique chunk identifier |
| `parent_uid` | TEXT | UID of parent item |
| `chunk_index` | INT | Sequence number within parent |
| `content` | TEXT | Chunk text content |
| `section` | TEXT | Section type (Context, Goal, Approach, etc.) |
| `embedding` | BLOB | Float32 vector array (optional) |

### Schema Metadata
Per ADR-0008, track schema version for migrations.

| Column | Type | Description |
|--------|------|-------------|
| `key` | TEXT (PK) | Metadata key (e.g., "schema_version") |
| `value` | TEXT | Metadata value |

# Workset as a Subset

A workset DB contains:
- **Included nodes**: A filtered subset of `items` (selected by workset recipe)
- **Included edges**: `links` restricted to included nodes (or optionally include boundary edges)
- **Included chunks**: Content chunks for included items
- **Included worklog**: Worklog entries for included items (optional)

**NOT included in workset**:
- Items outside the selected scope
- Edges between excluded nodes

## Workset-Specific Metadata (Additive Only)

Workset DB MAY add workset-specific metadata tables, but MUST NOT change core entity schemas.

### Allowed: `workset_manifest` Table

```sql
CREATE TABLE workset_manifest (
  workset_id TEXT PRIMARY KEY,
  agent TEXT NOT NULL,
  task_id TEXT,
  created_at TEXT NOT NULL,
  ttl_hours INTEGER,
  seed_items TEXT,  -- JSON array of seed UIDs
  expansion_params TEXT,  -- JSON: {k_hop: 2, edge_types: [...]}
  source_commit_hash TEXT,  -- Git commit of canonical files
  canonical_index_version TEXT NOT NULL CHECK (canonical_index_version <> '')  -- Schema version of source index
);
```

### Allowed: `workset_provenance` Table

```sql
CREATE TABLE workset_provenance (
  item_uid TEXT PRIMARY KEY,
  selection_reason TEXT,  -- "seed", "parent_expansion", "dependency_expansion"
  distance_from_seed INTEGER,  -- Hop count from nearest seed
  included_at TEXT  -- ISO 8601 timestamp
);
```

These tables are **additive** — they extend the canonical schema without changing core table definitions.

# Content Storage Strategy

Workset DB supports multiple content strategies (choose based on use case):

## Option 1: Full Content (Portable)
- Store complete item content in workset DB (in `items.frontmatter` JSON or separate `content` column)
- **Pros**: Workset is fully portable, can be used offline
- **Cons**: Larger DB size, duplication of content

## Option 2: Pointer-Based (Smaller)
- Store only `uid`, `path`, and `content_hash` in workset
- Require access to canonical files for full content retrieval
- **Pros**: Smaller workset DB, no content duplication
- **Cons**: Not portable, requires canonical file access

## Option 3: Hybrid (Recommended)
- Store summaries/excerpts in workset (title, first N words of sections)
- Store pointers to canonical files + hashes for verification
- Optionally include full content for "hot" items (recently accessed)
- **Pros**: Balanced size vs portability
- **Cons**: More complex logic

**Decision**: Support all three strategies via configuration. Default to Hybrid for best balance.

# Schema Evolution and Migrations

Per ADR-0008, schema migrations apply uniformly:

1. **Repo-level index migration**:
   - Apply migration `001_add_vcs_cache_tables.sql`
   - Update `schema_meta.schema_version = '1'`

2. **Workset DB migration** (when rebuilding workset):
   - Detect source index schema version from `canonical_index_version` in manifest
   - Apply same migrations to workset DB
   - Ensure workset schema version matches canonical schema version

**Constraint**: Workset DB schema version MUST NOT exceed canonical schema version.

**Rebuild Rule**: If canonical schema is upgraded, all worksets MUST be rebuilt or auto-migrated.

# Guidelines for Maintaining Schema Compatibility

## DO: Add Workset-Specific Tables
✅ Add `workset_manifest`, `workset_provenance`, or similar metadata tables
✅ These tables MUST be prefixed with `workset_` to avoid naming conflicts
✅ Document all workset-specific tables in this ADR or code comments

## DO NOT: Modify Core Table Schemas
❌ Do NOT change `items`, `links`, `chunks`, `worklog`, or `schema_meta` table definitions
❌ Do NOT add columns to core tables specific to worksets
❌ Do NOT rename or remove columns from canonical schema

## DO: Subset Core Tables
✅ Workset `items` table contains fewer rows than canonical `items` (filtering is allowed)
✅ Workset `links` table only includes edges relevant to included nodes

## DO: Preserve Field Semantics
✅ `uid` means the same thing in workset and canonical DB (globally unique identifier)
✅ `state` values match canonical state vocabulary (Proposed, Ready, InProgress, Done, etc.)
✅ `type` values match canonical type vocabulary (Epic, Feature, UserStory, Task, Bug, ADR)

## DO: Version Compatibility Checks
✅ When loading a workset, verify `canonical_index_version` matches expected schema
✅ If version mismatch, warn or auto-rebuild workset

# Acceptance Criteria

- [x] Canonical schema is defined (ADR-0004, this ADR)
- [x] Workset DB reuses canonical `items`, `links`, `chunks`, `worklog` tables
- [x] Workset-specific metadata is additive only (`workset_manifest`, `workset_provenance`)
- [x] Content storage strategy is documented (full/pointer/hybrid)
- [x] Schema migration compatibility is specified (workset follows canonical migrations)
- [x] Guidelines for adding workset metadata are documented (DO/DO NOT rules)
- [x] SQL schema definition created ([canonical_schema.sql](../_meta/canonical_schema.sql))
- [x] JSON schema definition created ([canonical_schema.json](../_meta/canonical_schema.json))
- [x] Verification examples documented ([workset_schema_verification_examples.md](../artifacts/workset_schema_verification_examples.md))
- [ ] Implementation validates schema compatibility at workset build time (future work)
- [ ] Tools that read canonical schema can read workset DB without special-case mapping (verified via examples)

# Non-Goals

- Workset DB is NOT a new source-of-truth
- Do NOT implement a separate "workset schema v2"
- Do NOT require workset DB to contain all canonical data (it's a subset by definition)
- Do NOT implement server runtime (per AGENTS.md temporary clause)

# Consequences

## Positive

- **No Schema Drift**: Single schema definition for all derived DBs
- **Portable Context**: Worksets can be shared, inspected, queried with standard tools
- **Simplified Maintenance**: Schema migrations apply uniformly
- **Consistent Identity**: UIDs and link semantics preserved across canonical and workset

## Negative

- **Workset Constraints**: Workset DB cannot optimize schema for workset-specific use cases
- **Migration Coupling**: Workset rebuild required when canonical schema changes

## Mitigations

- **Extensibility**: Workset-specific tables allowed (additive only)
- **Rebuild Automation**: Make workset rebuild fast and deterministic
- **Version Checks**: Detect and handle schema version mismatches gracefully

# Alternatives Considered

## 1. Separate Workset Schema
**Approach**: Design a custom schema optimized for workset use cases.

**Rejected because**:
- Schema drift inevitable (maintenance burden)
- Translation layer required (complexity, bugs)
- Breaks portable context (tools need dual schema support)

## 2. Denormalized Workset Schema
**Approach**: Flatten canonical schema into a denormalized "workset view" (e.g., single table with all fields).

**Rejected because**:
- Loses relational structure (graph queries become difficult)
- Content duplication (same item appears multiple times with different join results)
- Still requires mapping/translation logic

## 3. Schema-Free (JSON Blobs Only)
**Approach**: Store items as raw JSON blobs in workset DB.

**Rejected because**:
- No relational query support (defeats purpose of SQL index)
- No FTS or graph traversal without parsing JSON
- Still need consistent JSON schema (same drift problem)

# References

- [ADR-0003: Identifier Strategy (UID)](ADR-0003_identifier-strategy-for-local-first-backlog.md) — Global UID ensures identity consistency
- [ADR-0004: File-First Architecture with SQLite Index](ADR-0004_file-first-architecture-with-sqlite-index.md) — Canonical schema definition
- [ADR-0008: SQLite Schema Migration Framework](ADR-0008_sqlite-schema-migration-framework.md) — Migration strategy
- [ADR-0011: Workset vs GraphRAG Separation](ADR-0011_workset-graphrag-context-graph-separation-of-responsibilities.md) — Workset role definition
- [KABSD-TSK-0046: Define DB Index Schema](../items/task/0000/KABSD-TSK-0046_define-db-index-schema-items-links-worklog-decisions.md) — Original schema definition task
- [KABSD-FTR-0013: Workset Cache](../items/feature/0000/KABSD-FTR-0013_add-derived-index-cache-layer-and-peragent-workset-cache-ttl.md) — Workset feature
- [KABSD-FTR-0015: Workset Promote](../items/feature/0000/KABSD-FTR-0015_execution-layer-workset-cache-promote.md) — Workset execution layer

# Future Work

- Define JSON schema for canonical frontmatter (complementary to SQL schema)
- Benchmark workset query performance vs canonical index
- Implement schema version compatibility checker for workset loading
- Add workset content strategy configuration (full/pointer/hybrid)
- Create workset rebuild automation on schema migration

# Verification

See [Workset Schema Verification Examples](../artifacts/workset_schema_verification_examples.md) for test cases demonstrating:
- Schema compatibility checks
- Schema version tracking
- Core table consistency
- Workset-specific table validation
- Subset semantics verification
- Deterministic rebuild testing

# Status

**Proposed** (2026-01-09)

This ADR is proposed for review. Once accepted, it becomes the architectural constraint for all future Workset DB implementation work.

---

*This ADR ensures that workset DB remains a true materialized view of the canonical schema, preventing schema drift and maintaining portable, rebuildable context bundles.*
