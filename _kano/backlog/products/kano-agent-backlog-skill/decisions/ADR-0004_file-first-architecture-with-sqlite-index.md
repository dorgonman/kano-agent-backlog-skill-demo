---
id: ADR-0004
title: "File-First Architecture with SQLite Index"
status: Proposed
date: 2026-01-06
related_items: [KABSD-FTR-0007, KABSD-TSK-0049, ADR-0003, ADR-0012]
supersedes: null
superseded_by: null
---

# Decision

Use a **File-First** architecture where Markdown files are the single source of truth, augmented by a **local SQLite database** acting as a disposable, read-optimized index.

- **Source of Truth**: Markdown files tracked in Git.
- **Derived Index**: Local SQLite database (`_kano/backlog/_index/backlog.sqlite3`).
- **Sync Direction**: STRICTLY One-Way (File -> DB). The DB is never the System of Record.
- **Persistence**: The SQLite file is **not** tracked in Git (should be `.gitignore`d). It can be rebuilt from files at any time.

# Context

As the backlog grows, scanning hundreds or thousands of Markdown files for every query (e.g., "find all active tasks blocking feature X") becomes too slow (O(N) IO operations).

However, we want to maintain the benefits of text files:
- **Git-friendly**: Diff, merge, blame work natively.
- **Human-readable**: Accessible without special tools.
- **Portable**: No database server dependency for basic access.

We need a solution that provides relational query speed (O(log N)) without compromising the file-centric workflow.

# Detailed Design

## 1. Index Lifecycle

The index is a **cache** of the file state.

- **Build**: Scan all `.md` files, parse frontmatter, insert into DB.
- **Update**: Check file `mtime` against DB record. Only re-parse modified files.
- **Rebuild**: `rm backlog.sqlite3` followed by a full build ensures 100% consistency.

## 2. Database Schema

The SQLite schema is designed for query efficiency, not normalization rules that would apply to a primary store.

### `items` Table
Core metadata for filtering and sorting.

| Column | Type | Description |
|--------|------|-------------|
| `uid` | TEXT (PK) | UUIDv7 (from frontmatter) |
| `id` | TEXT | Display ID (e.g., KABSD-TSK-0049) |
| `type` | TEXT | Work item type (Feature, Task, etc.) |
| `state` | TEXT | Current state (New, InProgress, etc.) |
| `title` | TEXT | Item title |
| `path` | TEXT | Relative path to file (unique) |
| `mtime` | REAL | File modification timestamp (for sync logic) |
| `content_hash`| TEXT | Hash of content (for change detection) |
| `frontmatter` | JSON | Full frontmatter blob (flexibility) |
| `created` | TEXT | Creation date |
| `updated` | TEXT | Last updated date |

### `links` Table
Tracks relationships for graph queries (e.g., "all children of X").

| Column | Type | Description |
|--------|------|-------------|
| `source_uid` | TEXT | Link source (child) |
| `target_uid` | TEXT | Link target (parent) |
| `type` | TEXT | Link type (e.g., "parent", "relates_to") |

### `embeddings` Table (Future/Optional)
Stores vector embeddings for semantic search.

| Column | Type | Description |
|--------|------|-------------|
| `uid` | TEXT | FK to `items.uid` |
| `chunk_index`| INT | Sequence number of chunk |
| `embedding` | BLOB | Float32 vector array |
| `content` | TEXT | Chunk text content |

## 3. Sync Logic

A sync script (e.g., `update_index.py`) runs:
1.  **Before complex operations** (e.g., `generate_view`).
2.  **Periodically** (if running as a daemon/watcher).
3.  **On-demand** by user.

`resolve_ref` and other CLI tools currently use an in-memory index (`lib/index.py`). They should be refactored to query SQLite when available for better scaling.

# Trade-offs

| Trade-off | Description |
|-----------|-------------|
| **Latency** | DB state may lag behind file state until sync runs. Tooling must handle "dirty" reads or force sync. |
| **Complexity** | Maintaining sync logic (especially incremental updates) adds code complexity vs raw file scan. |
| **Space** | Duplicates metadata in DB file (negligible for text backlogs). |

# Consequences

- **Tooling Update**: All queries (Dashboard generation, Reference resolution) should migrate to use SQLite for reads.
- **Gitignore**: Ensure `*.sqlite3` is ignored.
- **Resilience**: Tools must degrade gracefully if DB is corrupt or missing (fallback to file scan or auto-rebuild).
- **Schema Reuse**: Per [ADR-0012](ADR-0012_workset-db-canonical-schema-reuse.md), this canonical schema is reused by workset DBs to avoid schema drift and maintain portable context.

# Related

- **Canonical Schema**: See [_meta/canonical_schema.sql](../_meta/canonical_schema.sql) and [_meta/canonical_schema.json](../_meta/canonical_schema.json) for the complete schema definition.
- **Workset Schema**: See [ADR-0012](ADR-0012_workset-db-canonical-schema-reuse.md) for how workset DBs reuse this canonical schema.
