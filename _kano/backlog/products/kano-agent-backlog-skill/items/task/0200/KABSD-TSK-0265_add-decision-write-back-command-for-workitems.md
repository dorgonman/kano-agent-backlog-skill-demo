---
area: general
created: '2026-01-19'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0265
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: copilot
parent: null
priority: P2
state: Done
tags: []
title: Add decision write-back command for workitems
type: Task
uid: 019bd471-d57f-74a9-9e06-da53b4563ea5
updated: 2026-01-19
---

# Context

We need a CLI workflow to write back decisions from topic synthesis into individual workitems for auditability.

# Goal

Provide a command that appends a decision entry to a workitem without manual file edits.

# Approach

Add an ops helper in kano_backlog_ops.workitem to insert a ## Decisions section (or append to it), update the updated date, and append a worklog entry. Expose a CLI command in kano_backlog_cli.commands.workitem.

# Acceptance Criteria

Running the command writes a decision bullet under ## Decisions and updates Worklog; no manual edits required.

# Risks / Dependencies

Incorrect section insertion could break Markdown structure; keep insertion before Worklog if present.

# Worklog

2026-01-19 12:09 [agent=copilot] [model=unknown] Created item
2026-01-19 12:10 [agent=copilot] [model=unknown] State -> InProgress.
2026-01-19 12:12 [agent=copilot] [model=unknown] State -> Done.
