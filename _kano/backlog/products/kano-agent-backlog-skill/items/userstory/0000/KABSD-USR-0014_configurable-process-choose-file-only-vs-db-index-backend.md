---
id: KABSD-USR-0014
uid: 019b8f52-9f48-76b8-9dc8-4f30158a09f7
type: UserStory
title: 'Configurable process: choose file-only vs DB index backend'
state: Done
priority: P3
parent: KABSD-FTR-0007
area: storage
iteration: null
tags:
- config
- db
- index
created: 2026-01-05
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
original_type: UserStory
---

# Context

Indexing should be optional. Projects should be able to stay file-only (file-first).

# Goal

As a user, I want config to enable/disable DB indexing and choose the backend so the skill remains local-first by default.

# Non-Goals

# Approach

- Add config keys under `_kano/backlog/_config/config.json`.
- Default is disabled or file-only (no DB).
- Ensure scripts validate config types.

# Links

- Feature: [[KABSD-FTR-0007_optional-db-index-and-embedding-rag-pipeline|KABSD-FTR-0007 Optional DB index and embedding/RAG pipeline]]
- Task: [[_kano/backlog/items/task/0000/KABSD-TSK-0048_add-config-keys-for-db-index-backend-selection|KABSD-TSK-0048 Add config keys for DB index backend selection]]

# Alternatives

# Acceptance Criteria

- Config schema documents the index settings and defaults.
- Validation script passes with both disabled and enabled configurations.

# Risks / Dependencies

# Worklog

2026-01-05 08:30 [agent=codex] Created from template.
2026-01-05 08:42 [agent=codex] Auto-sync from child KABSD-TSK-0048 -> Planned.
2026-01-05 08:42 [agent=codex] Auto-sync from child KABSD-TSK-0048 -> InProgress.
2026-01-05 08:45 [agent=codex] Auto-sync from child KABSD-TSK-0048 -> Done.
