---
id: KABSD-FTR-0034
uid: 019bae58-a4a3-7363-9695-2b1108ad21ac
type: Feature
title: "Rename CLI and Python Packages to Skill-Scoped Names"
state: Done
priority: P2
parent: KABSD-EPIC-0009
area: cli
iteration: backlog
tags: ['refactor', 'breaking-change']
created: 2026-01-12
updated: 2026-01-12
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

The project previously used generic names like `kano_cli` and `kano_ops` which conflict with the intention of reserving the `kano` namespace for a future global umbrella tool (see ADR-0015).
To make this skill a self-contained, composable unit ("kano-agent-backlog-skill"), all its internal packages and entry points must be scoped to the skill.

# Goal

1. Rename the main Python package from `kano_cli` to `kano_backlog_cli`.
2. Rename the operations package from `kano_ops` to `kano_backlog_ops`.
3. Update all import references in the codebase.
4. Update the CLI entry point script to `kano-backlog` (with `kano` as a convenience alias *within* the skill dev environment only).

# Approach

1. **Package Rename**:
   - Move `src/kano_cli` -> `src/kano_backlog_cli`
   - Move `src/kano_ops` -> `src/kano_backlog_ops`

2. **Script Rename**:
   - `scripts/kano` -> `scripts/kano-backlog`
   - Keep `scripts/kano` as a symlink or wrapper for backwards compatibility/dev convenience if needed, but primary is `kano-backlog`.

3. **Refactoring**:
   - Search and replace all `from kano_cli` -> `from kano_backlog_cli`
   - Search and replace all `from kano_ops` -> `from kano_backlog_ops`

# Acceptance Criteria

- [x] No `src/kano_cli` or `src/kano_ops` directories exist.
- [x] `src/kano_backlog_cli` and `src/kano_backlog_ops` exist and are importable.
- [x] CLI command `python skills/.../scripts/kano-backlog` works.
- [x] Developer doctor/validation tools confirm no legacy packages remain.

# Risks / Dependencies

- **Breaking Change**: Any external scripts relying on `kano_cli` imports will break.
- **Merge Conflicts**: ongoing work in other branches might re-introduce old imports.

# Worklog

2026-01-12 02:36 [agent=copilot] Created item
2026-01-13 01:58 [agent=antigravity] Update state to Done (Reconciling Ghost Work: implementation verified in codebase).
