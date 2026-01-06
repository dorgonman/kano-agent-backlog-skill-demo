---
id: KABSD-TSK-0085
uid: 019b93bb-60bf-7e6d-b5a7-904ee79191f9
type: Task
title: Initialize kano-commit-convention-skill and verify
state: New
priority: P1
parent: KABSD-FTR-0010
area: demo
iteration: null
tags:
- demo
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
  - KABSD-TSK-0083
decisions: []
---

# Context

This is the final verification step for the migration using the new intended product.

# Goal

1.  Run `bootstrap_init_backlog.py --product kano-commit-convention-skill`.
2.  Configure its `process.path` to `skills/kano-agent-backlog-skill/references/processes/jira-default.json`.
3.  Set its prefix to `KCCS`.
4.  Create a sample item in KCCS and verify it doesn't appear in KABSD.

# Acceptance Criteria

- KCCS initialized and configured correctly.
- Isolation verified.
