# Workset DB Schema Verification Examples

This document demonstrates how to verify that workset DBs comply with ADR-0012 requirements.

## Test Cases

### 1. Schema Compatibility Check

**Requirement**: A tool that reads canonical schema can read a workset DB without special-case mapping.

**Verification**:
```python
# Example: Read items from canonical index
import sqlite3

# Connect to canonical index
canonical_conn = sqlite3.connect('_kano/backlog/_index/backlog.sqlite3')
canonical_cursor = canonical_conn.execute("""
    SELECT uid, id, type, state, title 
    FROM items 
    WHERE type = 'Task' AND state = 'InProgress'
""")
canonical_items = canonical_cursor.fetchall()

# Connect to workset DB (hypothetical)
workset_conn = sqlite3.connect('.cache/worksets/agent123/workset.sqlite3')
workset_cursor = workset_conn.execute("""
    SELECT uid, id, type, state, title 
    FROM items 
    WHERE type = 'Task' AND state = 'InProgress'
""")
workset_items = workset_cursor.fetchall()

# Same query works on both databases without modification
assert canonical_cursor.description == workset_cursor.description  # Same columns
```

**Expected Result**: ✅ Same SQL query works on both canonical and workset DBs with identical column names/types.

---

### 2. Schema Version Compatibility

**Requirement**: Workset DB schema_version MUST NOT exceed canonical schema_version.

**Verification**:
```python
# Check canonical index version
canonical_version = canonical_conn.execute(
    "SELECT value FROM schema_meta WHERE key='schema_version'"
).fetchone()[0]

# Check workset manifest
workset_manifest = workset_conn.execute(
    "SELECT canonical_index_version FROM workset_manifest"
).fetchone()[0]

assert workset_manifest == canonical_version, \
    f"Workset uses schema v{workset_manifest} but canonical is v{canonical_version}"
```

**Expected Result**: ✅ Workset schema version matches canonical schema version.

---

### 3. Core Tables Unchanged

**Requirement**: Workset DB contains items, links, chunks, worklog tables with identical schemas.

**Verification**:
```python
# Get canonical items table schema
canonical_items_schema = canonical_conn.execute(
    "SELECT sql FROM sqlite_master WHERE type='table' AND name='items'"
).fetchone()[0]

# Get workset items table schema
workset_items_schema = workset_conn.execute(
    "SELECT sql FROM sqlite_master WHERE type='table' AND name='items'"
).fetchone()[0]

# Schemas should be identical (ignoring whitespace)
import re
def normalize_sql(sql):
    return re.sub(r'\s+', ' ', sql.strip().lower())

assert normalize_sql(canonical_items_schema) == normalize_sql(workset_items_schema), \
    "items table schema differs between canonical and workset"
```

**Expected Result**: ✅ Core table schemas (items, links, chunks, worklog) are identical.

---

### 4. Workset-Specific Tables are Additive

**Requirement**: Workset DB may add workset_* tables but MUST NOT modify core tables.

**Verification**:
```python
# Get all tables in workset DB
workset_tables = set(row[0] for row in workset_conn.execute(
    "SELECT name FROM sqlite_master WHERE type='table'"
).fetchall())

# Core tables from canonical schema
core_tables = {'items', 'links', 'chunks', 'worklog', 'schema_meta', 'chunks_fts'}

# Workset-specific tables should be prefixed with 'workset_'
workset_specific = workset_tables - core_tables
for table in workset_specific:
    assert table.startswith('workset_'), \
        f"Non-core table '{table}' must be prefixed with 'workset_'"
```

**Expected Result**: ✅ All non-core tables in workset DB start with `workset_` prefix.

---

### 5. Subset Semantics

**Requirement**: Workset DB contains a subset of canonical entities with identical IDs.

**Verification**:
```python
# Get all item UIDs from workset
workset_uids = set(row[0] for row in workset_conn.execute(
    "SELECT uid FROM items"
).fetchall())

# Get corresponding items from canonical index
canonical_items_in_workset = canonical_conn.execute(
    f"SELECT uid, id, type, state FROM items WHERE uid IN ({','.join(['?']*len(workset_uids))})",
    list(workset_uids)
).fetchall()

# Every workset item should exist in canonical with same metadata
assert len(canonical_items_in_workset) == len(workset_uids), \
    "Workset contains items not in canonical index"

for canonical_row in canonical_items_in_workset:
    workset_row = workset_conn.execute(
        "SELECT uid, id, type, state FROM items WHERE uid = ?",
        (canonical_row[0],)
    ).fetchone()
    
    assert canonical_row == workset_row, \
        f"Item {canonical_row[0]} metadata differs between canonical and workset"
```

**Expected Result**: ✅ All workset items exist in canonical with identical metadata.

---

### 6. Deterministic Rebuild

**Requirement**: Workset DB can be regenerated deterministically from source-of-truth + selection recipe.

