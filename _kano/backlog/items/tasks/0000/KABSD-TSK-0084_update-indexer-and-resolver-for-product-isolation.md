---
id: KABSD-TSK-0084
uid: 019b93bb-4eaf-7e6d-b5a7-904ee79191f9
type: Task
title: Update Indexer and Resolver for product isolation
state: New
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

- SQLite schema includes `product` column (non-nullable).
- `index_db.py` tags items with their product name based on file path.
- `id_resolver.resolve("0001", product="KABSD")` returns only KABSD's item with that ID.
- `id_resolver.resolve("0001", product="KCCS")` returns only KCCS's item (if it exists), not KABSD's.
- Backfill script correctly tags all existing items with `"kano-agent-backlog-skill"`.
- Unique constraint prevents accidental duplicate IDs within the same product.

# Worklog

2026-01-06 21:10 [agent=copilot] Transferred ownership from antigravity. Ready gate completed. Depends on TSK-0079 (context.py).
