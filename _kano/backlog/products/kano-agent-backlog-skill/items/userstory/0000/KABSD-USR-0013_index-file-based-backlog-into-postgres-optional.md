---
id: KABSD-USR-0013
uid: 019b8f52-9f46-7db6-9a2a-f45bdee6beed
type: UserStory
title: Index file-based backlog into Postgres (optional)
state: Proposed
priority: P4
parent: KABSD-FTR-0007
area: storage
iteration: null
tags:
- db
- index
- postgres
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

Some teams may prefer Postgres for shared access, concurrency, or hosting.

# Goal

As a user, I want an optional Postgres index backend so multiple agents/users can query the same indexed backlog.

# Non-Goals

# Approach

- Reuse the same logical schema as SQLite where possible.
- Support `pgvector` columns for embedding storage to enable shared ANN search.
- Keep DB as derived/indexed data; files remain authoritative.

# Alternatives

# Acceptance Criteria

- Postgres backend can be enabled via config and indexed from files.
- Docs list required env/connection settings (without storing secrets in repo).

# Risks / Dependencies

# Worklog

2026-01-05 08:30 [agent=codex] Created from template.
