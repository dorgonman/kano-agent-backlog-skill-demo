---
id: KABSD-USR-0012
uid: 019b8f52-9f44-74fb-a294-f102b5795be2
type: UserStory
title: Index file-based backlog into SQLite (rebuildable)
state: Done
priority: P3
parent: KABSD-FTR-0007
area: storage
iteration: null
tags:
- db
- index
- sqlite
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
---

# Context

We want fast queries and fewer repo files while keeping work items as human-editable Markdown files.
An optional SQLite index can be rebuilt from files at any time.

# Goal

As a user, I want a rebuildable SQLite index for backlog items so I can query/filter/summarize without relying on Obsidian plugins.

# Non-Goals

# Approach

- Implement an indexer that reads `_kano/backlog/items/**` and persists normalized rows.
- Treat the DB as a cache/index; files remain source of truth.
- Support full rebuild; incremental updates are optional.

# Links

- Feature: [[KABSD-FTR-0007_optional-db-index-and-embedding-rag-pipeline|KABSD-FTR-0007 Optional DB index and embedding/RAG pipeline]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0046_define-db-index-schema-items-links-worklog-decisions|KABSD-TSK-0046 Define DB index schema]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0047_implement-sqlite-indexer-import-rebuild-incremental|KABSD-TSK-0047 Implement sqlite indexer]]

# Alternatives

# Acceptance Criteria

- A script can rebuild the SQLite index from the file backlog.
- The DB schema supports items, links, state, timestamps, tags, and worklog entries.
- Failure modes are safe (rebuildable; does not corrupt source files).

# Risks / Dependencies

# Worklog

2026-01-05 08:30 [agent=codex] Created from template.
2026-01-05 13:26 [agent=codex] Auto-sync from child KABSD-TSK-0046 -> Planned.
2026-01-05 13:26 [agent=codex] Auto-sync from child KABSD-TSK-0046 -> InProgress.
2026-01-05 13:54 [agent=codex] Auto-sync from child KABSD-TSK-0047 -> Done.
