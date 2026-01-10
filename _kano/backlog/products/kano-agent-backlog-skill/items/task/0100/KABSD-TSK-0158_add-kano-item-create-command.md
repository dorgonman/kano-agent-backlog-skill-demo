---
id: KABSD-TSK-0158
uid: 019ba8b1-1c67-7672-a9c6-06973e770fe8
type: Task
title: "Add kano item create command"
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

Currently agents call `workitem_create.py` directly. This script has its own argument parsing and doesn't go through a central gate. We need to expose item creation through the unified CLI.

# Goal

Add `kano item create` command that:
1. Creates work items (epic, feature, userstory, task, bug)
2. Sets required frontmatter fields
3. Outputs the created item ID/path
4. Logs to audit trail

# Non-Goals

- Full template customization (use defaults for now)
- Bulk creation

# Approach

1. Expand `src/kano_cli/commands/item.py`
2. Add `create` subcommand with options:
   - `--type {epic,feature,userstory,task,bug}` (required)
   - `--title TEXT` (required)
   - `--parent ID` (optional)
   - `--priority {P0,P1,P2,P3}` (default: P2)
   - `--tags TEXT` (comma-separated)
   - `--product TEXT` (default from config)
3. Initially delegate to existing `workitem_create.py` logic
4. Later migrate logic to `kano_backlog_ops.workitem.create()`

# Acceptance Criteria

- [ ] `kano item create --type task --title "Test task"` creates item
- [ ] Created item has correct frontmatter (id, uid, type, title, state)
- [ ] `--parent` links correctly in frontmatter
- [ ] Output shows created item ID and path
- [ ] Audit log entry written

# Risks / Dependencies

- Depends on existing `workitem_create.py` logic initially

# Worklog

2026-01-11 00:15 [agent=copilot] Created from template.
2026-01-11 00:20 [agent=copilot] Populated task details.
2026-01-11 00:40 [agent=copilot] Command already implemented in src/kano_cli/commands/item.py as `create()`. Verified it wraps workitem_create.py logic and supports all required options. → Done
