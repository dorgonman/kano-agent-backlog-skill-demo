---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-USR-0030
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: KABSD-EPIC-0003
priority: P2
state: InProgress
tags: []
title: Pluggable vector backend MVP for embeddings
type: UserStory
uid: 019bc754-4618-71c1-9ff9-db63c0d47561
updated: 2026-01-19
---

# Context

As a user, I want a pluggable local-first vector backend so embeddings can be indexed and queried without a server.

# Goal

Define and validate an MVP vector backend adapter that supports index build, query, and rebuild.

# Approach

- Use the adapter contract from KABSD-TSK-0208 (prepare, upsert, delete, query, persist/load).
- Configure backend selection and storage path under product root.
- Validate build/query/rebuild and basic performance sanity checks.

# Acceptance Criteria

- Adapter interface is implemented and configurable.
- Index can be built, queried, and rebuilt locally with consistent results.
- Basic latency/storage checks documented.

# Risks / Dependencies

Backend constraints (dims, metric) may force per-backend compatibility checks; local-only constraint limits hosted features.

# Worklog

2026-01-16 23:02 [agent=codex] [model=unknown] Created item
2026-01-16 23:08 [agent=codex] [model=gpt-5.2-codex] Parent updated: null -> KABSD-EPIC-0003.
2026-01-19 03:00 [agent=opencode] [model=unknown] Start implementation: vector backend MVP (sqlite backend + config selection + tests).
