---
id: KABSD-TSK-0021
uid: 019b8f52-9f7c-72fb-a59c-3383c588edf2
type: Task
title: Design process profile schema
state: Done
priority: P3
parent: KABSD-USR-0008
area: process
iteration: null
tags:
- process
- config
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

We need a schema that can represent work item types and transitions for
different process models.

# Goal

Define a process profile schema suitable for agent-oriented backlogs.

# Non-Goals

- Full compatibility with every external board system.

# Approach

- Specify fields for work item types, allowed states, and transitions.
- Include optional metadata (e.g., default state, terminal states).

# Alternatives

- Keep process rules undocumented and implicit.

# Acceptance Criteria

- Schema draft covers item types and transitions.
- Example structure is included for review.

# Risks / Dependencies

- Overly rigid schema may not fit agent workflows.

# Worklog

2026-01-04 18:23 [agent=codex] Created task to design process profile schema.
2026-01-04 18:40 [agent=codex] Added scope and acceptance criteria for process schema.
2026-01-04 20:11 [agent=codex] State -> InProgress.
2026-01-04 20:11 [agent=codex] Documented process profile schema in references/processes.md.
