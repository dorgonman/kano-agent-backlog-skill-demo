---
area: tooling
created: 2026-01-09
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0134
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
title: Implement `kano item validate` subcommand
type: Task
uid: 019bac4a-6841-707f-aca6-a9629145eecf
updated: 2026-01-09
---

# Context

Wrap `workitem_validate_ready.py` logic into the unified `kano` CLI.

# Goal

- Add `item validate` subcommand to `kano` CLI.
- Supporting arguments: `--item`, `--product`, `--format`.
- Report Ready gate gaps.