---
id: KABSD-TSK-0132
uid: null
type: Task
title: "Implement `kano item create` subcommand"
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

Wrap `workitem_create.py` logic into the unified `kano` CLI.

# Goal

- Add `item create` subcommand to `kano` CLI.
- Supporting arguments: `--type`, `--title`, `--parent`, `--priority`, `--tags`, `--product`.
- Ensure consistent output and error handling.
