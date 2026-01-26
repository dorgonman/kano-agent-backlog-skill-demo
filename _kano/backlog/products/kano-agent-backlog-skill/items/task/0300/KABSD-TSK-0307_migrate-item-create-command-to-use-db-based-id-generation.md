---
id: KABSD-TSK-0307
uid: 019bf65a-9205-7641-9e05-d1a22a6181a1
type: Task
title: "Migrate item create command to use DB-based ID generation"
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

`item create` command currently uses `find_next_number()` which is vulnerable to race conditions. We need to switch to the new DB-based atomic ID generation while maintaining backward compatibility.

# Goal

Update `kano-backlog item create` to use `get_next_id_from_db()` for generating new item IDs.

# Approach

1. Modify `kano_backlog_ops.create.create_item()` to accept an optional `db_path`
2. If `db_path` exists and has `id_sequences` table, use `get_next_id_from_db()`
3. If DB/table missing or error occurs, fallback to `find_next_number()` and log a warning
4. Ensure `db_path` defaults to `.cache/chunks.sqlite3` in the product directory
5. Update CLI command wiring to pass the correct DB path

# Acceptance Criteria

- `item create` uses DB sequence when available
- Created items have correct sequential IDs
- Fallback to filesystem scan works if DB is missing
- Warning is logged when fallback occurs
- No disruption to existing item creation workflow

# Risks / Dependencies

**Risks**:
- DB lock contention might slow down creation (unlikely with SQLite WAL mode and short transactions)
- Fallback mechanism might mask DB issues (mitigate: explicit warning logging)

**Dependencies**:
- KABSD-TSK-0308 (Schema)
- KABSD-TSK-0309 (Core logic)

# Worklog

2026-01-26 02:11 [agent=opencode] Created item

2026-01-26 02:21 [agent=opencode] State -> InProgress.
2026-01-26 02:22 [agent=opencode] State -> Done.
