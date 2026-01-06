---
id: KABSD-FTR-0010
uid: 019b93ba-9346-727c-b5a7-904ee79191f9
type: Feature
title: Monorepo Platform Migration
state: New
priority: P1
parent: null
area: architecture
iteration: null
tags:
- architecture
- migration
created: 2026-01-06
updated: 2026-01-06
owner: antigravity
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

The current repository is built around a single backlog root (`_kano/backlog`). We want to support multiple independent products/skills (e.g., `kano-agent-backlog-skill`, `kano-commit-convention-skill`) within the same "monorepo", while keeping their backlogs and configurations isolated.

# Goal

Refactor the architecture to a "Platform + Multi-Product" model.

- **Platform Root**: `_kano/backlog`
- **Product Roots**: `_kano/backlog/products/<product_name>`
- **Sandboxes**: `_kano/backlog/sandboxes/<product_name>`

# Approach

1.  **Directory Restructuring**:
    -   Move existing backlog data to `products/kano-agent-backlog-skill`.
    -   Create `products/kano-commit-convention-skill`.
    -   Establish `_shared/defaults.json`.

2.  **Script Updates**:
    -   Update CLI tools to accept `--product <name>`.
    -   Update config loader to resolve `config.json` relative to the product root.
    -   Update Indexer and Resolver to be product-aware.

3.  **Cross-Product Dependencies**:
    -   Maintain strict isolation for `skill.md` definitions.
    -   Allow specific configuration overrides (e.g., referencing a shared or external process definition).

# Plan

Refer to the detailed [Implementation Plan](file:///C:/Users/User/.gemini/antigravity/brain/332d83d9-f303-437a-885c-b7a4852305e9/implementation_plan.md) for the step-by-step migration strategy.

# Acceptance Criteria

- [ ] Directory structure follows the `products/` and `sandboxes/` layout.
- [ ] Existing `kano-agent-backlog-skill` operates correctly in its new location.
- [ ] New `kano-commit-convention-skill` can be initialized and managed independently.
- [ ] CLI commands fail gracefully or use defaults if no product is specified.
- [ ] No data leakage between products in the index/search.
