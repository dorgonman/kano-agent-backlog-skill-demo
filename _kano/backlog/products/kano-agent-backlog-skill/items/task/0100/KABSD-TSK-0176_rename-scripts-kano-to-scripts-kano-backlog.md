---
area: cli
created: '2026-01-12'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0176
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0034
priority: P2
state: Done
tags:
- refactor
title: Rename scripts/kano to scripts/kano-backlog
type: Task
uid: 019bae58-dcf1-7157-899a-de09e6996d85
updated: 2026-01-12
---

# Context

Current CLI script is scripts/kano; needs to be skill-scoped to avoid namespace collision with future umbrella CLI.

# Goal

Rename scripts/kano to scripts/kano-backlog and update shebang/permissions.

# Approach

Move file with git mv to preserve history; update any hardcoded path references in tests/docs.

# Acceptance Criteria

scripts/kano-backlog exists with correct shebang and execute permission; scripts/kano does not exist (will be recreated as deprecated wrapper in TSK-0179).

# Risks / Dependencies

None if done before pyproject.toml update; git history preserved via mv.

# Worklog

2026-01-12 02:36 [agent=copilot] Created item
2026-01-12 03:19 [agent=copilot] Started: renaming scripts/kano to scripts/kano-backlog.
2026-01-12 03:22 [agent=copilot] Completed: renamed scripts/kano to scripts/kano-backlog; updated all documentation references (SKILL.md, templates, doctor.py).
