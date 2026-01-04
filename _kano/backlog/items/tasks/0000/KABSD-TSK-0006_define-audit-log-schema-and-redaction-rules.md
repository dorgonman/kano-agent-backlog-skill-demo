---
id: KABSD-TSK-0006
type: Task
title: "Define audit log schema and redaction rules"
state: Done
priority: P2
parent: KABSD-USR-0002
area: infra
iteration: null
tags: ["logging", "redaction", "schema"]
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

We need a consistent schema for audit log entries and a clear redaction policy
to mask secrets while keeping commands replayable.

# Goal

Define the log entry fields and redaction rules the logger must enforce.

# Non-Goals

- Implement the logger itself.

# Approach

- Draft a JSONL schema for tool invocation events.
- Define redaction patterns (env keys, tokens, known secret names).
- Provide examples of redacted command output.
- Document default log root: `_kano/backlog/_logs/agent_tools/`.

# Links

- UserStory: [[KABSD-USR-0002_capture-tool-invocations-with-redaction-and-replayable-commands|KABSD-USR-0002 Capture tool invocations with redaction and replayable commands]]

# Alternatives

- Ad-hoc logging without schema (harder to audit).

# Acceptance Criteria

- Schema document covers required fields and examples.
- Redaction rules list includes common secret key names.

# Risks / Dependencies

- Over-redaction may reduce replay accuracy.
# Worklog

2026-01-04 10:42 [agent=codex] Created task for audit log schema and redaction rules.
2026-01-04 10:45 [agent=codex] Added scope, approach, and user story link.
2026-01-04 10:49 [agent=codex] Added default log path to schema scope.
2026-01-04 10:46 [agent=codex] Drafted task scope and links.
2026-01-04 11:13 [agent=codex] Started defining audit log schema and redaction rules.
2026-01-04 11:20 [agent=codex] Added references/logging.md with schema, redaction, and rotation defaults.
2026-01-04 11:17 [agent=codex] Completed schema and redaction spec in references/logging.md.
