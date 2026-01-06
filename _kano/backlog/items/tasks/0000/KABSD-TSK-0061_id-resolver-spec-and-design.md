---
id: KABSD-TSK-0061
uid: 019b8f52-9fd2-7cb5-b172-73748a976830
type: Task
title: ID resolver spec and design
state: Done
priority: P3
parent: KABSD-FTR-0008
area: infra
iteration: null
tags:
- resolver
- uid
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
  blocks:
  - KABSD-TSK-0062
  blocked_by: []
decisions:
- ADR-0003
---

# Context

ADR-0003 requires tools to implement `ResolveRef(ref)` for reference handling. This task defines the resolver specification.

# Goal

Design and document the ID resolver specification:
- Full `uid` resolution (unique match)
- `uidshort` resolution via index
- Display `id` resolution (may return multiple matches)
- Ambiguity handling (list candidates for selection)
- Human-friendly format: `ID@uidshort`

# Non-Goals

- Full implementation (separate task)
- UI design (CLI only in first iteration)

# Approach

- Define ResolveRef(ref) function signature and behavior
- Document index requirements (`uid -> path`, `uidshort -> uid`, `id -> [uid...]`)
- Specify disambiguation output format
- Consider integration with existing skill scripts

# Links

- ADR: [[_kano/backlog/decisions/ADR-0003_identifier-strategy-for-local-first-backlog|ADR-0003 Identifier strategy]]
- Feature: [[KABSD-FTR-0008_identifier-strategy-and-id-resolver-adr-0003|KABSD-FTR-0008 Identifier strategy and ID resolver (ADR-0003)]]

# Alternatives

# Acceptance Criteria

- Resolver spec document with function signature and behavior
- Index schema requirements documented
- Disambiguation logic specified

# Risks / Dependencies

- Depends on index implementation (KABSD-FTR-0007)

# Worklog

2026-01-06 00:36 [agent=antigravity] Created task to address ADR-0003 resolver semantics design.
2026-01-06 01:40 [agent=antigravity] Created ID Resolver spec: ADR-0003-appendix_id-resolver-spec.md with ResolveRef() function, index requirements, disambiguation logic.
2026-01-06 08:42 [agent=codex-cli] Re-parented Task from KABSD-FTR-0001 to KABSD-FTR-0008 to align with milestone 0.0.2 scope.