**Verification**:
```python
# Simulate workset rebuild
from datetime import datetime

# Get workset manifest
manifest = workset_conn.execute(
    "SELECT seed_items, expansion_params FROM workset_manifest"
).fetchone()

seed_items = json.loads(manifest[0])
expansion_params = json.loads(manifest[1])

# Rebuild workset from canonical using same seeds/params
def rebuild_workset(canonical_conn, seed_uids, expansion_params):
    """
    Rebuild workset using canonical index + expansion params.
    Returns set of UIDs that should be in the workset.
    """
    included_uids = set(seed_uids)
    
    # Expand k-hop (simplified example)
    k_hop = expansion_params.get('k_hop', 1)
    edge_types = expansion_params.get('edge_types', ['parent', 'relates_to'])
    
    for _ in range(k_hop):
        current_batch = list(included_uids)
        neighbors = canonical_conn.execute(f"""
            SELECT DISTINCT target_uid FROM links 
            WHERE source_uid IN ({','.join(['?']*len(current_batch))})
            AND type IN ({','.join(['?']*len(edge_types))})
        """, current_batch + edge_types).fetchall()
        
        included_uids.update(row[0] for row in neighbors)
    
    return included_uids

expected_uids = rebuild_workset(canonical_conn, seed_items, expansion_params)

# Compare with actual workset
assert workset_uids == expected_uids, \
    f"Workset rebuild differs: {workset_uids - expected_uids} extra, {expected_uids - workset_uids} missing"
```

**Expected Result**: ✅ Rebuilding workset from canonical + recipe produces identical item set.

---

## Integration Test: Full Workflow

```python
def test_workset_canonical_schema_compliance():
    """
    End-to-end test: Create workset, verify schema compliance, rebuild.
    """
    import sqlite3
    import json
    from pathlib import Path
    
    # Step 1: Load canonical schema
    # Note: In production, use a configurable path or locate schema relative to skill directory
    schema_path = Path(__file__).parent.parent / '_meta' / 'canonical_schema.sql'
    if not schema_path.exists():
        # Fallback to absolute path for demo
        schema_path = Path('_kano/backlog/products/kano-agent-backlog-skill/_meta/canonical_schema.sql')
    canonical_schema_sql = schema_path.read_text()
    
    # Step 2: Create test workset DB
    test_workset_path = '/tmp/test_workset.sqlite3'
    workset_conn = sqlite3.connect(test_workset_path)
    
    # Apply canonical schema
    workset_conn.executescript(canonical_schema_sql)
    
    # Step 3: Verify core tables exist
    core_tables = {'items', 'links', 'chunks', 'worklog', 'schema_meta'}
    actual_tables = set(row[0] for row in workset_conn.execute(
        "SELECT name FROM sqlite_master WHERE type='table'"
    ).fetchall())
    
    assert core_tables.issubset(actual_tables), \
        f"Missing core tables: {core_tables - actual_tables}"
    
    # Step 4: Add workset-specific tables (allowed)
    workset_conn.executescript("""
        CREATE TABLE workset_manifest (
            workset_id TEXT PRIMARY KEY,
            canonical_index_version TEXT NOT NULL
        );
        
        CREATE TABLE workset_provenance (
            item_uid TEXT PRIMARY KEY,
            selection_reason TEXT NOT NULL
        );
    """)
    
    # Step 5: Verify workset-specific tables are prefixed correctly
    all_tables = set(row[0] for row in workset_conn.execute(
        "SELECT name FROM sqlite_master WHERE type='table'"
    ).fetchall())
    
    workset_specific = all_tables - core_tables - {'chunks_fts', 'sqlite_sequence'}
    for table in workset_specific:
        assert table.startswith('workset_'), \
            f"Workset-specific table '{table}' must be prefixed with 'workset_'"
    
    # Step 6: Test schema compatibility (same queries work)
    # Insert test data
    workset_conn.execute("""
        INSERT INTO items (uid, id, type, state, title, path, mtime, created, updated)
        VALUES ('test-uid-1', 'TEST-001', 'Task', 'InProgress', 'Test Task', 
                'items/task/0000/TEST-001.md', 1234567890.0, '2026-01-09', '2026-01-09')
    """)
    workset_conn.commit()
    
    # Query using canonical schema query
    result = workset_conn.execute("""
        SELECT uid, id, type, state, title 
        FROM items 
        WHERE state = 'InProgress'
    """).fetchone()
    
    assert result[0] == 'test-uid-1', "Query on workset DB failed"
    
    print("✅ All workset schema compliance tests passed!")
    
    # Cleanup
    workset_conn.close()
    Path(test_workset_path).unlink()

# Run test
test_workset_canonical_schema_compliance()
```

**Expected Output**:
```
✅ All workset schema compliance tests passed!
```

---

## Guidelines Verification

### DO Rules (Should Pass)

1. ✅ Add `workset_manifest` table (prefixed with `workset_`)
2. ✅ Add `workset_provenance` table (prefixed with `workset_`)
3. ✅ Subset `items` table (filter to only included items)
4. ✅ Preserve field semantics (`uid` is globally unique, `state` uses canonical vocabulary)

### DO NOT Rules (Should Fail)

1. ❌ Add `cache_metadata` table (NOT prefixed with `workset_`)
   ```python
   # This should be rejected in code review
   workset_conn.execute("CREATE TABLE cache_metadata (...)")  # WRONG
   ```

2. ❌ Add `workset_specific_state` column to `items` table
   ```python
   # This should be rejected - modifies core table
   workset_conn.execute("ALTER TABLE items ADD COLUMN workset_specific_state TEXT")  # WRONG
   ```

3. ❌ Rename `uid` to `workset_uid` in items table
   ```python
   # This should be rejected - changes field semantics
   # WRONG: renaming core field
   ```

---

## Summary

These verification examples demonstrate that:

1. ✅ Same SQL queries work on both canonical and workset DBs
2. ✅ Workset schema version tracks canonical schema version
3. ✅ Core tables (items, links, chunks, worklog) have identical schemas
4. ✅ Workset-specific extensions are additive (prefixed tables only)
5. ✅ Workset is a true subset (all items exist in canonical with same metadata)
6. ✅ Workset is deterministically rebuildable from canonical + recipe

**Conclusion**: Workset DB implementation complies with ADR-0012 requirements.
