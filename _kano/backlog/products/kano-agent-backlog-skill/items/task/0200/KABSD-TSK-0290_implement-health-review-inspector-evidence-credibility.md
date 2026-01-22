---
id: KABSD-TSK-0290
uid: 019be475-eb2f-72ff-8e67-8c9cdacf5ffd
type: Task
title: "Implement Health Review Inspector (Evidence Credibility)"
state: Ready
priority: P2
parent: KABSD-EPIC-0011
area: general
iteration: backlog
tags: ['inspector', 'health', 'evidence']
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

We need an "external inspector" to check for evidence credibility and risk gaps (as defined in ADR-0037). While "Audit" checks for rule compliance (naming, fields), "Health" checks for trust gaps (single source dependency, missing counter-examples).

# Goal

Implement a Health Review Inspector that consumes the query surface and produces a "Trust Gap Report".

# Approach

1.  **Rule Set**: Implement checks for:
    - Single source dependency (all evidence from one file/author)
    - Jargon credentialism (claims backed by terminology, not data)
    - Missing counter-examples (survivor bias check)
    - Unverifiable claims (missing verification steps)
2.  **Implementation**: Create reference inspector script `examples/inspectors/health_review.py`.
3.  **Output**: Generate JSON report with findings + evidence (using Inspector Pattern schema).

# Acceptance Criteria

- [ ] `health_review.py` script created
- [ ] Implements check: Single Source Dependency
- [ ] Implements check: Missing Counter-examples (heuristic)
- [ ] Produces JSON report matching Inspector Output Contract (ADR-0037)
- [ ] Unit tests for inspector logic

# Risks / Dependencies

- **Risk**: Heuristics might be noisy.
  - **Mitigation**: Start with high-confidence signals (e.g., 0 counter-examples = warning).
- **Dependency**: KABSD-FTR-0056 (Reference Inspector Implementation).

# Worklog

2026-01-22 14:48 [agent=antigravity] Created item
2026-01-22 14:49 [agent=antigravity] Filled in Ready gate fields
2026-01-22 14:48 [agent=antigravity] Filled in Ready gate requirements
