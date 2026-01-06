---
id: KABSD-FTR-0007
uid: 019b8f52-9fe9-77b5-8c14-aa03c2501d0f
type: Feature
title: Optional DB index and embedding/RAG pipeline
state: Done
priority: P3
parent: KABSD-EPIC-0003
area: storage
iteration: null
tags:
- db
- index
- sqlite
- postgres
- embedding
- rag
created: 2026-01-05
updated: 2026-01-06
owner: antigravity
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

We want to explore reducing file count and improving query/retrieval for backlog
items. Two related directions:

1) Keep files as the source of truth, but build an optional DB index for fast
   queries and cross-cutting views.
2) Build a derivative embedding index (vector store) to improve context
   retrieval (RAG) for agent collaboration.

This repo should preserve the local-first, human-editable workflow by default.

# Goal

- Provide an optional, rebuildable DB index backend (SQLite first; Postgres optional)
  while keeping file-based items as the system of record.
- Provide an optional embedding pipeline as a derivative index (rebuildable).
- Keep Obsidian usability for the default file-first mode.

# Non-Goals

- Replacing file-based items as the default source of truth.
- Shipping a full web UI.
- Building a production-grade vector database integration in the first iteration.

# Approach

- Define a DB schema that can represent items, links, worklog entries, and ADR links.
- Implement a SQLite indexer that can rebuild from files and optionally do incremental updates.
- Add config knobs to enable/disable indexing and select backend.
- Keep views file-based by default; optionally generate Markdown dashboards from DB queries.
- Treat embeddings as derivative: regenerate from file content and/or DB rows.

# Links

- UserStory: [[KABSD-USR-0012_index-file-based-backlog-into-sqlite-rebuildable|KABSD-USR-0012 Index file-based backlog into SQLite (rebuildable)]]
- UserStory: [[KABSD-USR-0013_index-file-based-backlog-into-postgres-optional|KABSD-USR-0013 Index file-based backlog into Postgres (optional)]]
- UserStory: [[KABSD-USR-0014_configurable-process-choose-file-only-vs-db-index-backend|KABSD-USR-0014 Configurable process: choose file-only vs DB index backend]]
- UserStory: [[KABSD-USR-0015_generate-embeddings-for-backlog-items-derivative-index|KABSD-USR-0015 Generate embeddings for backlog items (derivative index)]]
- UserStory: [[KABSD-USR-0016_db-index-views-query-db-and-render-markdown-dashboards|KABSD-USR-0016 DB-index views: query DB and render Markdown dashboards]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0049_document-file-first-db-index-architecture-and-trade-offs|KABSD-TSK-0049 Document file-first + DB index architecture and trade-offs]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0050_document-index-config-artifact-paths-and-rebuild-workflow|KABSD-TSK-0050 Document index config, artifact paths, and rebuild workflow]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0051_extend-validate-userstories-to-cover-db-index-and-embeddings-stories|KABSD-TSK-0051 Extend validate_userstories to cover DB index and embeddings stories]]

# Alternatives
Note: DB-first (DB as source of truth) is explicitly out of scope for this feature; it would require replacing Obsidian/file-based views with new UI/export tooling.


- DB-first CRUD (would require replacing Obsidian-centric workflows with new views/UI).
- Stay file-only and rely on grep/Dataview for everything.

# Acceptance Criteria

- User stories exist for SQLite index, optional Postgres, config selection, embedding pipeline, and DB-rendered views.
- Clear docs/ADR capture the trade-offs and the default remains file-first.

# Risks / Dependencies

- Drift between file content and DB index if incremental updates are buggy.
- Added complexity may reduce approachability for simple projects.
- DB-first paths would require rethinking dashboards/views.

# Worklog

2026-01-05 08:30 [agent=codex] Created from template.
2026-01-05 08:42 [agent=codex] Auto-sync from child KABSD-TSK-0048 -> Planned.
2026-01-05 08:42 [agent=codex] Auto-sync from child KABSD-TSK-0048 -> InProgress.

2026-01-05 08:45 [agent=codex] Clarified direction: file-first is the default source of truth; DB index and embeddings are opt-in via config; DB-first is out of scope.
2026-01-06 08:34 [agent=codex-cli] Re-parented Feature from KABSD-EPIC-0001 to KABSD-EPIC-0003 for milestone 0.0.2.
2026-01-06 13:01 [agent=antigravity] Starting SQLite index implementation.
2026-01-06 20:58 [agent=antigravity] Implemented index_db.py and integrated SQLite with lib.index.
