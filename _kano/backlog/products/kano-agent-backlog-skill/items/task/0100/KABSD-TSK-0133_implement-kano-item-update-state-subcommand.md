---
id: KABSD-TSK-0133
uid: null
type: Task
title: "Implement `kano item update-state` subcommand"
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

Wrap `workitem_update_state.py` logic into the unified `kano` CLI.

# Goal

- Add `item update-state` subcommand to `kano` CLI.
- Supporting arguments: `--item`, `--state`, `--action`, `--message`, `--product`.
- Auto-refresh dashboards after state transition.
