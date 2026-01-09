---
id: KABSD-TSK-0090
uid: 019b9473-766e-7bbb-9a17-0fd09783fe7f
type: Task
title: "Complete CLI scripts product_name parameter passing"
state: Proposed
priority: P2
parent: KABSD-FTR-0010
area: refactoring
iteration: 0.0.2
tags: ["cli", "product", "refactoring"]
created: 2026-01-07
updated: 2026-01-07
owner: null
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

Existing CLI scripts need to support multi-product parameter passing (`--product`) to ensure they operate in the correct context within the monorepo.

# Goal

Complete the implementation of `--product` argument support across all critical CLI scripts.

# Approach

1.  Identify scripts missing `--product` support.
2.  Update `argparse` configuration in each script.
3.  Ensure paths are resolved via `context.py` using the provided product name.
4.  Verify functionality with multiple products.

# Acceptance Criteria

- [ ] All top-level CLI scripts in `scripts/backlog/` support `--product`.
- [ ] Scripts correctly identify the product's items and config directories.
- [ ] Default product from `defaults.json` is used when no flag is provided.

2026-01-07 01:55 [agent=copilot] Created from template.
