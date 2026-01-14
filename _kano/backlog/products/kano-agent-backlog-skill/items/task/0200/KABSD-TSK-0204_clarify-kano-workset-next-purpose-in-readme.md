---
area: general
created: '2026-01-15'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0204
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
title: Clarify 'kano workset next' purpose in README
type: Task
uid: 019bbd6f-9a5f-74af-80ce-814741e2c6cf
updated: 2026-01-15
---

# Context

Users are unclear what kano workset next --item <id> does and when to use it; the root README currently only lists the command without explaining behavior or output.

# Goal

Make the purpose and expected behavior of kano workset next obvious to new users reading the root README.

# Approach

Update the Workset section in the root README to explain that workset next reads the workset's plan.md, finds the first unchecked checklist item, and prints it (or prints completion when all steps are checked). Add a short usage pattern showing how it supports an interactive loop (ask-next / mark-done / repeat) and mention the --format json option for automation.

# Acceptance Criteria

- Root README explains what kano workset next returns and what file it reads
- README includes a short example workflow for repeated use during a task
- Description matches current implementation (no implied state mutation)

# Risks / Dependencies

Doc drift if behavior changes; mitigate by aligning wording with get_next_action() semantics and keeping it narrowly scoped.

# Worklog

2026-01-15 00:56 [agent=copilot] Created item
2026-01-15 00:57 [agent=copilot] [model=gpt-5.2] Start updating root README to clarify workset next usage.
2026-01-15 00:57 [agent=copilot] [model=gpt-5.2] Updated root README Workset section to explain workset next behavior and usage pattern.
