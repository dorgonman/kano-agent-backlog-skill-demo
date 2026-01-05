---
id: KABSD-TSK-0004
uid: 019b8f52-9f58-785b-8485-7786aa4fa054
type: Task
title: Add trash bin tool for backlog files
state: Done
priority: P2
parent: KABSD-USR-0001
area: backlog
iteration: null
tags:
- tools
- cleanup
created: 2026-01-04
updated: '2026-01-06'
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

Some backlog files can be locked by the OS/editor, preventing rename or delete.
We need a safe, repeatable workflow to move files to a trash area and attempt
cleanup while leaving a manual fallback.

# Goal

Provide a small tool that moves/copies a target file into a trash bin, then
attempts deletion and reports when manual cleanup is needed.

# Non-Goals

- Implement OS-level lock detection.
- Delete entire directories recursively.

# Approach

- Add `skills/kano-agent-backlog-skill/scripts/fs/trash_item.py`.
- Keep `_kano/backlog/tools/trash_item.py` aligned for demo use.
- Use a timestamped folder under `_kano/backlog/_trash/`.
- Attempt move; fall back to copy; then try delete with clear messaging.

# Alternatives

- Ask humans to delete locked files manually every time.

# Acceptance Criteria

- Command accepts a file path and a trash root.
- If move fails, the script exits with an error (no copy fallback).
- If deletion fails, the script prints a manual action reminder.

# Risks / Dependencies

- Locked files may still prevent moves/deletes on Windows.
# Worklog

2026-01-04 09:22 [agent=codex] Created task for backlog trash bin tooling.
2026-01-04 09:22 [agent=codex] Started implementing trash bin tool for locked backlog files.
2026-01-04 09:23 [agent=codex] Added trash_item.py and attempted to trash locked epic files; manual delete required.
2026-01-04 09:34 [agent=codex] Added fs scripts and updated trash behavior to error on move failure.
2026-01-04 09:35 [agent=codex] Updated task plan to reference skill fs scripts and stricter trash behavior.
