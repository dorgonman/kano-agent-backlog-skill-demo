---
area: tooling
created: 2026-01-09
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0222
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
title: Implement `kano item create` subcommand
type: Task
uid: 019bac4a-6840-7074-91d2-e59c4a8cd392
updated: 2026-01-09
---

# Context

Wrap `workitem_create.py` logic into the unified `kano` CLI.

# Goal

- Add `item create` subcommand to `kano` CLI.
- Supporting arguments: `--type`, `--title`, `--parent`, `--priority`, `--tags`, `--product`.
- Ensure consistent output and error handling.

# Worklog

2026-01-16 11:42 [agent=codex] [model=GPT-5.2-Codex] Remapped ID: KABSD-TSK-0222 -> KABSD-TSK-0218.
2026-01-16 13:34 [agent=codex] [model=unknown] Remapped ID: KABSD-TSK-0132 -> KABSD-TSK-0222.
