---
id: KABSD-FTR-0008
type: Feature
title: "Identifier strategy and ID resolver (ADR-0003)"
state: Proposed
priority: P3
parent: KABSD-EPIC-0003
area: infra
iteration: null
tags: ["id", "uid", "resolver", "adr-0003"]
created: 2026-01-06
updated: 2026-01-06
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
original_type: Feature
---

# Context

ADR-0003 defines the local-first identifier strategy. This Feature groups all follow-up work needed to make
multi-agent / multi-branch backlog creation safe and referencable:
- immutable `uid` for uniqueness
- display `id` for readability (may collide)
- resolver + collision report UX/tooling

# Goal

Ship a consistent identifier and reference story for the backlog system, without requiring a centralized server.

# Non-Goals

- Switching to DB-first source of truth.
- Forcing a renumber/rename workflow for every `id` collision.

# Approach

- Keep Markdown as source of truth.
- Use derived index (SQLite) to support fast resolution and disambiguation.
- Provide resolver spec + collision report CLI + migration plan for adding `uid` to existing items.

# Alternatives

# Acceptance Criteria

- A migration plan exists to add `uid` to existing items without renaming files.
- A resolver spec exists and is compatible with file-first + optional SQLite index.
- A collision report and resolver CLI spec exists for ambiguous `id` references.

# Risks / Dependencies

- Requires careful UX to avoid confusing humans when `id` collisions occur.
- Needs alignment with index layer in `KABSD-FTR-0007`.

# Links

- ADR: [[_kano/backlog/decisions/ADR-0003_identifier-strategy-for-local-first-backlog|ADR-0003 Identifier strategy]]
- Task: [[KABSD-TSK-0059_ulid-vs-uuidv7-comparison|KABSD-TSK-0059 ULID vs UUIDv7 comparison]]
- Task: [[KABSD-TSK-0060_migration-plan-add-uid-to-existing-items|KABSD-TSK-0060 Migration plan: add uid to existing items]]
- Task: [[KABSD-TSK-0061_id-resolver-spec-and-design|KABSD-TSK-0061 ID resolver spec and design]]
- Task: [[KABSD-TSK-0062_collision-report-and-resolver-cli|KABSD-TSK-0062 Collision report and resolver CLI]]

# Worklog

2026-01-06 08:35 [agent=codex-cli] Created feature for ADR-0003 follow-ups (uid strategy + resolver).
2026-01-06 08:42 [agent=codex-cli] Populated scope and re-parented ADR-0003 tasks (0059-0062) under this feature.
