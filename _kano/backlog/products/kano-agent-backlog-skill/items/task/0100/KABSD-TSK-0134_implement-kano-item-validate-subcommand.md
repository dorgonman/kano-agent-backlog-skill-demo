---
id: KABSD-TSK-0134
uid: null
type: Task
title: "Implement `kano item validate` subcommand"
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

Wrap `workitem_validate_ready.py` logic into the unified `kano` CLI.

# Goal

- Add `item validate` subcommand to `kano` CLI.
- Supporting arguments: `--item`, `--product`, `--format`.
- Report Ready gate gaps.
