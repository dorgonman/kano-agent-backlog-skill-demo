---
id: KABSD-TSK-0062
uid: 019b8f52-9fd5-72cf-a484-a9b43d381511
type: Task
title: Collision report and resolver CLI
state: Done
priority: P3
parent: KABSD-FTR-0001
area: tooling
iteration: null
tags:
- cli
- resolver
- collision
- adr-0003
created: 2026-01-06
updated: '2026-01-06'
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates:
  - ADR-0003
  blocks: []
  blocked_by:
  - KABSD-TSK-0061
decisions:
- ADR-0003
---

# Context

ADR-0003 mentions the need for a collision report and resolver UI/CLI to handle display ID ambiguity.

# Goal

Implement tooling for collision detection and resolution:
- Collision report: group items by display `id`, show duplicates
- Resolver CLI: interactive disambiguation when multiple items share the same `id`
- Integration with existing skill scripts

# Non-Goals

- Web UI (CLI only)
- Automatic resolution (human selection required)

# Approach

- Add `collision_report.py` script to list id collisions
- Add resolver functionality to existing scripts or new `resolve_ref.py`
- Output format: `id`, `uid`, `uidshort`, `type`, `state`, `title`, `path`
- Interactive mode for disambiguation

# Links

- ADR: [[_kano/backlog/decisions/ADR-0003_identifier-strategy-for-local-first-backlog|ADR-0003 Identifier strategy]]
- Feature: [[KABSD-FTR-0001_local-backlog-system|KABSD-FTR-0001 Local-first backlog system]]
- Blocked by: [[KABSD-TSK-0061_id-resolver-spec-and-design|KABSD-TSK-0061 ID resolver spec]]

# Alternatives

# Acceptance Criteria

- `collision_report.py` exists and outputs grouped duplicates
- Resolver CLI can take ambiguous ref and prompt for selection
- Scripts integrated into skill `scripts/backlog/`

# Risks / Dependencies

- Depends on KABSD-TSK-0061 (resolver spec)
- Requires items to have `uid` field (post-migration)

# Worklog

2026-01-06 00:36 [agent=antigravity] Created task to address ADR-0003 Open Question #4.
2026-01-06 01:44 [agent=antigravity] Created collision report and resolver CLI spec: ADR-0003-appendix_collision-report-cli-spec.md
