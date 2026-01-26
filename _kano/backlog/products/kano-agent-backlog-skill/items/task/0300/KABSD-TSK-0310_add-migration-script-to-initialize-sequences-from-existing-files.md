---
id: KABSD-TSK-0310
uid: 019bf65a-9236-7638-a6de-8b5185700f90
type: Task
title: "Add migration script to initialize sequences from existing files"
state: Done
priority: P2
parent: KABSD-FTR-0060
area: general
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

When switching to DB-based ID generation, the DB starts empty. We need to initialize it with the current max IDs from the filesystem to avoid re-issuing existing IDs.

# Goal

Create a migration command/script that scans the filesystem (using existing `find_next_number`) and populates the `id_sequences` table.

# Approach

1. Add `kano-backlog admin sync-sequences` command
2. For each known item type (TSK, FTR, etc.):
   - Call `find_next_number()` to get the next available number from files
   - Current max = next_number - 1
   - Insert/Update `id_sequences` with `next_number = current_max` (so next increment gives correct ID)
3. Support `--dry-run` to show what would happen

# Acceptance Criteria

- Command scans all item types and finds correct max IDs
- DB is populated with correct current max values
- Subsequent `item create` gets the correct next ID
- `--dry-run` prints planned updates without modifying DB

# Risks / Dependencies

**Risks**:
- If files are added while migration runs, we might miss them (mitigate: fast scan, user coordination)
- Gaps in IDs are ignored (we just care about max used)

**Dependencies**:
- KABSD-TSK-0308 (Schema)

# Worklog

2026-01-26 02:11 [agent=opencode] Created item

2026-01-26 02:22 [agent=opencode] State -> InProgress.
2026-01-26 02:23 [agent=opencode] State -> Done.
