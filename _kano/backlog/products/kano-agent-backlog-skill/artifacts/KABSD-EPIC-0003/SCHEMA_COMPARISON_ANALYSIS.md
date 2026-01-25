# Schema Comparison: indexing_schema.sql vs 002_embedding_search.sql

## Overview

Two schemas serve different purposes:
- **indexing_schema.sql**: Metadata index for fast queries
- **002_embedding_search.sql**: Content index for semantic search

## Table Comparison

### Common Concepts (Different Implementations)

| Concept | indexing_schema.sql | 002_embedding_search.sql | Can Merge? |
|---------|---------------------|--------------------------|------------|
| **Documents** | `items` table | `documents` table | ✅ Yes |
| **Metadata** | `schema_meta` table | `metadata` table | ✅ Yes |
| **Content Chunks** | ❌ Not present | `chunks` table | ➕ Add to indexing |
| **Full-Text Search** | ❌ Not present | `chunks_fts` (FTS5) | ➕ Add to indexing |
| **Links** | `links` table | ❌ Not present | ➕ Add to embedding |
| **Tags** | `item_tags` table | ❌ Not present | ➕ Add to embedding |
| **Worklog** | `worklog` table | ❌ Not present | ➕ Add to embedding |
| **Decisions** | `item_decisions` table | ❌ Not present | ➕ Add to embedding |

### Detailed Comparison

#### Documents/Items Table

**indexing_schema.sql** (`items`):
```sql
CREATE TABLE items (
  uid TEXT PRIMARY KEY,
  id TEXT NOT NULL,
  product TEXT NOT NULL,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  state TEXT,
  priority TEXT,
  parent_uid TEXT,
  area TEXT,
  iteration TEXT,
  owner TEXT,
  created TEXT,
  updated TEXT,
  path TEXT NOT NULL,
  mtime REAL,
  content_hash TEXT,
  frontmatter TEXT NOT NULL,
  tags TEXT
);
```

**002_embedding_search.sql** (`documents`):
```sql
CREATE TABLE documents (
    id TEXT PRIMARY KEY,
    doc_type TEXT NOT NULL,
    item_type TEXT,
    title TEXT NOT NULL,
    state TEXT,
    product TEXT,
    source_path TEXT NOT NULL,
    path_hash TEXT NOT NULL,
    created_at TEXT,
    updated_at TEXT,
    metadata_json TEXT
);
```

**Differences**:
| Field | indexing_schema | embedding_search | Notes |
|-------|----------------|------------------|-------|
| Primary Key | `uid` | `id` | Different naming |
| Product | `product` | `product` | ✅ Same |
| Type | `type` | `doc_type` + `item_type` | Different structure |
| Path | `path` | `source_path` | Different naming |
| Hash | `content_hash` | `path_hash` | Different purpose |
| Metadata | `frontmatter` (JSON) | `metadata_json` | ✅ Similar |
| Extra Fields | priority, parent_uid, area, iteration, owner, mtime | (none) | indexing has more |

## Proposed Unified Schema

### Option 1: Extend indexing_schema.sql (Recommended)

Add embedding-specific tables to `indexing_schema.sql`:

```sql
-- Base schema (existing)
CREATE TABLE items (...);
CREATE TABLE links (...);
CREATE TABLE worklog (...);
CREATE TABLE item_tags (...);
CREATE TABLE item_decisions (...);

-- Add embedding-specific tables
CREATE TABLE chunks (
  chunk_rowid INTEGER PRIMARY KEY AUTOINCREMENT,
  id TEXT NOT NULL UNIQUE,
  item_uid TEXT NOT NULL,  -- FK to items.uid
  section_path TEXT,
  chunk_kind TEXT,
  chunk_index INTEGER,
  text TEXT NOT NULL,
  chunk_hash TEXT NOT NULL,
  embedding_generated BOOLEAN DEFAULT 0,
  FOREIGN KEY (item_uid) REFERENCES items(uid)
);

CREATE VIRTUAL TABLE chunks_fts USING fts5(
  item_uid,
  section_path,
  chunk_kind,
  text,
  product,
  content=chunks,
  content_rowid=chunk_rowid
);

-- FTS5 triggers (same as 002_embedding_search.sql)
```

**Benefits**:
- ✅ Single unified schema
- ✅ Reuse existing `items` table
- ✅ Add chunks as extension
- ✅ No duplication

### Option 2: Keep Separate (Current State)

Keep two schemas for different use cases:

**indexing_schema.sql**:
- Fast metadata queries
- Lightweight
- Always built

**002_embedding_search.sql**:
- Semantic search
- Heavy (with embeddings)
- Optional (only if embedding enabled)

**Benefits**:
- ✅ Separation of concerns
- ✅ Can disable embedding without affecting index
- ✅ Different rebuild frequencies

**Drawbacks**:
- ❌ Data duplication (documents vs items)
- ❌ Two schemas to maintain
- ❌ Potential drift

## Recommendation

### Hybrid Approach: Modular Schema

Create a **base schema** + **optional extensions**:

```
src/kano_backlog_core/schema/
├── base_schema.sql          # Core tables (items, links, worklog)
├── embedding_extension.sql  # Chunks + FTS5 tables
└── loader.py                # Load base + optional extensions
```

**Usage**:
```python
from kano_backlog_core.schema import load_schema

# Load base only
schema = load_schema(extensions=[])

# Load base + embedding
schema = load_schema(extensions=['embedding'])
```

**Implementation**:
```python
def load_schema(extensions: list[str] = None) -> str:
    base = load_base_schema()
    
    if not extensions:
        return base
    
    parts = [base]
    if 'embedding' in extensions:
        parts.append(load_embedding_extension())
    
    return '\n\n'.join(parts)
```

## Migration Plan

### Step 1: Extract Common Base

Create `base_schema.sql` with common tables:
- `schema_meta` / `metadata` → unified as `schema_meta`
- `items` table (keep rich metadata from indexing_schema)

### Step 2: Create Extensions

**embedding_extension.sql**:
```sql
-- Chunks table (references items.uid)
CREATE TABLE IF NOT EXISTS chunks (...);

-- FTS5 virtual table
CREATE VIRTUAL TABLE IF NOT EXISTS chunks_fts USING fts5(...);

-- FTS5 triggers
CREATE TRIGGER chunks_ai ...;
CREATE TRIGGER chunks_ad ...;
CREATE TRIGGER chunks_au ...;
```

### Step 3: Update Loaders

```python
# src/kano_backlog_core/schema/loader.py

def load_indexing_schema(with_embedding: bool = False) -> str:
    base = load_base_schema()
    if with_embedding:
        base += '\n\n' + load_embedding_extension()
    return base
```

### Step 4: Deprecate 002_embedding_search.sql

Move to modular approach, deprecate standalone embedding schema.

## Summary

| Approach | Pros | Cons | Recommendation |
|----------|------|------|----------------|
| **Merge into one** | Single schema, no duplication | Heavy even without embedding | ❌ Not recommended |
| **Keep separate** | Clean separation | Data duplication, drift risk | ⚠️ Current state |
| **Modular (base + extensions)** | Flexible, no duplication, clear structure | Requires refactoring | ✅ **Recommended** |

## Next Steps

1. ✅ Identify common tables and fields
2. ⏳ Extract base schema
3. ⏳ Create embedding extension
4. ⏳ Update schema loader
5. ⏳ Migrate existing code
6. ⏳ Deprecate 002_embedding_search.sql

**Status**: Analysis complete, awaiting decision on approach
