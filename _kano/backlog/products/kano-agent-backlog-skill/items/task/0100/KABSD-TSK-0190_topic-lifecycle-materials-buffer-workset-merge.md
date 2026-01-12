---
area: topic
created: '2026-01-13'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0190
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Done
tags: []
title: Topic lifecycle + materials buffer (workset merge)
type: Task
uid: 019bb34d-8c41-739b-8bfd-15d18956ddea
updated: 2026-01-13
---

# Context

We want Topic/Workset to serve as a shared, local-first context buffer: collectors gather raw materials (snippets/logs/links/extracts), synthesizers distill a brief, and only confirmed facts/decisions get published back to WorkItems/ADRs. Current implementation stores topics under .cache/worksets/topics and has no materials/brief/publish lifecycle.

# Goal

Implement Topic as a durable (shareable) buffer with a deterministic brief, raw materials collection, and simple lifecycle gates (collect/distill/publish/close + TTL cleanup), aligned with the agreed folder scheme: _kano/backlog/topics/<topic>/.

# Approach

1) Move topic root to _kano/backlog/topics/<topic>/. 2) Create directories: materials/{clips,links,extracts,logs}, synthesis/, publish/. 3) Replace notes.md with brief.md (deterministic template) and keep manifest.json for refs. 4) Keep active topic pointer per-agent (not versioned). 5) Add minimal CLI: topic show/list, add-snippet, distill, close, cleanup (publish can initially output deterministic patch skeleton). 6) Update ConfigLoader topic override path to match new scheme. 7) Update tests to match new structure and ensure backwards behavior where possible.

# Acceptance Criteria

- Topic create produces _kano/backlog/topics/<name>/ with manifest.json, brief.md, and materials/ subfolders.\n- Topic switch still works via active_topic.<agent>.txt and topic add/pin keep working.\n- Topic supports adding snippet refs (reference-first; optional cached snapshot).\n- A deterministic brief template is generated and distill is repeatable.\n- Cleanup supports TTL deletion of raw materials (and optionally whole topic when closed).\n- Tests cover new paths and key behaviors; pytest passes.

# Risks / Dependencies

- This changes on-disk layout; existing topics in .cache may need migration or be treated as legacy.\n- Keeping active pointer in cache means it remains local per agent (expected).\n- Publish patch generation needs careful scoping to avoid touching source-of-truth unexpectedly.

# Worklog

2026-01-13 01:42 [agent=copilot] Created item
2026-01-13 02:02 [agent=copilot] [model=unknown] Topic lifecycle + materials + config overlays impl (scheme-B); tests green (60 passed)
