---
id: KABSD-TSK-0141
uid: 019ba3c4-6d62-7ca6-b194-85f4752b9a45
type: Task
title: "Define assignment records and coordination integration (claim/lease)"
state: Proposed
priority: P1
parent: KABSD-USR-0026
area: dispatch
iteration: null
tags: ["dispatcher", "assignment", "claim", "lease", "coordination"]
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

Dispatch decisions must translate into concrete coordination primitives so agents don’t collide.
This task defines the assignment record schema and how it integrates with claim/lease coordination.

# Goal

Define an assignment + lease design that supports:
- exclusive work ownership,
- safe takeover after expiry,
- auditability for overrides.

# Non-Goals

- No distributed locking service.
- No enforcement against malicious actors; focus on preventing accidental conflicts.

# Approach

- Define “assignment record” fields (suggested):
  - `assignee_agent`, `assignee_tier`, `assigned_at`, `lease_ttl`, `lease_expires_at`
  - `scope` (files/areas) and `constraints` (allowed actions)
  - `handoff_reason` for takeovers
- Map assignment to claim/lease:
  - assignment implies claim acquisition,
  - only assignee can renew/release,
  - takeover requires lease expiry (or explicit force with audit).
- Define storage:
  - canonical frontmatter minimal pointer + derived lease state in index, or
  - canonical fields only (simple but noisier).

# Alternatives

- Rely on Git conflicts (too late; expensive).
- Human coordination only (does not scale).

# Acceptance Criteria

- A documented assignment schema and lease lifecycle.
- A documented interaction with state transitions (`InProgress`, `Done`, `Dropped`).
- A recovery flow for abandoned work (expiry + takeover).

# Risks / Dependencies

- Depends on stable agent identity conventions (`--agent` required everywhere).
- Needs clarity on where to store canonical vs derived lease data.

# Worklog

2026-01-10 01:18 [agent=codex] Planning task: define assignment fields and coordination/claim integration for exclusive work.
2026-01-10 02:06 [agent=codex] Added assignment/lease schema outline, lifecycle, and recovery expectations.
