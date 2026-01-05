---
id: KABSD-USR-0015
type: UserStory
title: "Generate embeddings for backlog items (derivative index)"
state: Proposed
priority: P4
parent: KABSD-FTR-0007
area: rag
iteration: null
tags: ["embedding", "rag", "index"]
created: 2026-01-05
updated: 2026-01-05
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

Embeddings can improve retrieval (RAG) across decisions/worklogs without expanding prompt size.

# Goal

As a user, I want an embedding pipeline that turns backlog items into vectors so agents can retrieve relevant context quickly.

# Non-Goals

# Approach

- Define chunking rules (frontmatter + sections + worklog).
- Store embeddings as derivative index (rebuildable).
- Keep provider integration optional and avoid hard dependency in core scripts.

# Alternatives

# Acceptance Criteria

- A script can generate embeddings from a file backlog (or DB index) and write them to a local artifact store.
- Metadata includes item id/type/state/updated and source path.

# Risks / Dependencies

# Worklog

2026-01-05 08:30 [agent=codex] Created from template.
