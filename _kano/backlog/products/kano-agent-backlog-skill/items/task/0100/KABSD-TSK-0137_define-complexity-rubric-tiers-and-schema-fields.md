---
id: KABSD-TSK-0137
uid: 019ba3c4-29f8-7735-8dcf-87eb9b3c4045
type: Task
title: "Define complexity rubric, tiers, and schema fields"
state: Proposed
priority: P1
parent: KABSD-USR-0024
area: dispatch
iteration: null
tags: ["dispatcher", "complexity", "rubric", "schema"]
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

Dispatcher routing needs a shared “language” for complexity and risk so different agents make compatible decisions.
This task defines the concrete rubric and the fields required to store it (file-first + derived index).

# Goal

Produce a rubric spec and schema proposal that supports:
- scoring inputs and rationale,
- a deterministic `required_tier`,
- optional risk flags for governance and enforcement.

# Non-Goals

- No implementation of scoring logic in code here (spec/design only).
- No cross-repo aggregation.

# Approach

- Draft a rubric with discrete inputs (suggested starting set):
  - `blast_radius` (files/areas touched, downstream impact),
  - `reversibility` (rollback difficulty),
  - `verification` (mechanical testability / acceptance clarity),
  - `dependency_depth` (blocked-by chain length, external services),
  - `ambiguity` (unknowns / missing requirements).
- Define tier semantics (Tier0..TierN or named tiers) and what each tier may do.
- Propose schema fields (canonical vs derived):
  - canonical fields should be minimal; derived index can hold richer computed fields.
- Provide examples mapping inputs -> tier.

# Alternatives

- Only store a free-text score explanation (hard to enforce / query).
- Use “story points” (not risk-oriented; ambiguous).

# Acceptance Criteria

- Rubric input list with definitions and discrete levels.
- Tier table describing allowed operations per tier.
- Proposed schema fields, including which are canonical frontmatter vs derived index.
- At least 5 scored examples with rationale.

# Risks / Dependencies

- Needs alignment with existing state machine and Ready gate expectations.
- Overly complex rubric increases cost; keep it minimal first.
# Worklog

2026-01-10 01:18 [agent=codex] Planning task: define scoring rubric inputs and the frontmatter/schema fields needed.
2026-01-10 02:06 [agent=codex] Added detailed rubric inputs, tier semantics goals, and schema/derived-data guidance.
