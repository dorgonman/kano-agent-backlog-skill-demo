---
id: KABSD-TSK-0128
uid: 019bac45-bf53-75f3-ae99-415f8393a7a9
type: Task
title: "Dashboard LOD: product + multi-product aggregation dashboards"
state: New
priority: P1
parent: KABSD-FTR-0011
area: views
iteration: null
tags: ["views", "dashboard", "lod", "multi-product"]
created: 2026-01-07
updated: 2026-01-07
owner: windsurf
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

The platform-level dashboards under `_kano/backlog/views/` are currently empty in this demo because the scripts default to scanning `_kano/backlog/items/`, while the demo backlog items live under product roots (e.g. `_kano/backlog/products/kano-agent-backlog-skill/items/`).

We want a Level of Detail (LOD) concept:

1. Product view: dashboards that only include a single product’s items.
2. Aggregated view: dashboards that include items across multiple selected products (2-3), or all products.

# Goal

Implement dashboard generation that supports:

1. Generating product-scoped dashboards into `_kano/backlog/products/<product>/views/`.
2. Generating aggregated dashboards across multiple products into `_kano/backlog/views/`.
3. Avoiding empty dashboards when products contain items.
4. Preserving backwards compatibility for current single-product usage.

# Approach

1. Extend `view_refresh_dashboards.py` to accept a new `--products` argument (repeatable or comma-separated list).
2. Ensure `--product` generates dashboards into the product view folder.
3. When `--products` is provided (or an explicit `--all-products`), generate aggregated dashboards into the platform view folder.
4. Extend `view_generate.py` to accept `--products` and gather items across the selected product roots.
5. Prefer SQLite index per product when enabled; fall back to file scan as needed.

# Acceptance Criteria

- [ ] Running dashboard refresh for a product produces non-empty dashboards in `_kano/backlog/products/<product>/views/`.
- [ ] Running dashboard refresh for multiple products produces non-empty dashboards in `_kano/backlog/views/`.
- [ ] Existing `--product <name>` behavior remains compatible (no breaking changes).
- [ ] Aggregation handles products with and without SQLite index enabled.
- [ ] Generated dashboards clearly represent New / InProgress / Done groupings as before.

# Risks / Dependencies

- Terminal automation is currently not available in this environment; dashboard refresh verification may need to be run manually.
- Aggregation may be slower if multiple products are file-scanned; the implementation should minimize redundant scans.
- Output path decisions must not overwrite or mix platform dashboards with product dashboards.

# Worklog

2026-01-07 00:00 [agent=windsurf] Created manually (terminal tool unavailable to run `workitem_create.py`). Ready gate sections filled to allow code changes.
2026-01-08 08:45 [agent=windsurf] Updated view generation header: Source now prefers repo-relative paths, and views include a copy-pastable Command block for regeneration/verification.
