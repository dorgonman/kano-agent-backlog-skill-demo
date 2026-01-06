---
id: ADR-0005
title: Product Column Retention in Per-Product Indexes
status: Accepted
decision_date: 2026-01-07
---

# Context

When implementing per-product isolated indexes, a question arose: if each product owns its own SQLite database, why include a `product` column in the schema?

Arguments for removing it:
- Redundant (the file path already indicates product)
- Adds storage overhead
- Column values are always the same for a given database

Arguments for keeping it:
- Self-documentation (data independence from file paths)
- Consistency with composite key patterns
- Future extensibility (global embedding DB, cross-product queries)
- Error detection capability

# Decision

**Retain the `product` column in all schema tables.**

Each product's schema will include a `product` column despite the apparent redundancy.

# Rationale

## 1. Data Self-Documentation

The `product` column makes data self-describing. If a database dump or export is created, the product context is explicit in the data itself, not dependent on file path or metadata.

```sql
SELECT * FROM items WHERE product='kano-agent-backlog-skill';
-- vs.
SELECT * FROM items;  -- How do you know which product this is from?
```

## 2. Consistency with Composite Key Strategy

Using `(product, id)` as composite primary keys throughout the schema ensures:
- All foreign keys are uniform: `FOREIGN KEY (product, item_id)`
- Consistent pattern across all tables (items, item_tags, item_links, worklog_entries)
- Easier code generation and migrations

## 3. Uniform Schema Across Products

All products use identical schema structure. A tool that works with KABSD's index works with any product's index without modification. This is valuable for:
- Shared tool development
- Schema migration scripts
- Index validation and repair tools

## 4. Future Extensibility: Global Embedding Database

The primary long-term value is supporting a future global embedding database:

```sql
-- Global embedding store (future)
CREATE TABLE embeddings (
  product TEXT NOT NULL,
  item_id TEXT NOT NULL,
  embedding BLOB NOT NULL,
  PRIMARY KEY (product, item_id),
  FOREIGN KEY (product, item_id) REFERENCES all_items(product, id)
);
```

This would aggregate embeddings from all products while maintaining product context. The `product` column enables this without schema rework.

## 5. Error Detection

Including `product` column in per-product indexes enables validation queries:

```sql
-- Verify database integrity
SELECT DISTINCT product FROM items;
-- Should always return single row: kano-agent-backlog-skill

-- Detect misplaced files
SELECT product FROM items WHERE product != 'kano-agent-backlog-skill';
-- Should return empty set
```

## 6. Cross-Product Queries (Future)

When analytics or reporting tools are built, they may aggregate across products:

```sql
-- Future: Query across products via union or aggregation
SELECT product, COUNT(*) as item_count FROM all_items GROUP BY product;
```

The `product` column is essential for this without painful migrations.

# Implementation

All tables maintain the pattern:

```sql
CREATE TABLE items (
  product TEXT NOT NULL,
  id TEXT NOT NULL,
  uid UUID,
  type TEXT,
  -- ... other columns
  PRIMARY KEY (product, id)
);

CREATE TABLE item_tags (
  product TEXT NOT NULL,
  item_id TEXT NOT NULL,
  tag TEXT NOT NULL,
  PRIMARY KEY (product, item_id, tag),
  FOREIGN KEY (product, item_id) REFERENCES items(product, id)
);
```

# Alternatives Considered

### Remove product column entirely
- **Pros**: Minimal storage, no apparent redundancy
- **Cons**: Breaks future embedding DB design, harder to validate integrity, poor data self-documentation
- **Rejected**: Future extensibility cost is too high

### Make product optional/nullable
- **Pros**: Allows querying "which product" implicitly
- **Cons**: Makes schema ambiguous, difficult to enforce consistency
- **Rejected**: Product should always be explicit and required

# Future Work

When global embedding database is implemented:
- Product column in schema already prepared
- No schema migration required
- Tools can immediately work with cross-product data

# References

- [[KABSD-FTR-0010]]: Monorepo Platform Migration
- [[ADR-0004]]: Per-Product Isolated Index Architecture
