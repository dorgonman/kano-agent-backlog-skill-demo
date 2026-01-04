---
id: KABSD-TSK-0009
type: Task
title: "Implement backlog scaffold initializer script"
state: Proposed
priority: P2
parent: KABSD-USR-0004
area: skill
iteration: null
tags: ["scripts", "bootstrap"]
created: 2026-01-04
updated: 2026-01-04
owner: null
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

We need a repeatable script that scaffolds `_kano/backlog/` so new repos can
bootstrap the backlog without manual folder creation.

# Goal

Implement a script that creates the standard backlog structure and required
meta files in a safe, idempotent way.

# Non-Goals

- Seeding demo items or views (handled separately).
- Modifying existing backlog content beyond minimal scaffolding.

# Approach

- Add `scripts/backlog/init_backlog.py`.
- Create folders: `_kano/backlog/{items,decisions,views,_meta,tools}`.
- Write baseline files (`_meta/indexes.md`, README.md) if missing.
- Provide flags for root path and dry-run behavior.

# Alternatives

- Manual folder creation and copy/paste setup.

# Acceptance Criteria

- Script creates missing folders and baseline files without errors.
- Re-running the script is safe and does not overwrite existing content.
- Supports custom root via CLI flags.

# Risks / Dependencies

- Existing repos may need manual adjustments if layout differs.

# Worklog

2026-01-04 13:51 [agent=codex] Created task for backlog scaffold initializer script.
2026-01-04 13:55 [agent=codex] Added scope and acceptance criteria for the initializer script.
