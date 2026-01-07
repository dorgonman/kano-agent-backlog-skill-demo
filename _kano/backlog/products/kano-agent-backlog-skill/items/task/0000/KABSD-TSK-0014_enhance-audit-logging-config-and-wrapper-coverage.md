---
id: KABSD-TSK-0014
uid: 019b8f52-9f6e-7ae1-a6d3-b9233dd123cd
type: Task
title: Enhance audit logging config and wrapper coverage
state: Done
priority: P2
parent: KABSD-USR-0002
area: infra
iteration: null
tags:
- logging
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

Audit logging is in place, but the demo tool wrappers still bypass the skill
entrypoints and logging is not configurable without code changes.

# Goal

Add configuration via environment variables and ensure demo tool wrappers
delegate to the skill scripts so all tool runs are logged.

# Non-Goals

- Changing the log schema beyond config metadata.
- Adding centralized log shipping.

# Approach

- Add env overrides for log root/file and rotation limits in `audit_runner.py`.
- Support a disable toggle for logging.
- Convert `_kano/backlog/tools/*.py` (generate_view/update_state/trash_item) to wrappers
  that call the skill scripts.
- Document the env variables in `references/logging.md`.

# Alternatives

- Keep per-repo custom logging logic in `_kano/backlog/tools`.

# Acceptance Criteria

- Logging can be disabled or redirected via env vars without code changes.
- Demo tool wrappers route to skill scripts so audit logs are emitted.
- Documentation lists the supported env vars.

# Risks / Dependencies

- Misconfigured env vars could hide expected logs.

# Worklog

2026-01-04 14:09 [agent=codex] Created task to enhance audit logging configuration and wrapper coverage.
2026-01-04 14:22 [agent=codex] Added scope, approach, and acceptance criteria for log config and wrappers.
2026-01-04 14:10 [agent=codex] State -> InProgress.
2026-01-04 14:14 [agent=codex] Added env-configurable logging and routed demo tools to skill scripts for audit coverage.
