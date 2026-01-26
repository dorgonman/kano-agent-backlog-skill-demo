---
id: KABSD-TSK-0308
uid: 019bf65a-9236-7758-8972-85b8aebbe657
type: Task
title: "Add id_sequences table to chunks.sqlite3 schema"
state: Done
priority: P1
parent: KABSD-FTR-0060
area: infrastructure
iteration: backlog
tags: []
created: 2026-01-26
updated: 2026-01-26
owner: opencode
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

To support atomic ID generation, we need a persistent place to store the current sequence number for each item type. Reusing `chunks.sqlite3` avoids creating yet another DB file.

# Goal

Update the canonical SQLite schema to include `id_sequences` table.

# Approach

1. Update `kano_backlog_core/schema.py` to include:
   ```sql
   CREATE TABLE IF NOT EXISTS id_sequences (
       prefix TEXT NOT NULL,
       type_code TEXT NOT NULL,
       next_number INTEGER NOT NULL DEFAULT 1,
       PRIMARY KEY (prefix, type_code)
   );
   ```
2. Update `chunks_db.py` to ensure this table is created during DB init/rebuild
3. Ensure the table creation is idempotent (IF NOT EXISTS)

# Acceptance Criteria

- `id_sequences` table is created when initializing/rebuilding chunks DB
- Schema allows multiple prefixes (multi-product support)
- Primary key enforces uniqueness on (prefix, type_code)
- Existing DBs are upgraded gracefully (or require rebuild)

# Risks / Dependencies

**Risks**:
- Schema migration for existing DBs (mitigate: rebuild is cheap for chunks DB, or use `CREATE TABLE IF NOT EXISTS`)

**Dependencies**:
- None

# Worklog

2026-01-26 02:11 [agent=opencode] Created item

2026-01-26 02:19 [agent=opencode] State -> InProgress.
2026-01-26 02:20 [agent=opencode] State -> Done.
