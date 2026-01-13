---
id: KABSD-FTR-0035
uid: 019bae58-b5d0-71b8-80e1-00e9e8be129a
type: Feature
title: "Restructure Command Tree with Consistent Domain Naming"
state: Done
priority: P2
parent: KABSD-EPIC-0009
area: cli
iteration: backlog
tags: ['refactor', 'ux']
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

The initial CLI implementation had a flat or inconsistent command structure. As the skill grows, we need a logical domain-driven hierarchy for commands to improve discoverability and usability.
Users were confused by overlapping commands or unclear entry points (e.g., mixing admin setup with daily item management).

# Goal

1. Restructure the CLI into clear domain groups: `admin`, `item`, `view`, `topic`, `doctor`.
2. Ensure consistent naming conventions for subcommands.
3. Remove or alias legacy flat commands.

# Approach

1. **Define Command Groups**:
   - `admin`: Setup, init, scaffolding (e.g., `admin init`).
   - `item`: Work item management (create, update, list).
   - `topic`: Topic & materials management (create, switch, add).
   - `view`: Dashboard generation and refreshment.
   - `doctor`: Health checks.

2. **Refactor `kano_backlog_cli`**:
   - Create `commands/` submodule.
   - Move implementations into `commands/<domain>.py`.
   - Use `typer` to compose groups.

# Acceptance Criteria

- [x] CLI supports `kano-backlog admin ...`
- [x] CLI supports `kano-backlog item ...`
- [x] CLI supports `kano-backlog topic ...`
- [x] CLI help (`--help`) shows clear hierarchy.
- [x] Legacy commands are removed or deprecated.

# Risks / Dependencies

- Users accustomed to old commands will need to learn new paths (mitigated by `--help` and docs).

# Worklog

2026-01-12 02:36 [agent=copilot] Created item
2026-01-12 06:56 [agent=copilot] Done: all command tree restructuring complete (item→workitem, backlog→admin). All tasks (TSK-0180, TSK-0181, TSK-0182) finished.
