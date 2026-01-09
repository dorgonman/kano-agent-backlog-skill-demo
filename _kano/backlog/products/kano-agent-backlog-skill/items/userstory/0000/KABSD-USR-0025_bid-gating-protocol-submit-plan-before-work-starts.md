---
id: KABSD-USR-0025
uid: 019ba3c3-e279-7e17-9e54-d408ad571e4e
type: UserStory
title: "Bid gating protocol: submit plan before work starts"
state: Proposed
priority: P1
parent: KABSD-FTR-0027
area: dispatch
iteration: null
tags: ["dispatcher", "bid", "gating", "plan", "acceptance"]
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

For medium/high-risk work items, simply assigning an agent is not enough: misinterpretation causes costly rework and can pollute the main branch.
We need a lightweight “gating” step where the candidate must prove understanding before touching code.

# Goal

Define a bid protocol where candidate agents submit a short, auditable plan (including acceptance and stop conditions), and the dispatcher (or human) selects a winner.

# Non-Goals

- Do not implement a full UI or a marketplace; this is a protocol + minimal CLI/spec.
- Do not require competitive bidding for every item; bidding must be threshold-gated.
- Do not rely on “agent confidence” as a decision factor; focus on verifiability and risk handling.

# Approach

- Define when bidding is required (by `required_tier`, risk flags, or explicit user request).
- Define bid content template (plan, acceptance, risks, rollback, stop conditions).
- Define bid submission and selection records (where they live and how they are linked to the work item).
- Define bid modes:
  - Single-bid (default): invite one candidate; escalate if rejected.
  - Competitive (optional): 2–3 bids for high-risk items.

# Alternatives

- Start work immediately and “fix later” (high waste).
- Always require bids (too expensive).

# Acceptance Criteria

- A stable bid template exists (machine-checkable minimum fields).
- A selection record format exists (winner, rationale, constraints, timestamp).
- Clear rules for accept/reject bids, escalation, and hand-off.
- Examples: at least 3 sample bids and 1 sample selection record.

# Risks / Dependencies

- Process overhead if triggers are too aggressive.
- Needs coordination/claim mechanisms so multiple agents do not implement simultaneously.

# Worklog

2026-01-10 02:05 [agent=codex] Defined bid gating scope, modes, and acceptance criteria.

2026-01-10 01:18 [agent=codex] Created to define bid submission format and gating rules.
