---
id: KABSD-TSK-0018
uid: 019b8f52-9f76-75bf-b10e-1925a20a308e
type: Task
title: Add config loader for skill scripts
state: Done
priority: P2
parent: KABSD-USR-0006
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

Multiple scripts will need consistent config loading instead of custom parsing.

# Goal

Provide a shared config loader utility that other scripts can use.

# Non-Goals

- Complex schema validation or migration logic.

# Approach

- Implement a small loader module in `scripts/backlog/` or `scripts/logging/`.
- Support a default config path under `_kano/backlog/`.
- Return defaults when config is missing.

# Alternatives

- Each script reads config independently.

# Acceptance Criteria

- Loader returns parsed config from the default path.
- Scripts can import and use the loader without duplication.

# Risks / Dependencies

- Config format choice will affect loader implementation.

# Worklog

2026-01-04 18:23 [agent=codex] Created task to add a config loader utility for skill scripts.
2026-01-04 18:40 [agent=codex] Added scope and acceptance criteria for config loader.
2026-01-04 20:05 [agent=codex] State -> InProgress.
2026-01-04 20:07 [agent=codex] Added shared config loader module.
2026-01-04 20:08 [agent=codex] Added shared config loader module and wiring for logging.
