---
id: KABSD-TSK-0081
uid: 019b93bb-187d-786d-b5a7-904ee79191f9
type: Task
title: Execute directory restructuring for monorepo platform
state: New
priority: P1
parent: KABSD-FTR-0010
area: architecture
iteration: null
tags:
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
  blocked_by:
  - KABSD-TSK-0080
decisions: []
---

# Context

To move to the platform model, we must move existing data into the `products/` namespace.

# Goal

1.  Move `_kano/backlog/items`, `decisions`, `views`, `_config`, `_meta` into `_kano/backlog/products/kano-agent-backlog-skill/`.
2.  Move current sandbox data into `_kano/backlog/sandboxes/kano-agent-backlog-skill/`.
3.  Ensure `_shared/defaults.json` exists.

# Acceptance Criteria

- `_kano/backlog/products/kano-agent-backlog-skill` contains the original backlog data.
- Scripts can still find this data (once updated).
