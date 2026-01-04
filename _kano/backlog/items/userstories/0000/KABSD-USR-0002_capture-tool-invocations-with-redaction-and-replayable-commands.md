---
id: KABSD-USR-0002
type: UserStory
title: "Capture tool invocations with redaction and replayable commands"
state: Proposed
priority: P2
parent: KABSD-FTR-0002
area: infra
iteration: null
tags: ["logging", "audit", "redaction"]
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

We need a trustworthy audit trail of agent tool calls that humans can replay.
Commands must be copy-friendly while removing secrets.

# Goal

As a maintainer, I want each tool invocation logged with redaction and a
copy-ready command so I can audit and rerun actions safely.

# Non-Goals

- Centralized logging or external storage.

# Approach

- Define a minimal log entry schema for tool calls.
- Record tool name, args, cwd, timestamp, and result status.
- Redact sensitive fields (tokens, keys, secrets) in the logged command.
- Default log root is `_kano/backlog/_logs/agent_tools/`.

# Links

- Feature: [[KABSD-FTR-0002_agent-tool-invocation-audit-logging-system|KABSD-FTR-0002 Agent tool invocation audit logging system]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0006_define-audit-log-schema-and-redaction-rules|KABSD-TSK-0006 Define audit log schema and redaction rules]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0007_prototype-tool-invocation-logger-with-redaction|KABSD-TSK-0007 Prototype tool invocation logger with redaction]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0013_integrate-audit-logging-into-skill-scripts|KABSD-TSK-0013 Integrate audit logging into skill scripts]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0014_enhance-audit-logging-config-and-wrapper-coverage|KABSD-TSK-0014 Enhance audit logging config and wrapper coverage]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0016_restrict-skill-scripts-to-kano-backlog-paths|KABSD-TSK-0016 Restrict skill scripts to _kano/backlog paths]]

# Alternatives

- Only keep summaries in Worklog.

# Acceptance Criteria

- Each tool call logs a sanitized command line that can be copied.
- Redaction masks secrets without removing required args.
- Log entries include tool name, cwd, and exit status.
- Log entries are written under `_kano/backlog/_logs/agent_tools/`.

# Risks / Dependencies

- Redaction may be incomplete or too aggressive.

# Worklog

2026-01-04 10:42 [agent=codex] Created user story for audit log entries and redaction.
2026-01-04 10:44 [agent=codex] Added scope, approach, and task links for logging and redaction.
2026-01-04 10:48 [agent=codex] Noted default log path for audit entries.
2026-01-04 14:12 [agent=codex] Added task to integrate audit logging into skill scripts.
2026-01-04 14:22 [agent=codex] Added task for logging config and wrapper coverage.
2026-01-04 14:44 [agent=codex] Added task to restrict skill scripts to _kano/backlog paths.
