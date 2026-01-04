---
id: KABSD-TSK-0025
type: Task
title: "Define backlog sandbox path and guardrails"
state: Proposed
priority: P2
parent: KABSD-USR-0010
area: testing
iteration: null
tags: ["sandbox", "tests"]
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

Path guards now restrict scripts to `_kano/backlog/`, but we need a safe
exception for a sandbox test root.

# Goal

Define the sandbox root path and update guardrails to allow it explicitly.

# Non-Goals

- Removing path guards entirely.

# Approach

- Confirm the sandbox root name (e.g., `_kano/backlog_sandbox`).
- Add a guard allowlist for the sandbox root.
- Document the sandbox usage rules.

# Alternatives

- Keep using `_kano/backlog/_tmp_tests` only.

# Acceptance Criteria

- Sandbox root is defined and documented.
- Path guards allow operations inside the sandbox only.

# Risks / Dependencies

- An overly broad allowlist could weaken guardrails.

# Worklog

2026-01-04 18:23 [agent=codex] Created task to define sandbox path and guardrails.
2026-01-04 18:40 [agent=codex] Added scope and acceptance criteria for sandbox guardrails.
