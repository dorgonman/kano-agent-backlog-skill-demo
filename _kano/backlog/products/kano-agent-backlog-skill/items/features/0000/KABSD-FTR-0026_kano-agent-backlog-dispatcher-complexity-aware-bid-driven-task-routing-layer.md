---
id: KABSD-FTR-0026
uid: 019ba3a6-ba87-708f-a078-bfcd872f851d
type: Feature
title: "kano-agent-backlog-dispatcher: complexity-aware, bid-driven task routing layer"
state: Proposed
priority: P1
parent: KABSD-EPIC-0004
area: dispatch
iteration: null
tags: ["dispatcher", "routing", "bid", "complexity", "policy", "multi-agent", "governance"]
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

This Feature proposes `kano-agent-backlog-dispatcher`: a dispatch/routing layer inside the kano-agent-backlog ecosystem.
It routes backlog work items to suitable agents/models using auditable, policy-driven rules.

Pain points it targets:
- Decision evaporation: trade-offs discussed with agents disappear and become untraceable.
- Capability gaps: weaker models cannot be made strong; they need enforced scope limits.
- Misrouting waste: the wrong agent doing the wrong work increases token/time cost and risks polluting the mainline.
- Multi-agent conflicts: parallel work can duplicate or overwrite without clear assignment and isolation.
- Information overload: scoring/bidding must be gated to avoid ticket spam and governance fatigue.

# Goal

Define a minimal, local-first dispatch protocol and tooling that is:
- Auditable: why an agent/model was selected is recorded as a durable decision.
- Complexity-aware: tasks get a complexity/risk assessment that implies a required capability tier.
- Bid-gated when needed: candidates submit a short implementation plan before work begins.
- Safe-by-default: policies prevent low-trust agents from touching high-risk tasks.
- Low-overhead: the system only activates scoring/bidding above configurable thresholds.

# Non-Goals

- This is not a standalone product UI; it is a routing layer for kano-agent-backlog.
- No server runtime/MCP implementation in this phase (local-first, spec/CLI only).
- No attempt to equalize model quality; we isolate risk instead of hoping for miracles.
- No trust in self-reported model identity as a root of trust; it is record-only.
- No cross-repo/global dispatch in v1; focus on single product/repo behavior.

# Approach

Phase 1 — Weak policy + metadata (no ML):
- Define a complexity/risk rubric (inputs: blast radius, reversibility, verification clarity, dependencies).
- Derive `required_tier` from the rubric (policy-driven, not agent self-report).
- Define bid template (plan + acceptance + risks + stop conditions).

Phase 2 — Bid-gated dispatch:
- Add a `dispatch` workflow: declare a work item dispatchable -> collect bids -> select winner -> assign.
- Support modes:
  - Single-bid: invite one likely candidate; escalate to others if bid fails.
  - Competitive: 2–3 candidates bid; select best plan for high-risk work.

Phase 3 — Evidence-based tiering (repo posterior):
- Record local outcomes (success rate, rework rate, iterations, hallucination incidents) to refine policy.
- Treat external benchmarks as a prior only; local repo outcomes are the posterior.

Integration points:
- Coordinate with conflict-prevention/claim-lease mechanisms so assigned work is exclusive.
- Use audit logs and Worklog as the durable record of routing and decisions.

# Alternatives

- Manual assignment in chat (not auditable; high risk of context loss).
- Always use the strongest model (too expensive; does not scale).
- Fully automatic model selection without bids (unsafe; hard to debug misroutes).

# Acceptance Criteria

- A documented dispatch protocol exists (scoring, bid triggers, bid format, selection, downgrade/hand-off).
- A minimal CLI/spec exists to:
  - score a work item and compute required tier,
  - record one or more bids,
  - record the selection decision and assignment.
- Policies prevent low-tier agents from being assigned high-risk work items.
- All routing decisions are traceable via Worklog/ADR entries.

# Risks / Dependencies

- Process overhead: if bidding triggers too often, it becomes bureaucracy.
- Gaming/Goodhart: agents may optimize bids instead of outcomes; needs governance + outcome metrics.
- Context bloat: bids and expansions must be bounded; prefer summaries and links.
- Requires consistent agent identity and basic conflict-prevention primitives to avoid collisions.

# Links

- Related: [[KABSD-FTR-0016_coordination-layer-claim-lease-for-multi-agent|KABSD-FTR-0016 Claim/Lease coordination]]
- Related: [[KABSD-FTR-0006_conflict-prevention-mechanism|KABSD-FTR-0006 Conflict prevention]]
- Related: [[KABSD-FTR-0020_multi-agent-collaboration-modes-local-single-repo-local-multi-repo-via-worktree-remote|KABSD-FTR-0020 Multi-agent collaboration modes]]
- Related: [[KABSD-FTR-0011_multi-product-platform-intelligence-and-governance|KABSD-FTR-0011 Multi-product governance]]

# Worklog

2026-01-10 00:46 [agent=codex] Created to plan a dispatcher/routing layer for assigning backlog work items to suitable agents/models.
2026-01-10 00:47 [agent=codex] Drafted dispatcher concept, phased approach, and acceptance criteria.
