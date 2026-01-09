---
id: KABSD-USR-0026
uid: 019ba3c3-ee9a-7124-9fd0-78d03c965a35
type: UserStory
title: "Assignment record and conflict isolation for dispatched work"
state: Proposed
priority: P1
parent: KABSD-FTR-0027
area: dispatch
iteration: null
tags: ["dispatcher", "assignment", "coordination", "claim", "lease"]
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

Dispatching is meaningless if two agents can still work the same item at the same time.
We need an explicit assignment record and basic conflict isolation primitives that integrate with the existing coordination layer (claim/lease).

# Goal

Define how “assigned to agent X” is represented, enforced, and audited, so that dispatched work is exclusive by default and recoverable when agents crash or abandon work.

# Non-Goals

- Do not build distributed locking across machines; start with file-first coordination.
- Do not require a central server; this must work in local-first repos.
- Do not guarantee perfect enforcement against malicious actors; focus on preventing accidental conflicts.

# Approach

- Define an assignment record (fields: assignee agent id, tier, scope, lease TTL, acquisition timestamp, renewal).
- Integrate with claim/lease:
  - Assignment implies claim acquisition.
  - Only the assignee can transition the item to `InProgress` (unless forced by a human).
- Define conflict recovery:
  - Lease expiry and takeover protocol.
  - Manual override / force paths that remain auditable.

# Alternatives

- “Just communicate in chat” (does not scale).
- Git-level locking (not portable; still not tied to work item state).

# Acceptance Criteria

- A documented assignment record schema and lease rules.
- A documented enforcement policy tying assignment -> allowed state transitions.
- A minimal CLI/spec plan for: claim, renew, release, takeover (or mapping to existing tools).

# Risks / Dependencies

- Requires reliable agent identity injection into Worklog records.
- Needs careful UX to avoid deadlocks when leases expire mid-work.

# Worklog

2026-01-10 02:05 [agent=codex] Added assignment/lease enforcement scope and recovery expectations.

2026-01-10 01:18 [agent=codex] Created to define assignment records and isolation/coordination integration.
