---
id: KABSD-TSK-0139
uid: 019ba3c4-3f67-70d0-9b59-6f0d9319af71
type: Task
title: "Define bid template and minimum bid acceptance rules"
state: Proposed
priority: P1
parent: KABSD-USR-0025
area: dispatch
iteration: null
tags: ["dispatcher", "bid", "template", "gating"]
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

Bid gating is only useful if bids are comparable and have a minimum required structure.
This task defines the bid template and the rules for accepting/rejecting bids without depending on subjective “confidence”.

# Goal

Define a stable bid template (fields + formatting) and minimum acceptance rules that can be linted.

# Non-Goals

- No implementation of bid storage or selection logic yet.
- No competitive bidding requirement by default.

# Approach

- Define bid template sections (recommended minimum):
  - Summary / intent
  - Proposed approach (steps)
  - Files/modules expected to change
  - Acceptance criteria + how to validate locally
  - Risks and mitigations
  - Rollback plan
  - Stop conditions (when to halt and ask for human decision)
- Define minimum acceptance rules:
  - must include validation steps,
  - must mention risk/rollback for risky items,
  - must specify scope boundaries and “won't do”.
- Decide storage format:
  - as an attached artifact note, or
  - as a dedicated bid file under the backlog artifact system.

# Alternatives

- Free-form bids in chat (not auditable; not lintable).
- Full RFC/ADR per bid (too heavy).

# Acceptance Criteria

- A bid template exists with required fields marked.
- A set of minimum acceptance rules exists, separating hard errors vs warnings.
- At least 2 sample bids written with the template (one accepted, one rejected) and rationale.

# Risks / Dependencies

- Overly strict rules can cause friction; keep minimal.
- Needs integration with assignment/claim mechanisms for “winner starts work”.
# Worklog

2026-01-10 01:18 [agent=codex] Planning task: define bid fields (plan/acceptance/risks/stop conditions) and gating rules.
2026-01-10 02:06 [agent=codex] Added bid template structure, lintable minimum rules, and storage options.
