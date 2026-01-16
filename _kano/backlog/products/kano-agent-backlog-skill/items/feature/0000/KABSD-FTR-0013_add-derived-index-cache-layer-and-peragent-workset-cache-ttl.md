---
id: KABSD-FTR-0013
uid: 019b9646-35c5-7e58-9dc2-d2d2bfe7580e
type: Feature
title: "Add derived index/cache layer and per‑Agent workset cache (TTL)"
state: Planned
priority: P2
parent: KABSD-EPIC-0004
area: infrastructure
iteration: null
tags: ["cache", "derived-index"]
created: 2026-01-07
updated: 2026-01-10
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: [KABSD-FTR-0015]
  blocked_by: []
decisions: [ADR-0011, ADR-0012]
original_type: Feature
---

# Context

As the number of backlog items increases, relying solely on file system traversal impacts performance. Additionally, agents need "Working Memory" (Workset) during task execution; storing this information directly in permanent records can clutter them. These transient records require a TTL (Time-To-Live) mechanism for automatic cleanup.

**Architecture Clarification**: See [ADR-0011](_kano/backlog/products/kano-agent-backlog-skill/decisions/ADR-0011_workset-graphrag-context-graph-separation-of-responsibilities.md) for the specification of how Workset relates to GraphRAG and the repo-level derived index. See [ADR-0012](_kano/backlog/products/kano-agent-backlog-skill/decisions/ADR-0012_workset-db-canonical-schema-reuse.md) for schema compatibility requirements (workset DB must reuse canonical schema). Key points:
- Workset is a per-agent/per-task cache bundle (ephemeral, local)
- Repo-level derived index (including graph) is the shared, authoritative derived data
- Both are rebuildable from canonical files (source of truth)

# Goal

- **Derived Index**: Provide a high-performance SQL query interface (SQLite for local, PostgreSQL for cloud acceleration) acting as a "Read View" of the file system.
- **Workset Cache**: Provide each agent with an independent `work_plan.md` / `notes.md` staging area, supporting automatic TTL expiration.

# Non-Goals

- Worksets are not for long-term storage; important information must be promoted back to canonical items.
- The Index is not a Write Master; writes must still go through standard file operations.

# Approach

1. **Derived Index**:
   - Extend `scripts/indexing/` to support mapping Markdown frontmatter to SQL tables.
   - Implement a `rebuild_index` script to perform a full rebuild from the file system.
2. **Workset Cache**:
  - Define a `_kano/backlog/.cache/worksets/<item-id>/` directory structure (one directory per backlog item; agent recorded in manifest).
   - Implement `workset_init`, `workset_read`, and `workset_write` scripts.
   - Add a TTL cleanup schedule (or lazy cleanup).

# Alternatives

- Use Vector DBs as an index (can run alongside SQL, not mutually exclusive).
- Rely entirely on Obsidian Dataview indexing (requires Obsidian to be running, unusable by headless agents).

# Acceptance Criteria

- [ ] **Canonical Schema Implemented (ADR-0012)**
  - Define `items`, `tags`, `links`, `decisions` tables in SQLite schema
  - Schema matches canonical frontmatter structure (uid, id, type, state, title, priority, parent, created, updated, etc.)
  - Verified: Schema reuse avoids drift; workset DB uses identical schema as repo-level index

- [ ] **`scripts/indexing/index_db.py` Script**
  - Scans canonical `.md` files from `_kano/backlog/items/` and `decisions/`
  - Parses YAML frontmatter and maps to SQL tables
  - Implements `rebuild_index` mode: full reconstruction from files
  - Implements `incremental` mode: update only changed items (optional, for later)
  - Generates or updates `_kano/backlog/_index/backlog.sqlite3`

- [ ] **Workset SQL Schema (Subset View)**
  - Workset DB (`_kano/backlog/.cache/worksets/<item-id>/workset.db`) reuses same canonical schema
  - Workset DB contains only items relevant to the specific task (seed + k-hop neighbors, if using graph expansion)
  - Verified: Workset is a materialized subset, not a separate data model

- [ ] **`.gitignore` Updated**
  - `_kano/backlog/_index/` excluded from Git (derived, rebuildable)
  - `_kano/backlog/.cache/` excluded from Git (ephemeral, per-agent)
  - Verified: Build/CI does not track these directories

- [ ] **Performance Validation**
  - Rebuild demo backlog (100+ items) in <5 seconds
  - Query backlog index for common operations (find by state, parent, tags) in <100ms
  - Workset init for a single item in <1 second
  - Verified: SQLite FTS (if enabled) provides 10x speedup over file scans

- [ ] **TTL Cleanup Script** (`scripts/indexing/workset_cleanup.py`)
  - Identifies worksets with mtime older than configurable threshold (default: 7 days)
  - Removes expired worksets from disk
  - Logs cleanup operations (audit trail)
  - Optional: dry-run mode to preview deletions

- [ ] **Documentation**
  - How to rebuild index: `python scripts/indexing/index_db.py --rebuild`
  - Workset schema design rationale (why canonical schema reuse)
  - Index persistence rules (what is tracked, what isn't)
  - Cleanup schedule and TTL semantics

# Risks / Dependencies

- **Risk: Index sync lag**: File changes may not immediately reflect in SQLite. **Mitigation**: Document that index is eventual-consistent; provide manual `--rebuild` if needed; consider file watcher (optional future enhancement).
- **Risk: Schema migration complexity**: If canonical schema evolves, must migrate index and worksets. **Mitigation**: Use ADR-0008 (schema versioning) to track migrations; auto-apply migrations on index rebuild.
- **Risk: Cache consistency across machines**: Agents on different machines have divergent worksets. **Mitigation**: This is acceptable; worksets are local-first and per-agent. Document: worksets are not synced; restore from canonical source if needed.
- **Risk: Large backlog rebuild time**: 10,000+ items may take 10+ seconds. **Mitigation**: Implement incremental rebuild (future); provide progress bar during rebuild; allow async index updates.
- **Dependency**: Must finalize canonical schema (ADR-0012) before implementation
- **Dependency**: Git `.gitignore` rules must be in place before development
- **Dependency**: Conflict guard (owner locking) recommended for workset safety (related: KABSD-TSK-0036)

# Worklog

2026-01-07 10:35 [agent=antigravity] Added basic description for Derived Index & Workset Feature.
2026-01-07 10:38 [agent=antigravity] Translated content to English to follow project guidelines.
2026-01-10 14:45 [agent=copilot] Completed Ready gate: expanded Acceptance Criteria with detailed schema/performance/cleanup requirements; clarified risks and dependencies. State moved to Planned (ready for implementation).
2026-01-10 16:28 [agent=copilot] Locked `_kano/backlog/.cache/worksets/<item-id>/` layout decision and recorded dependency block to FTR-0015.
