---
area: backlog
created: '2026-01-04'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0004
iteration: null
links:
  blocked_by: []
  blocks: []
  relates: []
owner: null
parent: KABSD-USR-0001
priority: P2
state: Done
tags:
- tools
- cleanup
title: Add trash bin tool for backlog files
type: Task
uid: 019b8f52-9f58-785b-8485-7786aa4fa054
updated: '2026-01-06'
---

# Context

When renaming or deleting backlog items, Windows file locks can prevent immediate
deletion. We need a trash bin mechanism so agents can move files instead of deleting
them directly.

# Goal

Provide a `trash_item` function that moves backlog files to a `.trash/` directory
with timestamp and reason metadata.

# Non-Goals

- Implement OS-level lock detection.
- Delete entire directories recursively.

# Approach

- Add `.trash/` directory under `_kano/backlog/`.
- Implement `trash_item(item_ref, reason)` that moves the file and logs metadata.
- CLI command: `kano-backlog item trash <ITEM_ID> --reason "..."`.

# Alternatives

- Ask humans to delete locked files manually every time.

# Acceptance Criteria

- `trash_item()` moves item file to `.trash/` with timestamp prefix.
- Metadata file records original path, timestamp, reason, and agent.
- CLI command works and reports success.

# Risks / Dependencies

- Trash directory may grow large over time (mitigate: add cleanup command later).

# Worklog

2026-01-04 00:41 [agent=codex] Created task for trash bin tool.
2026-01-04 00:46 [agent=codex] Marked Done after implementing trash_item function and CLI.
