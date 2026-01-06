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
owner: antigravity
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

The SQLite index currently doesn't distinguish between products. We need to add a product dimension to ensure search/resolve only returns results from the active product.

# Goal

1.  Update SQLite schema to include a `product` column.
2.  Update indexer logic to tag items with their product name.
3.  Update resolver to filter by product.

# Acceptance Criteria

- `id_resolver` correctly disambiguates between the same ID in different products (e.g., `0001` in KABSD vs KCCS).
- Search results are scoped to the current product.
