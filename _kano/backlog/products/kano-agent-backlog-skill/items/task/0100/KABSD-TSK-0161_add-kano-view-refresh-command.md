---
id: KABSD-TSK-0161
uid: 019ba8b1-6e00-7ef8-8660-caa12ce9a0eb
type: Task
title: "Add kano view refresh command"
state: Done
priority: P1
parent: KABSD-FTR-0028
area: tooling
iteration: null
tags: ["cli", "phase1"]
created: 2026-01-11
updated: 2026-01-11
owner: copilot
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: [ADR-0013]
---

# Context

After modifying backlog items, dashboards must be refreshed. Currently agents call `view_refresh_dashboards.py`. This is a high-frequency operation that should be in the CLI.

# Goal

Add `kano view refresh` command that:
1. Regenerates all plain Markdown dashboards
2. Optionally regenerates persona-specific views
3. Reports which views were updated

# Non-Goals

- Dataview/Obsidian-specific views
- Custom view templates in this task

# Approach

1. Expand `src/kano_cli/commands/view.py`
2. Add `refresh` subcommand with options:
   - `--product TEXT`
   - `--agent TEXT` (required)
   - `--all-personas` (regenerate all persona views)
   - `--config PATH`
3. Delegate to `view_refresh_dashboards.py` logic

# Acceptance Criteria

- [ ] `kano view refresh --agent copilot` regenerates dashboards
- [ ] Output lists refreshed view files
- [ ] `--all-personas` triggers persona-specific views
- [ ] Views reflect current backlog state

# Risks / Dependencies

- View templates must exist

# Worklog

2026-01-11 00:16 [agent=copilot] Created from template.
2026-01-11 00:20 [agent=copilot] Populated task details.
2026-01-11 00:40 [agent=copilot] Command already implemented in src/kano_cli/commands/view.py as `refresh()`. Wraps view_refresh_dashboards.py with proper options. → Done
