---
id: KABSD-TSK-0013
uid: 019b8f52-9f6c-75c0-930c-0de2f20f6587
type: Task
title: Integrate audit logging into skill scripts
state: Done
priority: P2
parent: KABSD-USR-0002
area: infra
iteration: null
tags:
- logging
- automation
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

The audit logger exists, but the backlog/fs scripts do not emit log entries yet.
We need to wire logging into the skill entrypoints so tool usage is captured.

# Goal

Log every invocation of backlog and filesystem scripts with redaction, status,
and duration.

# Non-Goals

- Logging external commands run outside the skill scripts.
- Centralized log shipping.

# Approach

- Add a shared audit wrapper helper in `scripts/logging/`.
- Call the helper from `scripts/backlog/*.py` and `scripts/fs/*.py` entrypoints.
- Keep logging failures non-fatal (do not block tool execution).

# Alternatives

- Only log from the demo `_kano/backlog/tools/` wrappers.

# Acceptance Criteria

- Each backlog/fs script emits an audit log entry on success and failure.
- Log entries include status, exit code, duration, and redacted args.
- Logging errors do not prevent the script from running.

# Risks / Dependencies

- Additional imports may affect script startup time slightly.

# Worklog

2026-01-04 14:01 [agent=codex] Created task for wiring audit logging into skill scripts.
2026-01-04 14:12 [agent=codex] Added scope and acceptance criteria for audit integration.
2026-01-04 14:02 [agent=codex] State -> InProgress.
2026-01-04 14:05 [agent=codex] Integrated audit logging into backlog/fs scripts via audit_runner.
