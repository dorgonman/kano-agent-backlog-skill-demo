---
id: KABSD-TSK-0007
type: Task
title: "Prototype tool invocation logger with redaction"
state: Done
priority: P2
parent: KABSD-USR-0002
area: infra
iteration: null
tags: ["logging", "redaction", "tools"]
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

We need a minimal logger that captures tool invocations with redaction and
emits copy-friendly commands.

# Goal

Prototype logging for tool calls to validate the schema and redaction flow.

# Non-Goals

- Production-grade logging pipeline.

# Approach

- Add a minimal logger hook around tool execution.
- Emit JSONL entries to a local log file.
- Default log root is `_kano/backlog/_logs/agent_tools/`.
- Ensure redaction runs before write.

# Links

- UserStory: [[KABSD-USR-0002_capture-tool-invocations-with-redaction-and-replayable-commands|KABSD-USR-0002 Capture tool invocations with redaction and replayable commands]]

# Alternatives

- Only log summaries in Worklog.

# Acceptance Criteria

- At least one tool call emits a JSONL log entry.
- Redaction is applied before write.
- Log entry includes copy-ready command string.

# Risks / Dependencies

- Logger integration may be invasive depending on tool harness.
# Worklog

2026-01-04 10:42 [agent=codex] Created task for tool invocation logging prototype.
2026-01-04 10:46 [agent=codex] Added scope, approach, and user story link.
2026-01-04 10:49 [agent=codex] Added default log path to logger scope.
2026-01-04 10:46 [agent=codex] Drafted task scope and links.
2026-01-04 11:14 [agent=codex] Started tool invocation logger prototype.
2026-01-04 11:21 [agent=codex] Added audit_logger.py and run_with_audit.py prototype scripts.
2026-01-04 11:17 [agent=codex] Completed logger prototype scripts.
