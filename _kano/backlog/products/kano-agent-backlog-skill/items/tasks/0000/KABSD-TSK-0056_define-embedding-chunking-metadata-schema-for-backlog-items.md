---
id: KABSD-TSK-0056
uid: 019b8f52-9fc8-7c94-aa2d-806cacdd9086
type: Task
title: Define embedding chunking + metadata schema for backlog items
state: Proposed
priority: P4
parent: KABSD-USR-0015
area: rag
iteration: null
tags:
- embedding
- rag
- schema
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

Before embedding, we need a consistent chunking and metadata design so retrieval is predictable and rebuildable.

# Goal

Define chunking rules and metadata schema for turning backlog items into embedding documents.

# Non-Goals

# Approach

- Define what gets embedded (title/context/goal/approach/acceptance/worklog/ADR links).
- Define chunk boundaries (per section, per worklog entry group, max chars).
- Define metadata keys (id/type/state/updated/tags/parent/source_path).
- Keep provider-agnostic output format (JSONL).

# Alternatives

# Acceptance Criteria

- A reference doc exists describing chunking + metadata + versioning.
- Example output JSONL is included (small).

# Risks / Dependencies

# Worklog

2026-01-05 16:21 [agent=codex] Created from template.
