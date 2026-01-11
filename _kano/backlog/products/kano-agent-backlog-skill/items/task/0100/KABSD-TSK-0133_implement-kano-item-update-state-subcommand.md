---
area: tooling
created: 2026-01-09
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0133
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
title: Implement `kano item update-state` subcommand
type: Task
uid: 019bac4a-6841-707f-aca6-a9610e2cbc92
updated: 2026-01-09
---

# Context

Wrap `workitem_update_state.py` logic into the unified `kano` CLI.

# Goal

- Add `item update-state` subcommand to `kano` CLI.
- Supporting arguments: `--item`, `--state`, `--action`, `--message`, `--product`.
- Auto-refresh dashboards after state transition.