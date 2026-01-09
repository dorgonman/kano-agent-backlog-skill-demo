---
id: KABSD-USR-0024
uid: 019ba3c3-d92a-71c4-8702-b1311b7189cb
type: UserStory
title: "Complexity scoring rubric and required tier derivation"
state: Proposed
priority: P1
parent: KABSD-FTR-0027
area: dispatch
iteration: null
tags: ["dispatcher", "complexity", "scoring", "tier", "policy"]
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

`kano-agent-backlog-dispatcher` needs a consistent, auditable way to decide which agent/model tier is allowed to work on a work item.
Without an explicit rubric, dispatch decisions become ad-hoc and non-repeatable.

# Goal

Define a minimal, policy-driven complexity/risk rubric and a deterministic mapping to a `required_tier` that can be recorded on a work item (or as derived metadata).

# Non-Goals

- Do not predict effort/ETA; this is about risk and verification, not planning poker.
- Do not use LLM-based evaluation as a trust root; rubric evaluation must be explainable and reproducible.
- Do not introduce cross-repo/global scoring in this phase.

# Approach

- Define rubric inputs (e.g., blast radius, reversibility, testability, dependency depth, ambiguity).
- Define `tier` semantics (what an agent in each tier may do; what must be escalated).
- Define storage: frontmatter fields and/or derived index fields for `complexity`, `risk_flags`, and `required_tier`.
- Define how the rubric is evaluated and recorded (Worklog entry with inputs + derived tier).

# Alternatives

- Always route to the strongest model (costly and hides risk).
- Human-only triage (does not scale; weak audit trail).

# Acceptance Criteria

- A documented rubric with named inputs and discrete levels.
- A deterministic mapping from rubric result -> `required_tier`.
- A minimal schema proposal for how to store/derive these fields in file-first items and the SQLite index.
- Examples: at least 5 worked examples showing rubric inputs and resulting tier with rationale.

# Risks / Dependencies

- If tiers are too strict, work stalls; if too lax, the policy is meaningless.
- Requires consistent state semantics and clear “allowed operations” per tier.

# Worklog

2026-01-10 02:05 [agent=codex] Expanded story scope: defined rubric goals, storage expectations, and acceptance criteria.

2026-01-10 01:17 [agent=codex] Created to define a complexity/risk rubric and derive required tiers for dispatch.
