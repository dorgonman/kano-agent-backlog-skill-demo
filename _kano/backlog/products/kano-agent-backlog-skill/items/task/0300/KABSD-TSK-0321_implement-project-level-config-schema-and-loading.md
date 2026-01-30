---
area: general
created: '2026-01-30'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0321
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: kiro
parent: KABSD-FTR-0063
priority: P2
state: Done
tags: []
title: Implement project-level config schema and loading
type: Task
uid: 019c0c0a-bd9c-7628-8496-2d345080106e
updated: 2026-01-30
---

# Context

Need to implement project-level config schema to support .kano/backlog_config.toml format that can define multiple products and their backlog root locations.

# Goal

Create data structures and loading logic for the new project-level backlog configuration format.

# Approach

1. Define ProjectConfig and ProductDefinition dataclasses 2. Implement load_project_config() function 3. Add TOML parsing with proper error handling 4. Support relative/absolute path resolution for backlog_root 5. Add validation for required fields

# Acceptance Criteria

1. Can parse .kano/backlog_config.toml files 2. Supports [products.<name>] sections 3. Validates required fields (name, prefix, backlog_root) 4. Handles path resolution correctly 5. Provides clear error messages for invalid configs

# Risks / Dependencies

TOML parsing errors could crash CLI. Need robust error handling.

# Worklog

2026-01-30 07:15 [agent=kiro] Created item [Parent Ready gate validated]
2026-01-30 07:31 [agent=kiro] Updated config file name to .kano/backlog_config.toml for better clarity. Updated all documentation and examples. [Ready gate validated]
2026-01-30 07:31 [agent=kiro] Completed config file naming update. All references changed to .kano/backlog_config.toml. Created actual config file and updated gitignore template.
