---
id: KABSD-TSK-0291
uid: 019be476-d630-7771-accf-8b315f41a6a2
type: Task
title: "Implement Assumptions/Priors Registry"
state: Ready
priority: P2
parent: KABSD-EPIC-0011
area: general
iteration: backlog
tags: ['assumptions', 'priors', 'metadata']
created: 2026-01-22
updated: 2026-01-22
owner: None
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

Decisions are often steered by hidden priors (assumptions). As noted in ADR-0037, we must make these explicit. Just as we track "Risks", we should track "Assumptions" that underpin our Reality Gap analysis.

# Goal

Implement a mechanism to register and track Assumptions/Priors for significant decisions and topics.

# Approach

1.  **Metadata Field**: Add `assumptions` list to Backlog Item and Topic frontmatter.
2.  **Schema**: Define `Assumption` model (statement, confidence, impact if wrong).
3.  **Registry**: Generate `Assumptions_Registry.md` in `_meta/` to aggregate them project-wide.
4.  **Reality Gap**: Update snapshot logic to highlight assumptions that need verification.

# Acceptance Criteria

- [ ] `BacklogItem` model supports `assumptions` list field
- [ ] `Topic` manifest supports `assumptions` list field
- [ ] `kano-backlog assumptions list` command implemented
- [ ] `Assumptions_Registry.md` generation implemented

# Risks / Dependencies

- **Risk**: Over-formalization.
  - **Mitigation**: Keep it optional. Only require for P0/P1 items or ADRs.

# Worklog

2026-01-22 14:49 [agent=antigravity] Created item
2026-01-22 14:50 [agent=antigravity] Filled in Ready gate fields
2026-01-22 14:49 [agent=antigravity] Filled in Ready gate requirements
