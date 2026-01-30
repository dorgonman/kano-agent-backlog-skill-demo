---
id: KABSD-TSK-0327
uid: 019c0ee1-569b-76be-b01a-30e69672f49e
type: Task
title: "Implement debug mode config and documentation system"
state: Done
priority: P2
parent: KABSD-FTR-0063
area: general
iteration: backlog
tags: []
created: 2026-01-30
updated: 2026-01-30
owner: None
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

The effective config system was moved from `_kano/backlog/products/<product>/.cache/` to `.kano/debug/` to better reflect its purpose as debug output. However, the system lacked proper documentation and gitignore handling for different project types (demo vs user projects).

# Goal

Implement a complete debug mode configuration system with proper documentation, gitignore rules, and maintenance guidelines for skill developers.

# Approach

1. Move effective config to `.kano/debug/backlog_config.toml` (project-level)
2. Only generate debug config when `log.debug = true` in config
3. Create README.md documentation for `.kano/debug/` directory
4. Update gitignore templates and rules for demo vs user projects
5. Create skill developer maintenance checklist
6. Update view refresh command to auto-resolve backlog root from config

# Acceptance Criteria

1. Debug config only generated when debug mode enabled
2. Debug config written to `.kano/debug/backlog_config.toml`
3. README.md exists in demo project's `.kano/debug/` explaining debug features
4. Gitignore template updated for user projects (ignore all `.kano/debug/`)
5. Demo project gitignore preserves README.md as example
6. Skill developer checklist created with maintenance guidelines
7. View refresh command works with external backlog architecture
8. Both nested (`log.debug`) and flat (`log.debug`) config formats supported

# Risks / Dependencies

- Gitignore rules must be carefully tested to avoid committing environment-specific files
- Demo project needs different gitignore rules than user projects
- View refresh command must handle both old and new backlog structures

# Worklog

2026-01-30 20:29 [agent=kiro] Created item [Parent Ready gate validated]
2026-01-30 20:35 [agent=kiro] Completed implementation:
- Created `.kano/debug/README.md` for both demo and quickstart projects
- Updated `config_cmd.py` to write debug config to `.kano/debug/backlog_config.toml`
- Updated `view.py` to check both nested and flat debug config formats
- Updated `view.py` to auto-resolve backlog root from project config
- Fixed external backlog architecture support (quickstart → skill-demo)
- Updated `gitignore-template.txt` for user projects (ignore all `.kano/debug/`)
- Updated demo project `.gitignore` to preserve README.md as example
- Created `skill-developer-checklist.md` with maintenance guidelines
- Tested debug mode on/off in both projects
- Verified gitignore rules work correctly
2026-01-30 20:30 [agent=kiro] State -> Done.
