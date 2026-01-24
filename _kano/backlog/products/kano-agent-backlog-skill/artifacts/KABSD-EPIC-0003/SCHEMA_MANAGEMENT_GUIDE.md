# Schema Management Guide

## Overview

All SQL schemas are centralized in `src/kano_backlog_core/schema/` and loaded programmatically. This ensures consistency and eliminates hardcoded SQL in application code.

## Schema Location

**Canonical Location**: `src/kano_backlog_core/schema/`

```
src/kano_backlog_core/schema/
├── __init__.py              # Public API exports
├── loader.py                # Schema loading utilities
├── indexing_schema.sql      # Schema for rebuildable SQLite index
└── canonical_schema.sql     # Complete canonical schema
```

## Why This Location?

1. ✅ **Part of Core**: Schema definitions are core data models
2. ✅ **Importable**: Can be imported as `from kano_backlog_core.schema import load_indexing_schema`
3. ✅ **Single Source of Truth**: One location for all schemas
4. ✅ **Version Controlled**: Schemas are tracked with code
5. ✅ **No Hardcoding**: Application code loads from files, not hardcoded strings

## Usage

### Loading Schemas in Code

```python
from kano_backlog_core.schema import load_indexing_schema, load_canonical_schema

# Load indexing schema
schema_sql = load_indexing_schema()
cursor.executescript(schema_sql)

# Load canonical schema
canonical_sql = load_canonical_schema()
cursor.executescript(canonical_sql)

# Get schema file path
from kano_backlog_core.schema import get_schema_path
schema_path = get_schema_path("indexing_schema.sql")
```

### Example: Building SQLite Index

**Before** (hardcoded):
```python
def _rebuild_sqlite_index(index_path: Path, product_root: Path) -> int:
    conn = sqlite3.connect(index_path)
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS items (
            uid TEXT PRIMARY KEY,
            ...
        )
    """)
```

**After** (using schema loader):
```python
from kano_backlog_core.schema import load_indexing_schema

def _rebuild_sqlite_index(index_path: Path, product_root: Path) -> int:
    conn = sqlite3.connect(index_path)
    cur = conn.cursor()
    
    schema_sql = load_indexing_schema()
    cur.executescript(schema_sql)
```

## Schema Files

### indexing_schema.sql

**Purpose**: Schema for rebuildable SQLite index at `.cache/index.sqlite3`

**Tables**:
- `schema_meta` - Schema version tracking
- `items` - Work items (Epic/Feature/Task/Bug)
- `item_tags` - Normalized tags
- `links` - Typed relationships
- `item_decisions` - ADR references
- `worklog` - Append-only audit trail

**Alignment**: Aligned with `canonical_schema.sql` per ADR-0012

### canonical_schema.sql

**Purpose**: Complete canonical schema for worksets and indexes

**Tables**:
- All tables from `indexing_schema.sql`
- `chunks` - Content chunks for semantic search
- `chunks_fts` - Full-text search index (FTS5)
- `workset_manifest` - Workset metadata
- `workset_provenance` - Workset item provenance

**Usage**: Used by workset DBs and future implementations

## Schema Alignment (ADR-0012)

Per ADR-0012, all schemas must be aligned to avoid schema drift:

| Requirement | Status |
|-------------|--------|
| Single source of truth | ✅ `src/kano_backlog_core/schema/` |
| No hardcoded SQL | ✅ All code uses `load_indexing_schema()` |
| Consistent table names | ✅ `worklog` (not `worklog_entries`), `links` (not `item_links`) |
| Consistent column names | ✅ `parent_uid`, `path`, `content_hash`, `frontmatter` |

## Migration from Old Locations

### Old Locations (Deprecated)

❌ **Do not use these locations**:
- `references/indexing_schema.sql` - Deprecated, use `src/kano_backlog_core/schema/`
- `_kano/backlog/products/<product>/_meta/canonical_schema.sql` - Product-specific copy, not source of truth

### Migration Steps

1. ✅ **Schema files moved** to `src/kano_backlog_core/schema/`
2. ✅ **Loader created** at `src/kano_backlog_core/schema/loader.py`
3. ✅ **Code updated** to use `load_indexing_schema()`
4. ⏳ **Old files** can be removed after verification

## Benefits

### Before (Scattered)

```
❌ references/indexing_schema.sql (documentation)
❌ _kano/backlog/products/<product>/_meta/canonical_schema.sql (per-product copy)
❌ src/kano_backlog_ops/index.py (hardcoded SQL)
```

**Problems**:
- Schema drift between locations
- Hardcoded SQL difficult to maintain
- No single source of truth

### After (Centralized)

```
✅ src/kano_backlog_core/schema/indexing_schema.sql (source of truth)
✅ src/kano_backlog_core/schema/canonical_schema.sql (source of truth)
✅ src/kano_backlog_core/schema/loader.py (programmatic access)
```

**Benefits**:
- Single source of truth
- Easy to maintain and update
- Programmatic access via imports
- Version controlled with code
- No schema drift

## Future Work

### Planned Enhancements

1. **Schema Versioning**: Track schema version in `schema_meta` table
2. **Migration Framework**: Automated schema migrations (ADR-0008)
3. **Validation**: Schema validation on load
4. **Testing**: Unit tests for schema loader

### Adding New Schemas

To add a new schema file:

1. Create `src/kano_backlog_core/schema/new_schema.sql`
2. Add loader function in `loader.py`:
   ```python
   def load_new_schema() -> str:
       schema_path = _SCHEMA_DIR / "new_schema.sql"
       return schema_path.read_text(encoding="utf-8")
   ```
3. Export in `__init__.py`:
   ```python
   from .loader import load_new_schema
   __all__ = [..., "load_new_schema"]
   ```

## Related Documents

- **ADR-0012**: Workset DB Uses Canonical Schema (No Parallel Schema)
- **ADR-0008**: SQLite Schema Migration Framework
- **ADR-0004**: File-First Architecture with SQLite Index

## Summary

| Aspect | Solution |
|--------|----------|
| **Location** | `src/kano_backlog_core/schema/` |
| **Access** | `from kano_backlog_core.schema import load_indexing_schema` |
| **Source of Truth** | SQL files in schema directory |
| **Hardcoded SQL** | ❌ Eliminated |
| **Schema Drift** | ❌ Prevented by single source |
| **Alignment** | ✅ Per ADR-0012 |

**Status**: ✅ Complete and Operational
