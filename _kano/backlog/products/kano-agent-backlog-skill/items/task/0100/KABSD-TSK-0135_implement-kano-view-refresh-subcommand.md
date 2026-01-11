---
area: tooling
created: 2026-01-09
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0135
iteration: null
links:
  blocked_by: []
  blocks: []
  relates: []
owner: null
parent: KABSD-FTR-0025
priority: P1
state: Proposed
tags:
- cli
- implementation
title: Implement `kano view refresh` subcommand
type: Task
uid: 019bac4a-6842-71d4-8e39-7305a341440d
updated: 2026-01-09
---

# Context

Wrap `view_refresh_dashboards.py` logic into the unified `kano` CLI.

# Goal

- Add `view refresh` subcommand to `kano` CLI.
- Supporting arguments: `--product`, `--config`.
- Generate summary of refreshed views.