---
id: KABSD-TSK-0142
uid: 019ba3c4-78f9-7fa0-b209-ee17b73d7ba4
type: Task
title: "Design enforcement policy to prevent low-tier agents touching high-risk items"
state: Proposed
priority: P1
parent: KABSD-USR-0026
area: dispatch
iteration: null
tags: ["dispatcher", "policy", "enforcement", "tier", "risk"]
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

Even with scoring and bidding, the system must enforce “who is allowed to do what”.
Otherwise a low-tier agent can accidentally (or by default) start work on a high-risk item and create costly rework.

# Goal

Define enforceable policies that prevent low-tier agents from starting/continuing high-risk work without explicit override, while preserving local-first workflow and auditability.

# Non-Goals

- No runtime sandboxing of filesystem operations.
- No central authority service; enforcement is policy + tooling checks.

# Approach

- Define enforcement points:
  - before transitioning to `InProgress`,
  - before applying state-changing operations,
  - before generating worksets for implementation.
- Define policy inputs:
  - `required_tier`, `risk_flags`, explicit overrides (human-approved).
- Define override mechanics:
  - `--force` still possible, but must append an explicit Worklog reason and link to a decision/approval note.
- Define reporting:
  - flag policy violations in linter output (hard error by default for critical cases).

# Alternatives

- Rely on social contracts (fails in multi-agent systems).
- Hard-code a model allowlist (not future-proof; user may add internal agents).

# Acceptance Criteria

- Documented policy rules and enforcement points.
- A minimal “policy check” spec usable by scripts/linter.
- Defined override mechanism that is auditable.

# Risks / Dependencies

- Depends on tier definitions from the rubric (USR-0024).
- Needs consistent state semantics and the ability to identify the acting agent (`--agent`).

# Worklog

2026-01-10 01:18 [agent=codex] Planning task: define policy checks and failure modes for unsafe assignment attempts.
2026-01-10 02:06 [agent=codex] Expanded enforcement policy scope and override/audit expectations.
