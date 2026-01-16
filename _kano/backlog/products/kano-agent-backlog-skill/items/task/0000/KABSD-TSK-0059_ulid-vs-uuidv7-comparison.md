---
id: KABSD-TSK-0059
uid: 019b8f52-9fce-7a88-8aa4-e565207669f8
type: Task
title: ULID vs UUIDv7 comparison document
state: Done
priority: P3
parent: KABSD-FTR-0008
area: docs
iteration: null
tags:
- docs
- uid
- ulid
- uuidv7
- adr-0003
created: 2026-01-06
updated: 2026-01-06
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates:
  - ADR-0003
  blocks:
  - KABSD-TSK-0060@019b8f52
  blocked_by: []
decisions:
- ADR-0003
---

# Context

ADR-0003 proposes a hybrid identifier strategy with `uid` as the immutable key. We need to choose between ULID and UUIDv7 as the `uid` format.

# Goal

Write a comparison document evaluating ULID vs UUIDv7 for use as the `uid` field, covering:
- Sorting characteristics (lexicographic vs binary)
- Human readability (Base32 vs hex)
- Library support (Python, JavaScript, Go, etc.)
- Collision safety and entropy
- Short-prefix length recommendations for `uidshort`

# Non-Goals

- Implementing the chosen format (separate task)
- Migrating existing items (KABSD-TSK-0060)

# Approach

- Research both formats and document trade-offs
- Provide a recommendation with rationale
- Optionally propose as ADR amendment or new ADR

# Links

- ADR: [[_kano/backlog/decisions/ADR-0003_identifier-strategy-for-local-first-backlog|ADR-0003 Identifier strategy]]
- Feature: [[KABSD-FTR-0008_identifier-strategy-and-id-resolver-adr-0003|KABSD-FTR-0008 Identifier strategy and ID resolver (ADR-0003)]]

# Alternatives

# Acceptance Criteria

- Comparison document exists with clear recommendation
- Document is linked from ADR-0003 or replaces Open Question #1

# Risks / Dependencies

- May require updating ADR-0003 based on findings

# Worklog

2026-01-06 00:36 [agent=antigravity] Created task to address ADR-0003 Open Question #1.
2026-01-06 01:19 [agent=antigravity] Completed ULID vs UUIDv7 comparison. Recommendation: use ULID.
2026-01-06 01:28 [agent=antigravity] Completed comparison. User chose UUIDv7 (RFC 9562 standardized, future Python native support).
2026-01-06 02:09 [agent=antigravity] Verified ID resolution integration in workitem_update_state.py.
2026-01-06 08:42 [agent=codex-cli] Re-parented Task from KABSD-FTR-0042 to KABSD-FTR-0008 to align with milestone 0.0.2 scope.
