---
id: KABSD-TSK-0129
uid: 019bac45-bf54-75a1-a87c-228b2d7ccb94
type: Task
title: "Clarify Project vs Product terminology and boundaries (cloud / cross-repo)"
state: New
priority: P1
parent: KABSD-EPIC-0006
area: architecture
iteration: null
tags: ["terminology", "multi-product", "multi-repo", "cloud", "platform"]
created: 2026-01-08
updated: 2026-01-08
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: ["KABSD-EPIC-0005"]
  blocks: []
  blocked_by: []
decisions: []
---

# Context

In the cloud deployment scenario, we can gain cross-repo and cross-project experience. However, each project may define multiple products, and the current wording in the backlog and scripts can blur the boundary between "Project" and "Product".

We need a shared, explicit terminology model so that:

1. Documentation, configuration, and scripts use consistent terms.
2. Multi-product dashboards and indexing behave predictably.
3. Future cross-repo / cross-project work (EPIC-0005 / EPIC-0006) can align on the same conceptual model.

# Goal

Define a clear, actionable interpretation of "Project" vs "Product" for this ecosystem, including:

1. A concise definition of each term.
2. The expected mapping patterns (e.g. 1 project -> N products, 1 project -> 1 product).
3. Implications for repo structure, config resolution, and future cloud cross-repo usage.

# Approach

1. Gather 2-3 representative real-world scenarios:
   - One project that produces a single sellable product.
   - One project that contains multiple services that are each sellable as separate products.
   - One platform project that only hosts shared governance/indexing/dashboards.
2. Propose a terminology model:
   - Project: organizational / delivery boundary (may span repos).
   - Product: backlog/config boundary for items and views within a project.
3. Document the model in a short Markdown note (or update existing docs if present).
   - Note: [[../../artifacts/project-vs-product-terminology.md|Project vs Product terminology]]
4. Identify which scripts/config keys are impacted (if any) and list follow-up Tasks if changes are needed.

Impacted scripts/config keys (initial list):

- `context.resolve_product_name`, `get_product_root`, `find_platform_root`
- `load_config_with_defaults(..., product_name=...)`
- `view_generate.py` CLI scoping: `--product`, `--products`, `--all-products`
- `view_refresh_dashboards.py` scoping + output routing rules

Potential follow-up engineering Tasks:

- Documentation pass: ensure "Project" vs "Product" terms are consistent across READMEs/examples.
- If/when a server/API layer exists: enforce allowed-roots sandbox at platform/product roots.
- If/when auth is implemented: add product-level ACL and scopes aligned with this model.

# Acceptance Criteria

- [ ] Written definitions for "Project" and "Product" with concrete examples.
- [ ] Documented allowed mappings: 1->1, 1->N, and when to prefer each.
- [ ] Explicit guidance on how products are represented in folder structure (within a project) and how this scales to cross-repo.
- [ ] A short list of follow-up engineering tasks (if terminology implies changes to scripts/config/docs).

# Risks / Dependencies

- Risk of scope creep into an ADR or large architecture refactor.
- Terminology decision may require updates to:
  - config loader defaults
  - dashboard generation CLI
  - documentation and examples
- Depends on stakeholders agreeing on the semantics for cloud deployment and cross-repo usage.

# Worklog

2026-01-08 10:26 [agent=windsurf] Created to clarify terminology before continuing EPIC-0005/0006 cloud cross-repo planning.
2026-01-08 13:27 [agent=windsurf] User decision: Q1 mapping preference = Option A. Related note: diagrams should be stored under a shared artifacts area for cross-item reuse; ensure terminology guidance stays consistent with these artifacts.
2026-01-08 16:52 [agent=windsurf] Added a short terminology note under product artifacts and linked it here; captured impacted scripts/config keys and follow-up engineering tasks.
