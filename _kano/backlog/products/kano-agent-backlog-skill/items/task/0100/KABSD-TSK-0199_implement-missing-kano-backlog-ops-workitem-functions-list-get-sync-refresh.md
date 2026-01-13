---
area: tooling
created: '2026-01-14'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0199
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P1
state: Done
tags:
- workitem
- ops
- stubs
title: Implement missing kano_backlog_ops.workitem functions (list/get/sync/refresh)
type: Task
uid: 019bb87a-e883-7613-9741-3de712cc5d7c
updated: 2026-01-14
---

# Context

The snapshot report shows unfinished workitem ops in `skills/kano-agent-backlog-skill/src/kano_backlog_ops/workitem.py`:
- TODO: implement parent sync (UpdateStateResult.parent_synced)
- TODO: implement dashboard refresh (UpdateStateResult.dashboards_refreshed)
- NotImplementedError: list_items
- NotImplementedError: get_item

These block using the ops layer as the single authoritative implementation for kano-backlog CLI workitem operations.

Reference snapshot: `_kano/backlog/products/kano-agent-backlog-skill/views/snapshots/snapshot.all.20260114T004451.md`.

# Goal

Complete the missing workitem ops functions so kano-backlog CLI can:
- list items deterministically with filters
- resolve item references (id/uid/path)
- optionally sync parent state forward-only
- optionally refresh dashboards after state changes

# Approach

1. Implement `list_items()` using the canonical store (read Markdown SSOT, deterministic ordering), with filters:
   - item_type, state, parent, tags (AND)
2. Implement `get_item()` to resolve:
   - path => read
   - display id => filename prefix match then read
   - uid => scan frontmatter for uid then read
   and fail fast on missing/ambiguous refs.
3. Implement parent sync (forward-only):
   - when a child enters InProgress/Review/Blocked => ensure parent is at least InProgress
   - when a child enters Done/Dropped => if all siblings are Done/Dropped => move parent to Done
   - never move parent backward
4. Implement dashboard refresh by calling the native `kano_backlog_ops.view.refresh_dashboards()` (no subprocess).
5. Add/adjust unit tests and regenerate a snapshot to confirm stubs are gone.

# Acceptance Criteria

- `kano_backlog_ops.workitem.list_items` no longer raises NotImplementedError and returns deterministic results.
- `kano_backlog_ops.workitem.get_item` resolves id/uid/path correctly.
- `update_state(..., sync_parent=True)` can move parent forward-only and records parent_synced=true when it changes a parent.
- `update_state(..., refresh_dashboards=True)` refreshes dashboards and records dashboards_refreshed=true.
- A new snapshot no longer lists the workitem stubs from `workitem.py`.

# Risks / Dependencies

- Risk: parent sync semantics differ from legacy scripts. Mitigation: keep behavior minimal + forward-only, document in Worklog.
- Risk: scanning for uid could be slow. Mitigation: only used on demand; keep scan limited to items/.

# Worklog

2026-01-14 01:50 [agent=codex-cli] Created item
2026-01-14 01:50 [agent=codex-cli] [model=gpt-5.2] State: Proposed → Ready: Ready: captured snapshot-driven workitem ops stubs, approach, and acceptance criteria.
2026-01-14 01:50 [agent=codex-cli] [model=gpt-5.2] State: Ready → InProgress: Start: implement list_items/get_item plus parent sync + dashboard refresh in kano_backlog_ops.workitem.
2026-01-14 02:09 [agent=codex-cli] [model=gpt-5.2] Done: implemented kano_backlog_ops.workitem list_items/get_item + update_state parent sync + dashboard refresh; added unit tests; regenerated product snapshot (all).
