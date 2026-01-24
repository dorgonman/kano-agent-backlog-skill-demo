---
area: general
created: '2026-01-20'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0297
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: null
priority: P2
state: Done
tags: []
title: 'Gitignore: ignore product _trash directories'
type: Task
uid: 019bd769-530b-7365-942d-89c3037cc42a
updated: 2026-01-20
---

# Context

Product backlogs create per-product _trash folders (e.g., _kano/backlog/products/<product>/_trash/...). These are disposable and should not be versioned, but current .gitignore only ignores _kano/backlog/_trash/ at the root.

# Goal

Ensure all per-product _trash directories under _kano/backlog/ are ignored by git.

# Approach

Add a glob rule to .gitignore to ignore any _trash directory under _kano/backlog/**/. Validate via git status and confirm existing tracked files are unaffected.

# Acceptance Criteria

1) .gitignore contains an ignore rule that matches _kano/backlog/products/**/_trash/ (and other nested _trash under _kano/backlog). 2) git status does not show new/untracked files under those _trash directories.

# Risks / Dependencies

Risk: overly broad ignore could hide intended files if _trash is used for non-disposable content; mitigated by naming convention (trash is always disposable).

# Worklog

2026-01-20 01:59 [agent=codex] [model=unknown] Created item
2026-01-20 02:00 [agent=codex] [model=unknown] Start: add gitignore rule for per-product _trash directories.
2026-01-20 02:20 [agent=codex] [model=gpt-5.2] Done: ignore per-product _trash directories via .gitignore.
