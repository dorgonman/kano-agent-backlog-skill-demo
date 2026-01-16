---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0213
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: null
priority: P2
state: Done
tags: []
title: Fix view refresh VcsMeta branch mismatch
type: Task
uid: 019bc4d3-a221-72bf-b71a-31c0b5b7cea5
updated: 2026-01-16
---

# Context

View refresh fails with 'VcsMeta.__init__() got an unexpected keyword argument branch' after recent changes, blocking dashboard regeneration.

# Goal

Allow view refresh to complete by making VcsMeta construction tolerant of branch/revno/hash fields.

# Approach

Add backward-compatible fields and post-init mapping in kano_backlog_core.vcs.base.VcsMeta so callers that pass branch/revno/hash can still instantiate; preserve existing revision/ref semantics.

# Acceptance Criteria

- view refresh runs without VcsMeta branch errors.\n- Existing VCS metadata fields (revision/ref) remain intact.

# Risks / Dependencies

- Incorrect mapping could degrade metadata clarity; keep defaults conservative.

# Worklog

2026-01-16 11:22 [agent=codex] [model=unknown] Created item
2026-01-16 11:22 [agent=codex] [model=GPT-5.2-Codex] Start fixing VcsMeta branch mismatch.
2026-01-16 11:23 [agent=codex] [model=GPT-5.2-Codex] Added compatibility fields and post-init mapping to core VcsMeta to accept branch/revno/hash without errors.
2026-01-16 11:23 [agent=codex] [model=GPT-5.2-Codex] Resolved VcsMeta branch mismatch; view refresh succeeds.
