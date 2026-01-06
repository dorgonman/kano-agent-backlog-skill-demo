---
id: KABSD-TSK-0082
uid: 019b93bb-2a8e-7e6d-b5a7-904ee79191f9
type: Task
title: Update config_loader.py for multi-product roots
state: New
priority: P1
parent: KABSD-FTR-0010
area: architecture
iteration: null
tags:
- architecture
created: 2026-01-06
updated: 2026-01-06
owner: antigravity
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks:
  - KABSD-TSK-0083
  blocked_by:
  - KABSD-TSK-0079
decisions: []
---

# Context

`config_loader.py` currently looks for `_kano/backlog/_config/config.json`. It needs to find config relative to the resolved product root.

# Goal

Update `load_config` and `resolve_config_path` to:
- Take an optional `product_name`.
- Use `context.py` to find the correct `_config` folder.

# Acceptance Criteria

- `load_config(product_name="kano-agent-backlog-skill")` loads from the new product root.
- Legacy paths handled gracefully during migration if possible.
