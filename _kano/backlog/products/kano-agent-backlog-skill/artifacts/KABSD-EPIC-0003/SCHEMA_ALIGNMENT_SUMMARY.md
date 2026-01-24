# Schema Alignment Summary

## Date: 2026-01-24

## Objective

Unify `indexing_schema.sql` with `canonical_schema.sql` to comply with ADR-0012 and eliminate naming inconsistencies.

## Changes Made

### 1. Table Name Changes

| Old Name | New Name | Reason |
|----------|----------|--------|
| `worklog_entries` | `worklog` | Align with ADR-0012 canonical schema |
| `item_links` | `links` | Align with canonical schema |

### 2. Column Name Changes in `items` Table

| Old Name | New Name | Reason |
|----------|----------|--------|
| `parent_id` | `parent_uid` | Consistent with UID-based references |
| `source_path` | `path` | Align with canonical schema |
| `content_sha256` | `content_hash` | Align with canonical schema |
| `frontmatter_json` | `frontmatter` | Align with canonical schema |

### 3. Column Changes in `worklog` Table

| Old Column | New Column | Type Change |
|------------|------------|-------------|
| `id INTEGER PRIMARY KEY AUTOINCREMENT` | `uid TEXT PRIMARY KEY` | Use UUIDv7 for consistency |
| `occurred_at TEXT` (nullable) | `timestamp TEXT NOT NULL` | Required timestamp |
| `agent TEXT` (nullable) | `agent TEXT NOT NULL` | Required agent |
| `message TEXT NOT NULL` | `content TEXT NOT NULL` | Renamed for clarity |
| `raw_line TEXT NOT NULL` | (removed) | Not needed in canonical schema |

### 4. Column Changes in `links` Table

| Old Schema (`item_links`) | New Schema (`links`) |
|---------------------------|----------------------|
| `item_uid TEXT NOT NULL` | `source_uid TEXT NOT NULL` |
| `relation TEXT NOT NULL` | `type TEXT NOT NULL` |
| `target TEXT NOT NULL` (ID or URL) | `target_uid TEXT NOT NULL` (UID only) |
| `target_uid TEXT` (nullable) | (merged into target_uid) |
| PRIMARY KEY(item_uid, relation, target) | PRIMARY KEY(source_uid, target_uid, type) |

### 5. New Columns Added to `items` Table

- `mtime REAL` - File modification timestamp (for sync logic)
- `tags TEXT` - JSON array of tags (moved from separate table in some contexts)

## Verification

### Table Comparison

**indexing_schema.sql tables**:
- `schema_meta`
- `items`
- `item_tags`
- `links` ✓ (was `item_links`)
- `item_decisions`
- `worklog` ✓ (was `worklog_entries`)

**canonical_schema.sql tables**:
- `schema_meta`
- `items`
- `links`
- `worklog`
- `chunks` (not in indexing schema - for embedding/FTS)
- `workset_manifest` (not in indexing schema - workset-specific)
- `workset_provenance` (not in indexing schema - workset-specific)

### Alignment Status

| Feature | Status | Notes |
|---------|--------|-------|
| Table names | ✓ Aligned | `worklog_entries` → `worklog`, `item_links` → `links` |
| Column names | ✓ Aligned | `parent_id` → `parent_uid`, `source_path` → `path`, etc. |
| Primary keys | ✓ Aligned | Both use `uid TEXT PRIMARY KEY` |
| Foreign keys | ✓ Aligned | Both reference `items(uid)` |
| Indexes | ✓ Aligned | Index names updated to match new column names |

## Impact Analysis

### No Breaking Changes to Running Code

**Current state**: `index.py` only implements the `items` table with hardcoded schema.

**Impact**: 
- ✓ No immediate breaking changes (worklog, links tables not yet implemented)
- ✓ When implementing these tables in the future, use the aligned schema
- ✓ Prevents schema drift between indexing and canonical schemas

### Future Implementation

When implementing worklog/links indexing in `index.py`:
1. Use `worklog` table (not `worklog_entries`)
2. Use `links` table (not `item_links`)
3. Use `parent_uid` column (not `parent_id`)
4. Use `path` column (not `source_path`)

## Related Documents

- **ADR-0012**: Workset DB Uses Canonical Schema (No Parallel Schema)
- **canonical_schema.sql**: `_kano/backlog/products/<product>/_meta/canonical_schema.sql`
- **indexing_schema.sql**: `skills/kano-agent-backlog-skill/references/indexing_schema.sql`

## Rationale (from ADR-0012)

> "If workset has its own schema, it will diverge from the canonical data model over time, creating long-term maintenance cost, bugs, and integration friction."

By aligning `indexing_schema.sql` with `canonical_schema.sql`, we:
1. ✓ Avoid schema drift
2. ✓ Enable portable context with zero translation
3. ✓ Ensure deterministic rebuild
4. ✓ Maintain consistent identity & references
5. ✓ Future-proof for graph-assisted retrieval

## Conclusion

All schema naming inconsistencies have been resolved. The `indexing_schema.sql` now aligns with `canonical_schema.sql` per ADR-0012, ensuring:

- Consistent table names across all schemas
- Consistent column names and types
- No parallel schema maintenance burden
- Clear path for future implementation

**Status**: ✓ Complete
