---
id: KABSD-TSK-0152
uid: 019ba6e7-cbe4-734b-b9d0-8d3bd8d4eba3
type: Task
title: "Resolve workset directory layout inconsistency"
state: Done
priority: P1
parent: KABSD-FTR-0013
area: general
iteration: null
tags: ["workset", "architecture", "consistency"]
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
decisions: ["ADR-0011"]
---

# Context

Workset directory layout references were inconsistent:

- `KABSD-FTR-0013` described `.cache/worksets/<agent_id>/<item_id>/`
- `KABSD-FTR-0015` described `.cache/worksets/<item-id>/`
- ADR-0011 described `_kano/backlog/.cache/worksets/<item-id>/` (and did not require per-agent subfolders)

This inconsistency affects:

1. `workset_init.py` directory creation logic
2. `workset_cleanup.py` TTL cleanup scope
3. multi-agent isolation expectations

# Goal

Choose and document a single Workset directory layout and make docs consistent.

# Non-Goals

- Do not implement Workset scripts here (tracked under FTR-0013 / FTR-0015).
- Do not address multi-agent conflict prevention (tracked elsewhere).

# Approach

1. Evaluate candidate layouts:
   - Option A: `.cache/worksets/<item-id>/` (simple, but less isolated)
   - Option B: `.cache/worksets/<agent_id>/<item_id>/` (more isolation, more complexity)
2. Decision considerations:
   - Local-first default typically assumes one active agent per item
   - If multiple agents are used, conflict/locking should be handled by a dedicated mechanism
3. Update ADR-0011 (and related docs) with an explicit directory layout section.
4. Update FTR-0013 / FTR-0015 descriptions to match.

# Alternatives

1. Keep `<item-id>` only: simplest and matches existing ADR wording.
2. Adopt `<agent_id>/<item-id>`: better isolation but adds operational complexity.
3. Hybrid via config: flexible but increases surface area.

# Acceptance Criteria

- [x] ADR-0011 includes an explicit Workset directory layout decision (Decision date: 2026-01-10)
- [x] FTR-0013 description matches ADR (uses `_kano/backlog/.cache/worksets/<item-id>/`)
- [x] FTR-0015 description matches ADR
- [x] Workset status guide updated to reflect the decision

# Risks / Dependencies

1. **Risk**: if we later need true multi-agent isolation, the layout may need to evolve.
   - Mitigation: keep `--cache-root` and/or an optional agent namespace as a future extension.
2. **Dependency**: ADR acceptance should be done first (TSK-0151).

# Worklog

2026-01-10 15:56 [agent=copilot] Created from template.
2026-01-10 15:59 [agent=copilot] Populated Ready gate content based on Workset review findings.
2026-01-10 16:20 [agent=copilot] Updated ADR-0011 + FTR-0013 + Workset guide to lock `_kano/backlog/.cache/worksets/<item-id>/` layout. Task complete.
