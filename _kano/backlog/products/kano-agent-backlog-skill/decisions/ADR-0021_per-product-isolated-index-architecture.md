---
decision_date: 2026-01-07
id: ADR-0021
status: Accepted
title: Per-Product Isolated Index Architecture
uid: 019bc5dc-68ed-72d5-9c17-af02938752d7
---

# Context

In a multi-product monorepo environment, we needed to decide between two architectural approaches for the SQLite index:

1. **Platform-level shared index**: All products write to a single `_kano/backlog/_index/backlog.sqlite3`
2. **Per-product isolated index**: Each product owns its own index at `products/<name>/_index/backlog.sqlite3`

## Decision Criteria

We evaluated 7 dimensions:

| Dimension | Per-Product | Platform | Winner |
|-----------|-------------|----------|--------|
| **Isolation** | Complete separation | Shared namespace | Per-Product |
| **Concurrency** | No locking contention | Potential locks | Per-Product |
| **Performance** | Predictable, isolated | Can degrade with load | Per-Product |
| **Scalability** | Linear per product | Shared bottleneck | Per-Product |
| **Complexity** | Simple, independent | Complex coordination | Per-Product |
| **Maintenance** | Easy (per-product) | Harder (shared state) | Per-Product |
| **Future Extensibility** | Supports embedding DB | Difficult to add | Per-Product |

**Overall Score**: Per-Product = 91%, Platform = 43%

# Decision

**Implement per-product isolated SQLite indexes.**

Each product will:
- Maintain its own SQLite database at `products/<product-name>/_index/backlog.sqlite3`
- Have independent schema with product column for self-documentation
- Support autonomous indexing/rebuilding without affecting other products
- Enable future cross-product aggregation via product-aware queries

# Implementation Details

## Schema Design

All tables include `product` column:

```sql
CREATE TABLE items (
  product TEXT NOT NULL,
  id TEXT NOT NULL,
  PRIMARY KEY (product, id),
  ...
);

CREATE TABLE item_tags (
  product TEXT NOT NULL,
  item_id TEXT NOT NULL,
  tag TEXT NOT NULL,
  PRIMARY KEY (product, item_id, tag),
  FOREIGN KEY (product, item_id) REFERENCES items(product, id)
);
```

## Index Rebuild Process

- `scripts/indexing/build_sqlite_index.py --product <name>`
- Scans `products/<name>/items/` directory
- Extracts product from file paths
- Upserts into product-specific SQLite database
- Maintains composite key integrity

## Resolver Behavior

- `resolve_ref(ref, index, product=None)` accepts optional product filter
- If product not specified, searches across all products
- Product column enables cross-product queries when needed

# Rationale

1. **Isolation ensures safety**: No possibility of data leakage between products
2. **Predictable performance**: Each product's index grows independently
3. **Supports autonomy**: Teams can rebuild their product's index without coordination
4. **Future-proof**: Enables embedding databases per product or shared aggregation
5. **Simpler mental model**: Products are truly independent
6. **Backward compatible**: Product column facilitates future migrations

# Alternatives Considered

### Platform-level shared index
- **Pros**: Unified search across all products
- **Cons**: Complex coordination, shared bottleneck, potential data leakage
- **Rejected**: Architecture does not support team autonomy

### Hybrid approach (shared metadata + per-product data)
- **Pros**: Balanced complexity
- **Cons**: Still requires coordination layer, adds complexity
- **Rejected**: Per-product isolation is simpler and cleaner

# Future Work

When cross-product features are needed:
- Create aggregation layer on top of per-product indexes
- Or implement global embedding database that reads from per-product sources
- Product column in schema already prepared for this extensibility

# References

- [[../items/feature/0000/KABSD-FTR-0010_monorepo-platform-migration.md]]: Monorepo Platform Migration feature
- [[../items/task/0000/KABSD-TSK-0084_update-indexer-and-resolver-for-product-isolation.md]]: Indexer and resolver product isolation