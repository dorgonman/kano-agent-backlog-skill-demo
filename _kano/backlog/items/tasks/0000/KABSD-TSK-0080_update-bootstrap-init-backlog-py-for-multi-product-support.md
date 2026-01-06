---
id: KABSD-TSK-0080
uid: 019b93bb-064e-76e3-ac7c-b5a7904ee791
type: Task
title: Update bootstrap_init_backlog.py for multi-product support
state: New
priority: P1
parent: KABSD-FTR-0010
area: architecture
iteration: null
tags:
- architecture
- bootstrap
created: 2026-01-06
updated: 2026-01-06
owner: antigravity
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks:
  - KABSD-TSK-0085
  blocked_by:
  - KABSD-TSK-0079
decisions: []
---

# Context

The current bootstrap script assumes a single `_kano/backlog` root. It needs to support creating backlogs under `products/<name>`.

# Goal

Update `bootstrap_init_backlog.py` to:
- Use `context.py` to resolve the target directory.
- Accept `--product` and `--sandbox` flags.
- Default to the product name for `config.json` baseline.

# Acceptance Criteria

- `python .../bootstrap_init_backlog.py --product test-skill` creates `_kano/backlog/products/test-skill/`.
- Correctly initializes `config.json` with the product name.
