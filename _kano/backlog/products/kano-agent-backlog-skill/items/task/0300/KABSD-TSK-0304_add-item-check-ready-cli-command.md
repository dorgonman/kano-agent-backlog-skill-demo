---
id: KABSD-TSK-0304
uid: 019bf654-a73e-7077-82d1-30591e72fec8
type: Task
title: "Add item check-ready CLI command"
state: Done
priority: P2
parent: KABSD-FTR-0059
area: general
iteration: backlog
tags: []
created: 2026-01-26
updated: 2026-01-26
owner: opencode
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

Agents and users need a way to manually check if an item meets the Ready gate criteria before starting work or creating child items. Currently there's no CLI command to validate Ready gate, forcing manual inspection of markdown files.

# Goal

Add `kano-backlog item check-ready <ID>` CLI command that validates Ready gate fields and optionally checks parent Ready gate.

# Approach

1. Add `check-ready` subcommand to `kano-backlog item` command group
2. Load item by ID and call `is_ready()` from core
3. If parent is not null and `--no-check-parent` not specified, also check parent
4. Print clear success/failure message with list of missing fields
5. Exit code 0 for ready, 1 for not ready
6. Support `--format json` for structured output
7. Add integration tests

# Acceptance Criteria

- `kano-backlog item check-ready KABSD-TSK-0001` validates item and reports status
- `kano-backlog item check-ready KABSD-TSK-0001 --no-check-parent` skips parent check
- Command prints clear error message listing missing fields when not ready
- Command exits with code 0 when ready, 1 when not ready
- `--format json` returns structured output: `{"ready": true/false, "missing_fields": [...], "parent_ready": true/false/null}`
- Integration tests cover: ready item, non-ready item, null parent, non-null parent, --no-check-parent flag

# Risks / Dependencies

**Risks**:
- Error messages might be unclear (mitigate: test with real examples, iterate on wording)
- JSON format might not include all needed info (mitigate: start simple, extend based on usage)

**Dependencies**:
- KABSD-TSK-0305 (is_ready function) must be implemented first
- Item loading infrastructure must be stable

# Worklog

2026-01-26 02:05 [agent=opencode] Created item

2026-01-26 06:44 [agent=opencode] State -> InProgress.
2026-01-26 06:48 [agent=opencode] State -> Done.
