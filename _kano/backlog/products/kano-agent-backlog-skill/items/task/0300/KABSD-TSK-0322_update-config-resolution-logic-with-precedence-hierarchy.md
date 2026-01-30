---
area: general
created: '2026-01-30'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0322
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
title: Update config resolution logic with precedence hierarchy
type: Task
uid: 019c0c0a-da67-705f-ad92-be946f034f13
updated: 2026-01-30
---

# Context

Current config resolution only supports per-product configs. Need to implement project-level .kano/backlog_config.toml support with proper precedence hierarchy: CLI args > project config > product config > defaults.

# Goal

Update ConfigLoader class to support project-level configuration with the new precedence hierarchy.

# Approach

1. Add load_project_config() method to read .kano/backlog_config.toml 2. Update load_effective_config() to include project config layer 3. Modify from_path() to resolve backlog_root from project config 4. Add support for custom backlog_root paths 5. Update precedence order in config merging

# Acceptance Criteria

1. Can load .kano/backlog_config.toml files 2. Project config overrides product config 3. CLI args still have highest priority 4. Supports custom backlog_root paths 5. Backward compatible with existing configs 6. All tests pass

# Risks / Dependencies

Breaking changes to config resolution. Need careful testing with existing setups.

# Worklog

2026-01-30 07:16 [agent=kiro] Created item [Parent Ready gate validated]
2026-01-30 07:34 [agent=kiro] Starting implementation of project-level config support [Ready gate validated]
2026-01-30 07:39 [agent=kiro] Successfully implemented project-level config support. Added ProjectConfig classes, updated ConfigLoader with new precedence hierarchy, and integrated with CLI. All tests pass and external product management works correctly.
