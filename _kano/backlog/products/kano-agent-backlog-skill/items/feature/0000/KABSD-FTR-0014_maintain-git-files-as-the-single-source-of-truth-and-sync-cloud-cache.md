---
id: KABSD-FTR-0014
uid: 019b9646-441a-701e-864d-476b7955eac3
type: Feature
title: "Maintain Git/files as the single source of truth and sync cloud cache"
state: Proposed
priority: P2
parent: KABSD-EPIC-0004
area: infrastructure
iteration: null
tags: ["sync"]
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
original_type: Feature
---

# Context

With the introduction of the "Cloud Acceleration Layer" and "Derived Index," multiple copies of data now exist within the system. To ensure data consistency and auditability, "File System (Git)" must be strictly defined as the Single Source of Truth (SSOT).

# Goal

- Ensure that all "Write" operations on the backlog eventually reflect in the Markdown files.
- The cloud database (PostgreSQL/MySQL) exists only as a "Cache" or "Read-only Replica," or must support a "Write-Through" mechanism.
- Prevent Split-Brain scenarios (inconsistency between cloud and local states that cannot be merged).

# Non-Goals

- Two-way real-time synchronization is considered too complex for conflict resolution and is not prioritized initially.

# Approach

1. **One-way Sync (File -> Cloud)**:
   - Changes in the file system (triggered by a File Watcher or Git Hook) prompt the Indexer to update the cloud database.
2. **Write-Through API** (Optional):
   - If an agent calls the FastAPI to write data, the API must first write to the local file. Upon success, it updates the database (or waits for the Watcher to sync).
3. **Conflict Resolution**:
   - In the event of a conflict, the content in the file system always prevails and forces an overwrite of the database.

# Alternatives

- Making the database the Master and periodically dumping to Markdown (Violates the local-first principle; not adopted).

# Acceptance Criteria

- [ ] Manual modifications to Markdown files are reflected in database query results within a short time.
- [ ] After clearing the database, data can be fully restored from the file system using `rebuild_index`.
- [ ] Architecture diagrams clearly label the data flow as File -> DB.

# Risks / Dependencies

- Stability of File Watchers on different operating systems.
- Performance bottlenecks when synchronizing a large number of file changes.

# Worklog

2026-01-07 10:35 [agent=antigravity] Added basic description for Git SSOT & Sync Feature.
2026-01-07 10:39 [agent=antigravity] Translated content to English to follow project guidelines.

2026-01-07 10:25 [agent=antigravity] Created from template.
