---
id: KABSD-TSK-0046
uid: 019b8f52-9fb2-74e1-86c2-31ec952cb7ae
type: Task
title: Define DB index schema (items, links, worklog, decisions)
state: Done
priority: P3
parent: KABSD-USR-0012
area: storage
iteration: null
tags:
- db
- schema
- index
created: 2026-01-05
updated: '2026-01-06'
owner: codex
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

We need a concrete schema before implementing any indexer/backend.

# Goal

Define a minimal DB schema that can represent backlog items and their relationships.

# Non-Goals

- Implement the SQLite/Postgres indexer.
- Define embedding/vector storage.
- Guarantee compatibility with every future process profile without schema evolution.

# Approach

- Cover: items (frontmatter), tags, links/parent edges, worklog entries, ADR links.
- Define keys/constraints and a version field.
- Keep it compatible with SQLite; optionally map to Postgres.

# Links

- Feature: [[KABSD-FTR-0007_optional-db-index-and-embedding-rag-pipeline|KABSD-FTR-0007 Optional DB index and embedding/RAG pipeline]]
- Reference: `skills/kano-agent-backlog-skill/references/indexing_schema.sql`
- Reference: `skills/kano-agent-backlog-skill/references/indexing_schema.json`

# Alternatives

- Store raw JSON blobs only (harder to query).
- Use a document store instead of a relational schema.
- Skip the schema doc and iterate directly in code (harder to review).

# Acceptance Criteria

- Schema document exists (SQL + JSON description).
- Includes a migration/version story (drop/rebuild is acceptable for v0).

# Risks / Dependencies

- Future changes may require migrations if we ever store authoritative data in DB.

# Worklog

2026-01-05 08:30 [agent=codex] Created from template.
2026-01-05 13:26 [agent=codex] State -> Ready. Ready gate validated for DB index schema definition.
2026-01-05 13:26 [agent=codex] State -> InProgress. Writing minimal relational schema for file-first backlog DB index.
2026-01-05 13:28 [agent=codex] State -> Done. Added SQLite-first DB index schema (SQL + JSON) and linked it from REFERENCE.md and the task.
