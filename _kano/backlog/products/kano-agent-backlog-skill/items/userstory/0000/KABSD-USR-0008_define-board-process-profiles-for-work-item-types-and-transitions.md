---
id: KABSD-USR-0008
uid: 019b8f52-9f3c-7a46-a5c7-4f845eb97bf9
type: UserStory
title: Define board process profiles for work item types and transitions
state: Proposed
priority: P3
parent: KABSD-FTR-0004
area: process
iteration: null
tags:
- config
- process
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
original_type: UserStory
---

# Context

Different teams use different process models (Agile/Scrum/CMMI). We need a
configurable definition of work item types and state transitions.

# Goal

As a maintainer, I want a process profile schema so we can describe work item
types and transitions in a consistent, configurable way.

# Non-Goals

- Enforcing a human-only workflow without adaptation for agents.
- Full parity with Jira/Azure Boards workflows.

# Approach

- Define a schema for process profiles (types, states, transitions).
- Include a place to map default work item types per process.
- Leave room for agent-specific adjustments.

# Links

- Feature: [[KABSD-FTR-0004_backlog-config-system-and-process-profiles|KABSD-FTR-0004 Backlog config system and process profiles]]
- Task: [[../../task/0000/KABSD-TSK-0021_design-process-profile-schema|KABSD-TSK-0021 Design process profile schema]]
- Task: [[../../task/0000/KABSD-TSK-0022_draft-initial-process-profiles-agile-scrum-cmmi|KABSD-TSK-0022 Draft initial process profiles (Agile/Scrum/CMMI)]]

# Alternatives

- Keep a single hardcoded process in code.

# Acceptance Criteria

- Process profile schema is documented.
- Schema can represent work item types and valid transitions.

# Risks / Dependencies

- Process models may not map cleanly to agent workflows.

# Worklog

2026-01-04 18:18 [agent=codex] Created story for board process profiles.
2026-01-04 18:36 [agent=codex] Added scope, approach, and linked tasks for process profiles.
