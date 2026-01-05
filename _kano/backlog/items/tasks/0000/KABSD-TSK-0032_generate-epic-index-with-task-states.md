---
id: KABSD-TSK-0032
uid: 019b8f52-9f94-7b88-86ad-cb23ea25bd80
type: Task
title: Generate epic index with task states
state: Done
priority: P2
parent: KABSD-FTR-0001
area: views
iteration: null
tags:
- moc
- index
created: 2026-01-04
updated: '2026-01-06'
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

Epic MOC files are manually maintained, so task status quickly goes stale. We need an automated index that includes task state labels.

# Goal

Generate Epic index files with a task list that includes each task's current state.

# Non-Goals

- Replacing Dataview dashboards.
- Introducing DataviewJS or external plugins.

# Approach

- Add a script that builds an Epic MOC tree from parent links.
- Annotate Task/Bug entries with their state.
- Update the target epic index file from the script.

# Alternatives

Manually edit MOC files after every state change.

# Acceptance Criteria

- Script generates an Epic .index.md with task state labels.
- Output stays under `_kano/backlog/` and uses only ASCII.

# Risks / Dependencies

- Parent links must be accurate, or items will not appear in the tree.

# Worklog

2026-01-04 23:40 [agent=codex] Created from template.
2026-01-04 23:40 [agent=codex] Filled Ready sections for epic index generator.
2026-01-04 23:40 [agent=codex] State -> Ready.
2026-01-04 23:40 [agent=codex] Implement epic index generator with task state labels.
2026-01-04 23:43 [agent=codex] Added epic index generator script and refreshed the demo epic index.
