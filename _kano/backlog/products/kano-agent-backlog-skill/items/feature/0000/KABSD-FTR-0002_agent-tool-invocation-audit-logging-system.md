---
id: KABSD-FTR-0002
uid: 019b8f52-9fde-7162-bd19-e9b8310526fc
type: Feature
title: Agent tool invocation audit logging system
state: Done
priority: P2
parent: KABSD-EPIC-0002
area: infra
iteration: null
tags:
- logging
- audit
- security
created: 2026-01-04
updated: 2026-01-07
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
original_type: Feature
---

# Context

We need a local-first audit log of agent tool invocations so humans can review
what was executed, copy commands for replay, and meet compliance expectations.
Logs must redact secrets and stay manageable via rotation.

# Goal

Provide a durable, human-readable log of agent tool calls with redaction and
replay-ready commands, plus configurable rotation/retention.

# Non-Goals

- Centralized log aggregation or remote shipping.
- Full security audit platform or SIEM integration.

# Approach

- Define a log schema for tool calls (timestamp, tool, args, cwd, outcome).
- Add redaction rules for secrets and sensitive paths.
- Emit append-only log entries in a local log directory.
- Default log root: `_kano/backlog/_logs/agent_tools/` (JSONL).
- Rotate logs based on size/count and keep a retention window.
- Provide copy-friendly command strings for humans.

# Alternatives

- Rely on CLI history without structured logs.
- Capture only summaries in Worklog (not sufficient for audit).

# Acceptance Criteria

- Logs capture each tool invocation with sanitized args.
- Logs include a copy-ready command line for replay.
- Secrets/sensitive tokens are masked.
- Default log path is documented as `_kano/backlog/_logs/agent_tools/`.
- Rotation and retention prevent unbounded log growth.

# Risks / Dependencies

- False negatives in redaction could leak secrets.
- Over-redaction may reduce log usefulness.

# Links

- Epic: [[KABSD-EPIC-0002_milestone-0-0-1-core-demo|KABSD-EPIC-0002 Milestone 0.0.1 (Core demo)]]
- UserStory: [[KABSD-USR-0002_capture-tool-invocations-with-redaction-and-replayable-commands|KABSD-USR-0002 Capture tool invocations with redaction and replayable commands]]
- UserStory: [[KABSD-USR-0003_log-storage-rotation-and-retention-policy|KABSD-USR-0003 Log storage, rotation, and retention policy]]
# Worklog

2026-01-04 10:15 [agent=codex] Created feature for agent tool audit logging system.
2026-01-04 10:22 [agent=codex] Added scope, approach, and linked user stories for audit logging.
2026-01-04 10:45 [agent=codex] Planned feature scope and created user stories/tasks.
2026-01-04 10:48 [agent=codex] Documented default log path `_kano/backlog/_logs/agent_tools/`.
2026-01-04 11:22 [agent=codex] Added logging schema reference and prototype logger scripts.
2026-01-06 08:34 [agent=codex-cli] Re-parented Feature from KABSD-EPIC-0001 to KABSD-EPIC-0002 for milestone 0.0.1.
2026-01-07 07:25 [agent=copilot] Audit logging shipped: redacted JSONL logs with rotation at _kano/backlog/_logs/agent_tools/.
