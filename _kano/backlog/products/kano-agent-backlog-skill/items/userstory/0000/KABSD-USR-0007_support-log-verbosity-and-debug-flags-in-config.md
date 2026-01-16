---
id: KABSD-USR-0007
uid: 019b8f52-9f3a-70c5-909a-5cc44939b75a
type: UserStory
title: Support log verbosity and debug flags in config
state: Proposed
priority: P2
parent: KABSD-FTR-0004
area: infra
iteration: null
tags:
- config
- logging
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

Audit logging is always on, but we need a config-driven verbosity/debug switch
to help troubleshooting without code edits.

# Goal

As a maintainer, I want log verbosity and debug flags in config so we can
increase detail only when needed.

# Non-Goals

- Replacing environment overrides entirely.
- Logging sensitive data in debug mode.

# Approach

- Add config keys for `log_verbosity` and `debug`.
- Define precedence between config and env overrides.
- Wire logging scripts to respect the config defaults.

# Links

- Feature: [[KABSD-FTR-0004_backlog-config-system-and-process-profiles|KABSD-FTR-0004 Backlog config system and process profiles]]
- Task: [[../../task/0000/KABSD-TSK-0019_define-log-verbosity-and-debug-config-keys|KABSD-TSK-0019 Define log verbosity and debug config keys]]
- Task: [[../../task/0000/KABSD-TSK-0020_wire-logging-scripts-to-config-verbosity|KABSD-TSK-0020 Wire logging scripts to config verbosity]]

# Alternatives

- Keep verbosity controlled by env vars only.

# Acceptance Criteria

- Config supports log verbosity and debug flags.
- Logging scripts read config values by default.
- Debug mode does not log secrets.

# Risks / Dependencies

- Confusion if config/env precedence is unclear.

# Worklog

2026-01-04 18:18 [agent=codex] Created story for log verbosity and debug flags.
2026-01-04 18:36 [agent=codex] Added scope, approach, and linked tasks for log verbosity config.
