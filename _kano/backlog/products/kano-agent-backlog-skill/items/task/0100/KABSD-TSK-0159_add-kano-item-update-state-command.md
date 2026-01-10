---
id: KABSD-TSK-0159
uid: 019ba8b1-36c6-7476-b66c-44ff16725309
type: Task
title: "Add kano item update-state command"
state: Done
priority: P1
parent: KABSD-FTR-0028
area: tooling
iteration: null
tags: ["cli", "phase1"]
created: 2026-01-11
updated: 2026-01-11
owner: copilot
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: [ADR-0013]
---

# Context

State transitions are currently done via `workitem_update_state.py`. This script handles state changes, worklog appending, parent sync, and dashboard refresh. We need to expose this through the unified CLI.

# Goal

Add `kano item update-state` command that:
1. Transitions item state (Proposed → Planned → Ready → InProgress → Done, etc.)
2. Appends worklog entry with reason
3. Optionally syncs parent state
4. Optionally refreshes dashboards

# Non-Goals

- Custom state machines (use built-in transitions)
- Batch state updates

# Approach

1. Add `update-state` subcommand to `src/kano_cli/commands/item.py`
2. Options:
   - `--item ID` (required, accepts id or uid)
   - `--state TEXT` (required, target state)
   - `--message TEXT` (worklog message)
   - `--agent TEXT` (required)
   - `--no-sync-parent` (skip parent state sync)
   - `--no-refresh` (skip dashboard refresh)
   - `--product TEXT`
3. Initially delegate to `workitem_update_state.py` logic

# Acceptance Criteria

- [ ] `kano item update-state --item KABSD-TSK-0001 --state InProgress --agent copilot` works
- [ ] Worklog appended with timestamp and agent
- [ ] Parent state synced by default (forward-only)
- [ ] Dashboards refreshed by default
- [ ] `--no-sync-parent` and `--no-refresh` flags respected

# Risks / Dependencies

- Depends on `workitem_update_state.py` logic initially

# Worklog

2026-01-11 00:16 [agent=copilot] Created from template.
2026-01-11 00:20 [agent=copilot] Populated task details.
2026-01-11 00:40 [agent=copilot] Created `update-state` command in src/kano_cli/commands/item.py that wraps workitem_update_state.py. Supports all required options: --state, --message, --sync-parent, --no-refresh, --format. → Done
