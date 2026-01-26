---
area: general
created: '2026-01-26'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0060
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Done
tags: []
title: ID generation race condition prevention
type: Feature
uid: 019bf659-d7e2-74d7-ac04-19607b6d23fd
updated: 2026-01-26
---

# Context

Current ID generation uses `find_next_number()` which scans the filesystem to find the highest existing ID number and returns max + 1. This has a race condition: if two agents create items simultaneously, they both scan, get the same "next number", and create duplicate IDs.

This happened with KABSD-TSK-0302 where two different tasks were created with the same ID but different UIDs and titles. The race condition window exists between `find_next_number()` and file creation, with no atomicity guarantee.

Filesystem operations don't provide transactional guarantees, making it impossible to prevent collisions with the current file-scan approach.

# Goal

Implement atomic ID generation using SQLite to prevent race conditions when multiple agents create items concurrently. Ensure each item gets a unique sequential ID even under concurrent load.

# Non-Goals

- Changing ID format (keep KABSD-TSK-0001 format)
- Distributed ID generation across multiple machines
- Retroactive ID renumbering of existing items
- Supporting non-sequential IDs or UUID-based IDs

# Approach

**Use SQLite sequence table for atomic ID generation**:

1. Add `id_sequences` table to existing `chunks.sqlite3`:
   ```sql
   CREATE TABLE IF NOT EXISTS id_sequences (
       prefix TEXT NOT NULL,
       type_code TEXT NOT NULL,
       next_number INTEGER NOT NULL DEFAULT 1,
       PRIMARY KEY (prefix, type_code)
   );
   ```

2. Implement `get_next_id_from_db()` function that atomically increments and returns next ID:
   ```sql
   BEGIN TRANSACTION;
   INSERT INTO id_sequences (prefix, type_code, next_number)
   VALUES ('KABSD', 'TSK', 1)
   ON CONFLICT(prefix, type_code) DO UPDATE SET
       next_number = next_number + 1;
   SELECT next_number FROM id_sequences WHERE prefix = 'KABSD' AND type_code = 'TSK';
   COMMIT;
   ```

3. Migrate `item create` command to use DB-based ID generation

4. Add migration script to initialize sequences from existing files (one-time bootstrap)

5. Fallback to file-scan if DB doesn't exist (with warning)

**Why reuse chunks.sqlite3**:
- Already exists per product
- Avoids proliferating DB files
- Sequences are product-scoped (same as chunks)
- Simple schema addition

# Alternatives

**Alternative 1: File-based locking with sequence file**
- Pros: No DB dependency
- Cons: Cross-platform file locking is complex, slower, lock timeout handling needed

**Alternative 2: Separate sequences.sqlite3 DB**
- Pros: Clean separation of concerns
- Cons: More DB files to manage, same functionality as reusing chunks DB

**Alternative 3: UUID-based IDs**
- Pros: No collisions ever, distributed-friendly
- Cons: Breaks existing ID format (KABSD-TSK-0001), not human-readable, massive migration

**Alternative 4: Timestamp + random suffix**
- Pros: Low collision probability
- Cons: Not sequential, breaks existing format, still has collision risk

# Acceptance Criteria

- `id_sequences` table exists in chunks.sqlite3 with correct schema
- `get_next_id_from_db()` returns unique sequential IDs atomically
- Concurrent item creation (2+ agents) produces unique IDs without collisions
- Migration script initializes sequences from existing files correctly
- `item create` command uses DB-based ID generation by default
- Fallback to file-scan works if DB doesn't exist (with warning logged)
- Tests cover: sequential generation, concurrent generation, migration, fallback
- Documentation describes new ID generation mechanism

# Risks / Dependencies

**Risks**:
- SQLite DB corruption could block all item creation (mitigate: DB is rebuildable, provide repair command)
- Migration script must handle gaps in existing IDs correctly (mitigate: use max(existing) + 1)
- Fallback to file-scan still has race condition (mitigate: log warning, recommend running migration)
- Sequence table could get out of sync if files are manually created (mitigate: provide sync command)

**Dependencies**:
- chunks.sqlite3 must exist and be writable
- SQLite must support ON CONFLICT DO UPDATE (SQLite 3.24.0+, released 2018)
- Item creation workflow must support DB access

# Worklog

2026-01-26 02:10 [agent=opencode] Created item
2026-01-26 02:18 [agent=opencode] [model=unknown] Process Confirmation: While creating Tasks for this Feature, an ID collision occurred (KABSD-TSK-0308 and KABSD-TSK-0309 were duplicated). This real-world event confirms the urgent need for atomic ID generation. The duplicate tasks were manually renumbered to KABSD-TSK-0310 and KABSD-TSK-0311.
2026-01-26 02:19 [agent=opencode] Auto parent sync: child KABSD-TSK-0308 -> InProgress; parent -> InProgress.
2026-01-26 02:24 [agent=opencode] Auto parent sync: child KABSD-TSK-0311 -> Done; parent -> Done.
2026-01-26 02:25 [agent=opencode] State -> Done.
