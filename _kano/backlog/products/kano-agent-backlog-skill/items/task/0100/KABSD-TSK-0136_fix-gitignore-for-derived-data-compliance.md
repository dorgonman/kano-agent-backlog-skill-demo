---
id: KABSD-TSK-0136
uid: 019ba3b1-2b09-7eab-a167-37aea9994e7b
type: Task
title: "Fix gitignore for derived data compliance"
state: Done
priority: P2
parent: null
area: general
iteration: null
tags: []
created: 2026-01-10
updated: 2026-01-10
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

The SQLite index file `_kano/backlog/products/kano-agent-backlog-skill/_index/backlog.sqlite3` was incorrectly tracked in git, violating the backlog skill's rule that derived data should not be in version control.

# Goal

Remove derived data from git tracking and ensure .gitignore rules properly exclude all derived/cache files.

# Non-Goals

- Modifying the .gitignore rules (they are already correct)
- Removing the actual files from disk

# Approach

1. Use `git rm --cached` to remove SQLite file from tracking
2. Verify .gitignore rules cover all derived data patterns
3. Commit the fix

# Alternatives

- Could have used `git filter-branch` to remove from history, but not necessary for this case

# Acceptance Criteria

- [x] `backlog.sqlite3` removed from git tracking
- [x] All files in `_index/` directories are ignored by git
- [x] Only canonical markdown files are tracked

# Risks / Dependencies

- None, this is a cleanup task

# Worklog

2026-01-10 00:57 [agent=claude] Created from template.
2026-01-10 00:57 [agent=claude] Identified and removed backlog.sqlite3 from git tracking. Verified .gitignore rules are correct.
2026-01-10 01:04 [agent=claude] State -> Done.
