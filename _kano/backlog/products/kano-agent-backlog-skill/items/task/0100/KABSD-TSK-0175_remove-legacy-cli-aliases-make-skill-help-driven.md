---
area: cli
created: '2026-01-11'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0175
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: InProgress
tags:
- cli
- docs
title: Remove legacy CLI aliases; make SKILL help-driven
type: Task
uid: 019bacd2-2aa8-74d4-bd69-43c3cbcffac6
updated: 2026-01-11
---

# Context

We want to remove remaining legacy/compatibility CLI aliases and simplify docs so the canonical CLI surface is discovered via --help on-demand.

# Goal

1) No legacy aliases remain in kano CLI. 2) Documentation (SKILL/README/REFERENCE) matches the canonical CLI. 3) Agents can discover commands hierarchically via --help without maintaining long lists.

# Approach

- Remove legacy command registrations and their implementation stubs.\n- Update docs to describe help-driven discovery and keep only a few canonical examples.\n- Verify via kano --help outputs and existing validators.

# Acceptance Criteria

- kano --help does not list legacy aliases (e.g., no top-level init).\n- kano item --help lists only canonical commands (no create-v2).\n- SKILL.md describes help-driven discovery and contains no legacy alias references.\n- kano backlog validate uids passes.

# Risks / Dependencies

- Breaking scripts/automation that relied on legacy aliases; mitigated by updating docs and using canonical commands.

# Worklog

2026-01-11 19:30 [agent=copilot] Created item
2026-01-11 19:35 [agent=copilot] Filled Ready-gate fields to begin implementation.
2026-01-11 19:36 [agent=copilot] Started implementation: remove legacy aliases and simplify help docs.
