---
area: general
created: '2026-01-30'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KO-TSK-0002
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: kiro
parent: null
priority: P2
state: Done
tags: []
title: Add gitignore template to backlog initialization
type: Task
uid: 019c0c03-883f-7092-9c13-08039b09d527
updated: 2026-01-30
---

# Context

Currently when initializing a backlog with 'kano-backlog admin init', the system creates the directory structure but doesn't update the project's .gitignore file to exclude derived/cache data. Users have to manually add gitignore rules after initialization.

# Goal

Automatically update .gitignore during backlog initialization to exclude derived data like .cache/, _index/, materials/, etc.

# Approach

1. Create a gitignore template in the skill references/ directory 2. Modify the admin init command to detect existing .gitignore and append/merge backlog-specific rules 3. Provide clear documentation about what gets ignored and why

# Acceptance Criteria

1. New projects get proper gitignore rules automatically 2. Existing .gitignore files are preserved and extended 3. Template includes all necessary backlog-related exclusions 4. Documentation explains the gitignore strategy

# Risks / Dependencies

Risk of overwriting existing gitignore rules - need careful merge strategy

# Worklog

2026-01-30 07:08 [agent=kiro] Created item
2026-01-30 07:09 [agent=kiro] Created gitignore template and documentation [Ready gate validated]
2026-01-30 07:09 [agent=kiro] Completed: Created gitignore-template.txt and gitignore.md in skill references. Updated kano-opencode-quickstart .gitignore with proper exclusion rules.