---
id: KABSD-TSK-0140
uid: 019ba3c4-4c94-714e-a94c-94e10d26d402
type: Task
title: "Design bid selection policy (single-bid vs competitive)"
state: Proposed
priority: P2
parent: KABSD-USR-0025
area: dispatch
iteration: null
tags: ["dispatcher", "bid", "policy", "selection"]
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

When bidding is enabled, the dispatcher must decide whether to ask for one bid or multiple, and how to choose the winner.
This policy must be explicit so humans can audit and agents can follow it consistently.

# Goal

Define bid selection policy:
- when to use single-bid vs competitive bids,
- how to rank bids,
- how to reject bids and escalate to another candidate.

# Non-Goals

- No implementation of bidding execution or multi-agent orchestration yet.
- No ML-based automatic ranking; start with deterministic heuristics.

# Approach

- Define bid mode triggers:
  - `required_tier` threshold,
  - high risk flags (low reversibility, unclear validation),
  - user opt-in for competitive bids.
- Define winner selection criteria (in priority order):
  - explicit acceptance/validation steps,
  - smallest scope / safest changes first,
  - clear rollback and stop conditions,
  - alignment with requested constraints (files, modules, style).
- Define escalation:
  - reject missing minimum fields,
  - re-bid request for clarification once,
  - otherwise invite next candidate or escalate to a higher tier.

# Alternatives

- Always competitive (too expensive).
- Always single-bid (may misroute high-risk items).

# Acceptance Criteria

- A documented policy matrix: triggers -> bid mode.
- A deterministic ranking checklist usable by an agent or a human.
- A documented rejection/escalation workflow.
- Examples: at least 2 scenarios showing mode choice and winner selection.

# Risks / Dependencies

- Needs the rubric/tier definition (USR-0024).
- Needs a bid template and minimum acceptance rules (TSK-0139).
# Worklog

2026-01-10 01:18 [agent=codex] Planning task: define when to use single-bid vs competitive bids and selection criteria.
2026-01-10 02:06 [agent=codex] Added explicit triggers, ranking criteria, and escalation workflow.
