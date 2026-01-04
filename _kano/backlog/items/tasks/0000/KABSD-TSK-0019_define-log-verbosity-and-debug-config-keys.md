---
id: KABSD-TSK-0019
type: Task
title: "Define log verbosity and debug config keys"
state: Done
priority: P2
parent: KABSD-USR-0007
area: infra
iteration: null
tags: ["config", "logging"]
created: 2026-01-04
updated: 2026-01-04
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

We need explicit config keys so logging behavior is controllable without code.

# Goal

Define the config fields for log verbosity and debug mode.

# Non-Goals

- Implementing runtime behavior changes (separate task).

# Approach

- Propose key names and allowed values (e.g., `log_verbosity`, `debug`).
- Document defaults and interaction with env overrides.

# Alternatives

- Keep using env vars only.

# Acceptance Criteria

- Config keys and default values are documented.
- Keys are added to the baseline config file.

# Risks / Dependencies

- Ambiguous precedence rules can confuse users.

# Worklog

2026-01-04 18:23 [agent=codex] Created task to define logging verbosity/debug config keys.
2026-01-04 18:40 [agent=codex] Added scope and acceptance criteria for logging config keys.
2026-01-04 20:07 [agent=codex] State -> InProgress.
2026-01-04 20:08 [agent=codex] Defined log verbosity/debug keys in baseline config and logging docs.
