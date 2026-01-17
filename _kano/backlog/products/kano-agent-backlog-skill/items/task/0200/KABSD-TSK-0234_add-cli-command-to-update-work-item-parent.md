---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0234
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
title: Add CLI command to update work item parent
type: Task
uid: 019bc758-55b0-73c1-bd0c-355d9c12783f
updated: 2026-01-16
---

# Context

We need a CLI command to update work item parent links to align tasks/user stories/epics without manual edits.

# Goal

Add a kano-backlog command that updates parent in frontmatter and logs the change.

# Approach

- Implement an ops function to update parent field and append Worklog.
- Add admin items set-parent command with --parent/--clear support.
- Use the command to wire USR/TSK to the epic and story parents.

# Acceptance Criteria

- Command updates parent field and updated date, appends Worklog.
- Supports clearing parent.
- Emits a JSON option for scripting.

# Risks / Dependencies

- Incorrect parent references could break hierarchy; keep changes auditable in Worklog.

# Worklog

2026-01-16 23:06 [agent=codex] [model=unknown] Created item
2026-01-16 23:07 [agent=codex] [model=gpt-5.2-codex] Implement parent update command.
2026-01-16 23:09 [agent=codex] [model=gpt-5.2-codex] Implemented admin items set-parent command and used it to wire EPIC-0003 -> USR-0029/0030 -> tasks.
2026-01-16 23:09 [agent=codex] [model=gpt-5.2-codex] Set-parent CLI added and hierarchy updated.
