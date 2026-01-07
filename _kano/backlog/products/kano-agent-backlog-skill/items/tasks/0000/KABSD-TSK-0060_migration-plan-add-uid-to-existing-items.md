---
id: KABSD-TSK-0060
uid: 019b8f52-9fd0-7c50-9d2b-46aa5e89d346
type: Task
title: 'Migration plan: add uid to existing items'
state: Done
priority: P3
parent: KABSD-FTR-0008
area: infra
iteration: null
tags:
- migration
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
  blocks: []
  blocked_by:
  - KABSD-TSK-0059@019b8f52
decisions:
- ADR-0003
---

# Context

ADR-0003 introduces a `uid` field for immutable, globally unique references. Existing items only have `id` (display ID). We need a migration plan to add `uid` to all items.

# Goal

Define and document the migration plan for adding `uid` to existing backlog items:
- Generate `uid` for each item (using chosen format from KABSD-TSK-0059)
- Add `uid` to frontmatter (filename remains unchanged per ADR-0003 decision)
- Optionally add `parent_uid` and `links_uid` for reference stability

# Non-Goals

- Renaming files (decision: filename format stays as `<id>_<slug>.md`)
- Full implementation (this is the plan, not execution)

# Approach

- Write migration script specification
- Define rollback strategy
- Document backward compatibility (tools must handle items with/without uid)
- Define validation checks post-migration

# Links

- ADR: [[_kano/backlog/decisions/ADR-0003_identifier-strategy-for-local-first-backlog|ADR-0003 Identifier strategy]]
- Feature: [[KABSD-FTR-0008_identifier-strategy-and-id-resolver-adr-0003|KABSD-FTR-0008 Identifier strategy and ID resolver (ADR-0003)]]
- Blocked by: [[KABSD-TSK-0059_ulid-vs-uuidv7-comparison|KABSD-TSK-0059 ULID vs UUIDv7 comparison]]

# Alternatives

# Acceptance Criteria

- Migration plan document exists with clear steps
- Script specification covers uid generation and frontmatter update
- Backward compatibility strategy documented

# Risks / Dependencies

- Depends on KABSD-TSK-0059 (uid format decision)
- Large number of files to update

# Worklog

2026-01-06 00:36 [agent=antigravity] Created task to address ADR-0003 Open Question #2. Scope adjusted: uid in frontmatter only, filename unchanged.
2026-01-06 01:36 [agent=antigravity] Created migration plan document ADR-0003-appendix_migration-plan-uid.md with UUIDv7 schema, phases, and backward compatibility strategy.
2026-01-06 08:42 [agent=codex-cli] Re-parented Task from KABSD-FTR-0001 to KABSD-FTR-0008 to align with milestone 0.0.2 scope.
