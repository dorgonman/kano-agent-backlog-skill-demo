---
id: KABSD-FTR-0013
uid: 019b9646-35c5-7e58-9dc2-d2d2bfe7580e
type: Feature
title: "Add derived index/cache layer and per‑Agent workset cache (TTL)"
state: Proposed
priority: P2
parent: KABSD-EPIC-0004
area: infrastructure
iteration: null
tags: ["cache", "derived-index"]
created: 2026-01-07
updated: 2026-01-07
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

As the number of backlog items increases, relying solely on file system traversal impacts performance. Additionally, agents need "Working Memory" (Workset) during task execution; storing this information directly in permanent records can clutter them. These transient records require a TTL (Time-To-Live) mechanism for automatic cleanup.

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
   - Define a `.cache/worksets/<agent_id>/<item_id>/` directory structure.
   - Implement `workset_init`, `workset_read`, and `workset_write` scripts.
   - Add a TTL cleanup schedule (or lazy cleanup).

# Alternatives

- Use Vector DBs as an index (can run alongside SQL, not mutually exclusive).
- Rely entirely on Obsidian Dataview indexing (requires Obsidian to be running, unusable by headless agents).

# Acceptance Criteria

- [ ] Provide Python scripts to create/update the SQL index.
- [ ] Support reading/writing Workset files for a specific Item ID.
- [ ] Demonstrate that Git ignores the `.cache` directory and that Workset content can be marked expired after TTL.

# Risks / Dependencies

- Index sync lag: There may be a delay between file changes and index updates.
- Cache consistency: If agents switch between diferentes machines, Workset synchronization must be considered (initial support only for local).

# Worklog

2026-01-07 10:35 [agent=antigravity] Added basic description for Derived Index & Workset Feature.
2026-01-07 10:38 [agent=antigravity] Translated content to English to follow project guidelines.

2026-01-07 10:25 [agent=antigravity] Created from template.
