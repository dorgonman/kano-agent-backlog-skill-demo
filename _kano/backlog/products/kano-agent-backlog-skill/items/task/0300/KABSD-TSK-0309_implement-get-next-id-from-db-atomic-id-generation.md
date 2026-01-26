---
id: KABSD-TSK-0309
uid: 019bf65a-924f-77e8-afa3-06c0321f670e
type: Task
title: "Implement get_next_id_from_db() atomic ID generation"
state: Done
priority: P1
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

We need a core function that performs the atomic ID increment using SQLite transactions.

# Goal

Implement `get_next_id_from_db()` in `kano_backlog_ops/item_utils.py` (or new module) that guarantees atomicity.

# Approach

1. Implement `get_next_id_from_db(db_path, prefix, type_code) -> int`
2. Use SQLite transaction:
   ```python
   with sqlite3.connect(db_path) as conn:
       conn.execute("BEGIN IMMEDIATE")  # Lock DB immediately
       # UPSERT: Insert 1 if new, else increment
       conn.execute("""
           INSERT INTO id_sequences (prefix, type_code, next_number)
           VALUES (?, ?, 1)
           ON CONFLICT(prefix, type_code) DO UPDATE SET
               next_number = next_number + 1
       """, (prefix, type_code))
       # Fetch result
       row = conn.execute("SELECT next_number FROM id_sequences ...").fetchone()
       return row[0]
   ```
3. Handle DB errors gracefully (raise specific exception)

# Acceptance Criteria

- Function returns sequential IDs (1, 2, 3...)
- Function handles new prefix/type_code automatically (starts at 1)
- Function is atomic (verified by concurrent tests in KABSD-TSK-0311)
- Uses `BEGIN IMMEDIATE` to prevent race conditions during read-modify-write cycle

# Risks / Dependencies

**Risks**:
- SQLite locking behavior varies by OS (mitigate: use standard Python sqlite3)
- Performance impact (mitigate: keep transaction very short)

**Dependencies**:
- KABSD-TSK-0308 (Schema)

# Worklog

2026-01-26 02:11 [agent=opencode] Created item

2026-01-26 02:20 [agent=opencode] State -> InProgress.
2026-01-26 02:21 [agent=opencode] State -> Done.
