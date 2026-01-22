---
area: general
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0271
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: Done
tags: []
title: Close out SQLite indexing + embedding search foundations
type: Task
uid: 019bdda7-be68-74c6-ac33-ac02187bd76c
updated: 2026-01-23
---

# Context

SQLite indexing and embedding/vector search foundations exist, but are not yet 'shippable' as a cohesive workflow. We want to finish the local-first indexing + semantic search experience with clear CLI UX, deterministic paths, minimal drift vs docs, and tests.

# Goal

Deliver an end-to-end local-first workflow: (1) build/refresh SQLite item index, (2) build vector index, (3) run vector search queries, (4) validate/index status. Ensure docs and CLI are aligned; keep features optional and rebuildable.

# Approach

Phase A (SQLite index): align index artifact path with docs/config, add status/query UX to CLI, add minimal schema/migration story (schema_version + rebuild guidance), and add tests for build/refresh determinism. Phase B (Vector/embedding): ensure config templates exist for noop embedding, provide a single command to build vector index, ensure search CLI works without OpenAI, add tests for vector backend and search pipeline using noop embeddings. Phase C (Docs): update references/ and README to reflect exact commands and paths; add a copy/paste workflow section.

# Acceptance Criteria

- CLI: 'kano-backlog admin index build/refresh/status' works for a product and reports counts/paths deterministically. - CLI: 'kano-backlog search query ... --product <name>' works after vector build with noop embeddings (no network). - Tests cover: index build creates expected tables/rows; refresh is deterministic; vector index build writes db; search returns stable results for a fixed corpus. - Docs under skills/kano-agent-backlog-skill/references/ match actual CLI/paths and include agent prompt guidance.

# Risks / Dependencies

- Docs currently mention scripts/indexing/build_sqlite_index.py but code uses CLI admin index; misalignment may confuse users. - Vector search depends on configuration; must provide safe defaults and avoid requiring OpenAI keys.

# Worklog

2026-01-21 07:05 [agent=opencode] Created item
2026-01-21 07:05 [agent=opencode] Start closeout: unify SQLite index + embedding search workflow; capture findings and artifacts in topic index-search-closeout.
2026-01-23 02:13 [agent=kiro] State -> InProgress.
2026-01-23 02:20 [agent=kiro] [model=unknown] Phase A completed: Added index status command with deterministic reporting. Phase B completed: Fixed vector search integration and BacklogItem text extraction. Phase C completed: Updated indexing documentation with current CLI commands. All tests passing for integrated workflow.
2026-01-23 02:20 [agent=kiro] State -> Done.
