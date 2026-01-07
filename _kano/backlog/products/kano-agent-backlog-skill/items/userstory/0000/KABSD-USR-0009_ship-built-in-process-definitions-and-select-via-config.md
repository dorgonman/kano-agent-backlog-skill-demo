---
id: KABSD-USR-0009
uid: 019b8f52-9f3e-783d-a12f-197dffb71908
type: UserStory
title: Ship built-in process definitions and select via config
state: Done
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

Users should be able to pick a known process profile (e.g., Azure Boards Agile)
without defining everything from scratch.

# Goal

As a maintainer, I want built-in process definitions and a config selector so
teams can adopt a profile quickly.

# Non-Goals

- Shipping every possible PM workflow variant.
- Auto-syncing with external tools.

# Approach

- Store built-in process definitions in the skill repo (references or assets).
- Add a config field that selects a built-in profile or a custom path.
- Document the available built-ins.

# Links

- Feature: [[KABSD-FTR-0004_backlog-config-system-and-process-profiles|KABSD-FTR-0004 Backlog config system and process profiles]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0023_ship-built-in-process-definition-files|KABSD-TSK-0023 Ship built-in process definition files]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0024_add-config-selector-for-process-profile|KABSD-TSK-0024 Add config selector for process profile]]

# Alternatives

- Require users to author custom profiles only.

# Acceptance Criteria

- Built-in profiles are available in the repo.
- Config can select a built-in profile or a custom path.

# Risks / Dependencies

- Built-in profiles may require updates as workflows evolve.

# Worklog

2026-01-04 18:18 [agent=codex] Created story for built-in process definitions selection.
2026-01-04 18:36 [agent=codex] Added scope, approach, and linked tasks for built-in profiles.
2026-01-05 02:06 [agent=codex] Auto-sync from child KABSD-TSK-0042 -> Planned.
2026-01-05 02:07 [agent=codex] Auto-sync from child KABSD-TSK-0042 -> InProgress.
2026-01-05 02:07 [agent=codex] Auto-sync from child KABSD-TSK-0042 -> Done.
