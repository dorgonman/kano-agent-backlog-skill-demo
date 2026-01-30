---
area: general
created: '2026-01-30'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KO-FTR-0001
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Proposed
tags: []
title: Auto-update gitignore during backlog initialization
type: Feature
uid: 019c0c04-c9b0-737b-bf47-4b010cda265c
updated: '2026-01-30'
---

# Context

Users currently need to manually update .gitignore after running 'kano-backlog admin init'. This creates friction and risk of committing derived data.

# Goal

Modify the admin init command to automatically update .gitignore with backlog-specific exclusion rules

# Approach

1. Modify kano_backlog_cli/commands/admin.py init command 2. Add gitignore update logic that reads template and merges with existing file 3. Use section markers to enable future updates 4. Add --no-gitignore flag for users who want to skip this

# Acceptance Criteria

1. 'admin init' automatically updates .gitignore 2. Existing rules are preserved 3. Template rules are added in marked section 4. Option to skip gitignore update 5. Works on both new and existing .gitignore files

# Risks / Dependencies

Risk of corrupting existing .gitignore files - need robust merge logic and backup strategy

# Worklog

2026-01-30 07:09 [agent=kiro] Created item