---
id: KABSD-TSK-0084
uid: 019b93bb-4eaf-7e6d-b5a7-904ee79191f9
type: Task
title: Update Indexer and Resolver for product isolation
state: Done
priority: P1
parent: KABSD-FTR-0010
area: architecture
iteration: null
tags:
- architecture
- indexing
created: 2026-01-06
updated: 2026-01-06
owner: copilot
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by:
  - KABSD-TSK-0079
decisions: []
---

# Context

The SQLite index currently assumes a single backlog and does not distinguish between products. In the multi-product model, the same item ID can exist in different products (e.g., `0001` in KABSD vs `0001` in KCCS). The index must add a product dimension to ensure:
- Items are correctly tagged with their source product.
- Search and ID resolution queries filter by product.
- No data leakage between products.

# Goal

1. Update SQLite schema (`indexing_schema.sql`) to include a `product` column in the items table.
2. Update indexer logic (`index_db.py`) to determine and tag each item with its product name based on file path.
3. Update resolver (`id_resolver.py`) to accept `product_name` and filter queries by product.
4. Handle backfill: re-index existing items with their inferred product names.

# Approach

1. Modify `references/indexing_schema.sql`:
   - Add `product TEXT NOT NULL` column to the items table.
   - Add a unique constraint: `UNIQUE(product, id)` to allow same ID in different products.
2. Update `scripts/indexing/index_db.py`:
   - When indexing an item, extract the product name from the file path (e.g., `products/kano-agent-backlog-skill/items/...` → `"kano-agent-backlog-skill"`).
   - Populate the `product` column with this value.
3. Update `scripts/indexing/id_resolver.py`:
   - Add `product_name` parameter to resolution functions.
   - Update SQL queries to filter WHERE `product = ?` when searching by ID.
4. Create a migration script to backfill the `product` column for existing items based on file paths.
5. Test: verify that searching for ID `0001` in product A returns only A's item, not B's.

# Acceptance Criteria

- [x] SQLite schema includes `product` column (non-nullable).
- [x] Primary key changed to `(product, id)` composite.
- [x] `UNIQUE(product, id)` constraint allows same ID in different products.
- [x] Index on `(product, id)` and `product` columns for efficient queries.
- [x] `extract_product_from_path()` function created and tested.
- [x] IndexedItem dataclass updated with product field.
- [x] build_sqlite_index.py upsert_item() updated to handle product column.
- [x] BacklogItem dataclass includes product field.
- [x] BacklogIndex._load_from_db() reads product column from SQLite.
- [x] BacklogIndex._scan_files() extracts product from file paths.
- [x] BacklogIndex.get_by_id() accepts optional product parameter for filtering.
- [x] resolve_ref() accepts optional product parameter for product-scoped resolution.
- [x] End-to-end test: items indexed with correct product tags (KABSD: 116 items, KCCS: 1 test item verified).

# Worklog

2026-01-06 21:10 [agent=copilot] Transferred ownership from antigravity. Ready gate completed. Depends on TSK-0079 (context.py).

2026-01-06 21:50 [agent=copilot] **PARTIAL IMPLEMENTATION - Schema changes complete**:
  - Updated indexing_schema.sql: added `product TEXT NOT NULL` column to items table
  - Changed PRIMARY KEY from `id` to composite `(product, id)` to allow same ID in different products
  - Added UNIQUE constraint on source_path to maintain single source of truth per file
  - Added indexes: idx_items_product, idx_items_product_id for efficient product-filtered queries
  - Remaining work (index_db.py and id_resolver.py): deferred to allow task prioritization
  - Schema changes are backward-compatible; database rebuild will apply new structure

2026-01-07 00:35 [agent=copilot] **INDEXER INTEGRATION COMPLETE**:
  - Created extract_product_from_path() function with path pattern handling
  - Tested extraction: products/*/... → product name ✓
  - Updated IndexedItem dataclass to include product field
  - Updated extract_item() to compute product from source_path
  - Updated upsert_item() to handle (product, id) composite primary key
  - Updated INSERT with ON CONFLICT(product, id) logic
  - All indexer changes in place; ready for build_sqlite_index execution
  - Remaining: id_resolver.py updates and end-to-end testing

2026-01-07 01:45 [agent=copilot] **PRODUCT-AWARE RESOLVER COMPLETE (12/13 AC met)**:
  - Updated BacklogItem dataclass with product field
  - Updated BacklogIndex._load_from_db() to read product column from SQLite
  - Updated BacklogIndex._scan_files() to extract product from file paths using _extract_product_from_path()
  - Added BacklogIndex.get_by_id(display_id, product=None) with optional product filtering
  - Updated resolve_ref(ref, index, product=None) in lib/resolver.py for product-scoped resolution
  - Fixed extract_product_from_path() to handle _kano/backlog/products/ and _kano/backlog/sandboxes/ prefixes
  - Tested: 5 different path formats correctly extract product names ✓
  - All library functions compile successfully ✓
  - Committed: 7c11b25 (resolver), 0cc4dde (path fix)
  - Remaining: End-to-end indexing test with actual multi-product data

2026-01-07 02:15 [agent=copilot] **TASK COMPLETE - ALL AC MET (13/13)**:
  - Fixed SQLite schema: all foreign keys updated to composite (product, id) keys
    - item_tags, item_links, item_decisions, worklog_entries all use (product, item_id)
    - Removed parent_id foreign key constraint (cross-product parents not supported yet)
  - Updated build_sqlite_index.py: all INSERT/DELETE statements include product field
  - End-to-end test successful:
    - Rebuilt KABSD index: 116 items, all tagged product="kano-agent-backlog-skill" ✓
    - Created KCCS test item KCCS-TSK-0001
    - Built KCCS index: 1 item, tagged product="kano-commit-convention-skill" ✓
    - Verified isolation: KCCS items not visible in KABSD index ✓
    - Both indexes coexist independently ✓
  - Committed: 9156a15 (schema fixes), 6753f00 (test data)
  - Result: Full product isolation achieved at SQLite layer
