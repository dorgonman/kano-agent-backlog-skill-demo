---
id: KABSD-USR-0006
uid: 019b8f52-9f38-76ed-a6a2-6260eeb06ff6
type: UserStory
title: Create backlog config root under _kano/backlog
state: Proposed
priority: P2
parent: KABSD-FTR-0004
area: infra
iteration: null
tags:
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

We need a stable config root under `_kano/backlog/` to store system settings
without touching code or external services.

# Goal

As a maintainer, I want a config root under `_kano/backlog/` so the backlog
system can load settings from a predictable location.

# Non-Goals

- Deciding the full schema for every future setting.
- External config services or remote storage.

# Approach

- Define a `_kano/backlog/_config/` (or equivalent) folder.
- Add a baseline config file with minimal settings and comments.
- Add a shared loader utility so scripts can read config consistently.

# Links

- Feature: [[KABSD-FTR-0004_backlog-config-system-and-process-profiles|KABSD-FTR-0004 Backlog config system and process profiles]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0017_define-config-root-layout-and-baseline-config-file|KABSD-TSK-0017 Define config root layout and baseline config file]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0018_add-config-loader-for-skill-scripts|KABSD-TSK-0018 Add config loader for skill scripts]]

# Alternatives

- Hardcode defaults in scripts and rely on env vars only.

# Acceptance Criteria

- Config root exists under `_kano/backlog/`.
- Baseline config file is present and documented.
- A shared loader reads config for other scripts to use.

# Risks / Dependencies

- Config format choice may need migration later.

# Worklog

2026-01-04 18:18 [agent=codex] Created story for backlog config root under _kano/backlog.
2026-01-04 18:36 [agent=codex] Added scope, approach, and linked tasks for config root.
