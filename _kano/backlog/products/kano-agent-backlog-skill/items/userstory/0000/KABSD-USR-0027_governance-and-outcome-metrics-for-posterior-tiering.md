---
id: KABSD-USR-0027
uid: 019ba3c3-fb6a-7b9d-8b40-57c69acc31d2
type: UserStory
title: "Governance and outcome metrics for posterior tiering"
state: Proposed
priority: P2
parent: KABSD-FTR-0027
area: dispatch
iteration: null
tags: ["dispatcher", "governance", "metrics", "posterior", "benchmark"]
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

External model benchmarks can provide a rough starting point (“prior”), but they are not sufficient for a specific repo’s real-world workload.
To keep dispatch decisions auditable and improvable, the system needs outcome metrics (“posterior”) and lightweight governance.

# Goal

Define what to measure, how to store it as derived data, and how governance decisions (tier updates, policy overrides) are recorded so dispatch rules improve over time without turning into bureaucracy.

# Non-Goals

- Do not build a full analytics platform.
- Do not require collecting sensitive user data; keep metrics local-first and minimal.
- Do not implement automated model evaluation with hidden heuristics; all updates must be explainable.

# Approach

- Define outcome metrics:
  - acceptance pass rate, rework count, number of iterations, rollback events, “hallucination incidents” (as user-reported flags).
- Define storage:
  - derived index tables and/or per-item derived summaries (not canonical truth).
- Define governance:
  - policy change log (ADR or dedicated work item type),
  - thresholds that trigger escalation (e.g., too many reworks in a row).
- Define how external priors are used:
  - as initialization only, with explicit override rules by local outcomes.

# Alternatives

- Never update tiers (stagnates; wrong priors persist).
- Fully automatic tiering (unsafe; hard to debug and gameable).

# Acceptance Criteria

- A documented metrics schema and a minimal reporting plan (query/report examples).
- A documented governance workflow (who/what writes policy updates; how they are audited).
- A documented policy for external priors vs local posterior updates.

# Risks / Dependencies

- Metrics can be gamed; governance must stay simple and tied to acceptance outcomes.
- Requires consistent tagging/state semantics so reporting is meaningful.

# Worklog

2026-01-10 02:05 [agent=codex] Clarified posterior metrics scope and governance expectations for tiering.

2026-01-10 01:18 [agent=codex] Created to define metrics and governance rules for refining dispatch policies.
