---
id: KABSD-TSK-0005
uid: 019b8f52-9f5a-7769-a3de-8292cd240f21
type: Task
title: Add fs wrappers for demo tools
state: Done
priority: P2
parent: KABSD-USR-0001
area: backlog
iteration: null
tags:
- tools
- fs
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

We want demo-facing tooling under `_kano/backlog/tools/` to delegate all file
operations to skill scripts for consistency.

# Goal

Add cp/mv/rm wrappers in `_kano/backlog/tools/` that call the skill fs scripts.

# Non-Goals

- Add new file semantics beyond copy/move/delete.

# Approach

- Add `_kano/backlog/tools/cp_file.py`, `mv_file.py`, `rm_file.py`.
- Each wrapper should call the corresponding `skills/.../scripts/fs/*.py` file.

# Alternatives

- Call OS commands directly (less consistent, harder to standardize).

# Acceptance Criteria

- Running `_kano/backlog/tools/cp_file.py` invokes the skill script.
- Running `_kano/backlog/tools/mv_file.py` invokes the skill script.
- Running `_kano/backlog/tools/rm_file.py` invokes the skill script.

# Risks / Dependencies

- Wrapper path assumptions must match repo layout.
# Worklog

2026-01-04 09:39 [agent=codex] Created task for cp/mv/rm wrappers in demo tools.
2026-01-04 09:39 [agent=codex] Started adding cp/mv/rm wrappers in demo tools.
2026-01-04 09:40 [agent=codex] Added cp/mv/rm wrappers in _kano/backlog/tools.
