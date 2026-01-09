---
id: KABSD-TSK-0138
uid: 019ba3c4-34a8-7358-9df3-8ef2fe6de271
type: Task
title: "Prototype scoring CLI (spec-only) with audit trail"
state: Proposed
priority: P2
parent: KABSD-USR-0024
area: dispatch
iteration: null
tags: ["dispatcher", "complexity", "cli", "audit"]
created: 2026-01-10
updated: 2026-01-10
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

To keep scoring auditable, a scoring action should be recorded as an explicit event (who scored, inputs, derived tier).
Before implementing, we need a stable CLI/spec design that fits the existing Kano backlog scripts and logging.

# Goal

Define a spec-only CLI surface for scoring that:
- takes a work item ref/path,
- records rubric inputs and derived `required_tier`,
- emits an audit-friendly record (replayable command + redaction rules).

# Non-Goals

- No scoring implementation or model integration yet.
- No server/MCP; local-first only.

# Approach

- Define the command interface (example):
  - `kano dispatch score --item <ref> --blast-radius medium --verification low ... --agent <name>`
- Define output behaviors:
  - update frontmatter fields or append a structured Worklog entry (or both),
  - optionally update derived index tables for fast querying.
- Define audit log expectations:
  - replayable command,
  - redact secrets,
  - log verbosity control.

# Alternatives

- Manual score notes in Worklog (not enforceable; hard to query).
- Store scores only in SQLite (breaks file-first readability).

# Acceptance Criteria

- A CLI spec (flags, defaults, required fields) documented with examples.
- A proposed “score record” format (Worklog snippet and/or derived data schema).
- A mapping to existing config keys (e.g., enable/disable auto-refresh).

# Risks / Dependencies

- Needs agreement on canonical vs derived field placement.
- Needs consistent agent identity injection (`--agent` required).
# Worklog

2026-01-10 01:18 [agent=codex] Planning task: outline scoring command interface and audit records (no implementation yet).
2026-01-10 02:06 [agent=codex] Added CLI spec outline, audit record expectations, and field placement considerations.
