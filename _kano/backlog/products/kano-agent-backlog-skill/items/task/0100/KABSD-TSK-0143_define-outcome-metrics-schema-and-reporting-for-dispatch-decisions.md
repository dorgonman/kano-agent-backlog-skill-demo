---
id: KABSD-TSK-0143
uid: 019ba3c4-83f6-73bb-9b50-5b3345a356ef
type: Task
title: "Define outcome metrics schema and reporting for dispatch decisions"
state: Proposed
priority: P2
parent: KABSD-USR-0027
area: dispatch
iteration: null
tags: ["dispatcher", "metrics", "governance", "posterior"]
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

Dispatch policy improves only if we can measure outcomes and feed that back into governance.
We need a minimal metrics schema that is derived (rebuildable) and works with local-first constraints.

# Goal

Define outcome metrics and a reporting plan to support:
- evidence-based tiering (posterior),
- audit of dispatch decisions,
- detection of systematic misrouting.

# Non-Goals

- No full analytics pipeline or dashboards beyond simple generated reports.
- No collection of sensitive data; keep metrics local and minimal.

# Approach

- Define metrics (suggested minimal set):
  - `accepted_on_first_try` (yes/no),
  - `rework_count` (number of significant revisions),
  - `dispatch_iterations` (how many bid/assignment cycles),
  - `rollback_event` (yes/no),
  - `policy_violation` (yes/no, with reason),
  - optional `hallucination_flag` (human-reported).
- Define schema placement:
  - derived SQLite tables for queries,
  - optional per-item derived summaries generated into views.
- Provide query examples:
  - “agents with highest rework rate”
  - “items misrouted below required tier”
  - “top areas with high rollback frequency”

# Alternatives

- Only store free-text postmortems (hard to query).
- Centralized telemetry (breaks local-first posture).

# Acceptance Criteria

- A metrics schema proposal (tables/fields or JSONL) that is derived/rebuildable.
- At least 5 example queries/reports and the intended usage.
- A clear mapping to governance actions (what triggers policy review).

# Risks / Dependencies

- Metrics need consistent definitions to avoid argument-by-terminology.
- Requires a stable notion of “dispatch decision” records and agent identity.

# Worklog

2026-01-10 01:18 [agent=codex] Planning task: define metrics captured per assignment and how to report/aggregate.
2026-01-10 02:06 [agent=codex] Added minimal metrics set, derived schema guidance, and example report queries.
