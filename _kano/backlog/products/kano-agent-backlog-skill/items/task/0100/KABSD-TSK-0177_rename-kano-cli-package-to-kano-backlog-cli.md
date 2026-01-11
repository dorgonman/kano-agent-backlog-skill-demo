---
area: cli
created: '2026-01-12'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0177
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
title: Rename kano_cli package to kano_backlog_cli
type: Task
uid: 019bae58-f006-731e-b97d-a6a2e839c745
updated: 2026-01-12
---

# Context

Python package is src/kano_cli; collides with umbrella CLI naming; needs skill-scoped name.

# Goal

Rename src/kano_cli to src/kano_backlog_cli and update all import statements across the codebase.

# Approach

Use git mv for package directory; run grep search for 'kano_cli' and 'from kano_cli' to find all import/reference sites; update each file.

# Acceptance Criteria

src/kano_backlog_cli/ exists; src/kano_cli/ removed; all imports updated; no references to old package name remain; tests/linters pass.

# Risks / Dependencies

Large refactor touching many files; mitigated by comprehensive search and systematic replacement.

# Worklog

2026-01-12 02:37 [agent=copilot] Created item
2026-01-12 03:24 [agent=copilot] Completed: renamed src/kano_cli to src/kano_backlog_cli; updated all imports in source code, tests, and documentation.
