---
id: KABSD-TSK-0135
uid: null
type: Task
title: "Implement `kano view refresh` subcommand"
state: Proposed
priority: P1
parent: KABSD-FTR-0025
area: tooling
iteration: null
tags: ["cli", "implementation"]
created: 2026-01-09
updated: 2026-01-09
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

Wrap `view_refresh_dashboards.py` logic into the unified `kano` CLI.

# Goal

- Add `view refresh` subcommand to `kano` CLI.
- Supporting arguments: `--product`, `--config`.
- Generate summary of refreshed views.
