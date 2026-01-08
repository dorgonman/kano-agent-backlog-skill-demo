# Project vs Product terminology

## Definitions

Project

- An organizational and delivery boundary.
- Owns governance, release cadence, and security posture.
- May span one repo or multiple repos.

Product

- A backlog/config boundary for items, dashboards, and derived data.
- A product is the unit you "focus" on in views (single-product) and the unit used for product-level ACL in the future.
- Lives under a product root folder.

## Mapping patterns

1 project -> 1 product

- Prefer when the repo/project primarily ships one sellable product or one cohesive service.
- Simplifies onboarding and reduces configuration surface.

1 project -> N products

- Prefer when a single delivery organization ships multiple sellable services.
- Each product has its own backlog, config, and views; platform-level views can aggregate across products.

Cross-repo

- A project can span repos; products can still be represented as multiple product roots (one per repo) and later unified via a cloud coordinator/derived-store model.

## Folder structure guidance

Within a repo (project boundary):

- Platform root: `_kano/backlog/`
- Product roots: `_kano/backlog/products/<product_name>/`
  - Items: `_kano/backlog/products/<product_name>/items/`
  - Views: `_kano/backlog/products/<product_name>/views/`
  - Artifacts: `_kano/backlog/products/<product_name>/artifacts/`

Platform-level aggregation:

- Aggregated dashboards live at `_kano/backlog/views/`.
- Product-specific dashboards live at `_kano/backlog/products/<product_name>/views/`.

## Implications for scripts and config

Impacted scripts / concepts:

- Product root discovery and resolution:
  - `context.resolve_product_name`, `get_product_root`, `find_platform_root`
- View generation and refresh:
  - `view_generate.py`: `--product`, `--products`, `--all-products`
  - `view_refresh_dashboards.py`: same scoping rules + output routing
- Config loading:
  - `load_config_with_defaults(..., product_name=...)` should remain the canonical way to load product-specific settings.

Potential follow-up engineering work:

- Ensure all documentation consistently uses this model (Project vs Product terms).
- Ensure any future server/API layer enforces:
  - allowed-roots sandbox at the platform root and/or per product root
  - product-level ACL in authenticated mode (future)

## Examples

Example A (1->1)

- Project: "Backlog Skill Demo"
- Product: "kano-agent-backlog-skill"

Example B (1->N)

- Project: "Kano Platform"
- Products: "billing", "identity", "search"
- Each product has its own root under `_kano/backlog/products/`.

Example C (cross-repo)

- Project: "Kano Platform"
- Repo 1 has products: "billing", "identity"
- Repo 2 has products: "search"
- Cloud mode later coordinates derived state across repos while canonical files remain local.
