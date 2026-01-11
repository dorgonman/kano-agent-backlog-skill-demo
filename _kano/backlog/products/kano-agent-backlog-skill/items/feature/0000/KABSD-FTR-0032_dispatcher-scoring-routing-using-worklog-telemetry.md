---
area: tooling
created: '2026-01-11'
decisions: []
external: {}
id: KABSD-FTR-0032
iteration: null
links:
  blocked_by:
  - KABSD-FTR-0031
  blocks: []
  relates:
  - KABSD-FTR-0027
owner: null
parent: KABSD-EPIC-0004
priority: P2
state: Proposed
tags:
- dispatcher
- telemetry
- worklog
- scoring
- routing
title: Dispatcher scoring + routing using worklog telemetry (capability vs observability)
type: Feature
uid: 019baa91-8fd8-7387-b7dd-1c38a513c4e8
updated: '2026-01-11'
---

# Context

The dispatcher concept (KABSD-FTR-0027) needs an evidence-based routing policy. This ticket defines a local-first scoring model using the worklog run telemetry (Ticket A) to estimate:
- capability_score (can it do the work correctly?)
- observability_score (how predictable/controllable is cost/telemetry?)

Important guarantee: tokens.source=unknown must not penalize capability_score; it only affects observability_score.


# Goal

Implement capability vs observability scoring and a routing policy that recommends an agent/model for a task, with auditable decision factors, using only local telemetry.


# Non-Goals

- Do not implement a UI dashboard.
- Do not implement cross-machine sync or any server runtime.
- Do not implement dispatcher execution; only scoring + routing policy output.


# Approach

Inputs:
1. Consume telemetry JSONL from Ticket A and aggregate per agent/provider/model.
2. Accept task classification flags (e.g., budget_critical vs correctness_critical) via config or CLI flags.

Scoring:
3. capability_score signals (examples): done ratio, blocked/redo ratio, retry penalties, optional quality signals.
4. observability_score signals: telemetry completeness, tokens.source weighting (actual>estimated>unknown).
5. Estimation error penalty (observability only): when both estimated_total and actual_total exist for the same run,
   err = abs(est-actual)/actual, apply configurable tiered penalties; if no actual, do not compute error.

Routing policy:
6. Compute weighted score based on task type (budget_critical biases observability; correctness_critical biases capability).
7. Output: recommended agent/model + short reasons + whether to reroute or request human decision when thresholds fail.

Configurability:
8. Provide a config file (json/toml) for weights/penalties/thresholds with conservative defaults.
9. Ensure decisions are auditable: log inputs, computed components, and final recommendation rationale.


# Alternatives

1. Single-score routing (capability only)
   - Pros: simple
   - Cons: cannot express cost/observability trade-offs

2. Penalize unknown tokens in capability
   - Pros: might push selection toward observable agents
   - Cons: confounds correctness with observability; violates the explicit guarantee


# Acceptance Criteria

- Can aggregate telemetry into per-agent/model capability_score and observability_score.
- Routing outputs a recommendation + reasons for a given task classification.
- tokens.source=unknown does not affect capability_score (only observability_score).
- Decision factors are logged for auditability.


# Risks / Dependencies

- Risk: Goodhart effects (optimize metrics, not outcomes). Mitigation: keep signals minimal and reviewable.
- Risk: sparse data yields noisy scores. Mitigation: priors/defaults + minimum-sample thresholds.
- Dependency: requires telemetry schema + ingestion (Ticket A).


# Worklog

2026-01-11 09:00 [agent=codex-cli] Created Ticket B from request: dispatcher scoring/routing policy; blocked by KABSD-FTR-0031.