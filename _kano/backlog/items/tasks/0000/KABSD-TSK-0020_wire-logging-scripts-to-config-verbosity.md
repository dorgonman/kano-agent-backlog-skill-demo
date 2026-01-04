---
id: KABSD-TSK-0020
type: Task
title: "Wire logging scripts to config verbosity"
state: Proposed
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

Once config keys exist, logging scripts should consume them by default.

# Goal

Read log verbosity/debug settings from config in the logging scripts.

# Non-Goals

- Removing env overrides.

# Approach

- Use the shared config loader in audit/logging scripts.
- Define precedence: env overrides > config defaults.

# Alternatives

- Keep logging controlled only by env vars.

# Acceptance Criteria

- Logging scripts read config when env overrides are not set.
- Debug/verbosity settings do not expose secrets.

# Risks / Dependencies

- Loader dependencies must be available to logging scripts.

# Worklog

2026-01-04 18:23 [agent=codex] Created task to wire logging scripts to config verbosity settings.
2026-01-04 18:40 [agent=codex] Added scope and acceptance criteria for logging config wiring.
