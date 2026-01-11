---
area: release
created: 2026-01-06
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-EPIC-0003
iteration: null
links:
  blocked_by: []
  blocks: []
  relates: []
owner: null
parent: null
priority: P2
state: InProgress
tags:
- milestone
- release
- 0.0.2
title: Milestone 0.0.2 (Indexing + Resolver)
type: Epic
uid: 019bac4a-6857-7432-b43f-3082737ca786
updated: 2026-01-06
---

# Context

This milestone extends the file-first backlog with optional derived layers:
- a rebuildable SQLite index for fast querying and view generation
- an ID/uid resolver design for multi-agent, multi-branch item creation

# Goal

Improve scalability (many items) and collaboration (cross-branch uniqueness) without turning DB into the source of truth.

# Non-Goals

- Making the database the single source of truth (DB-first).
- Requiring embeddings/vector DB for normal operation.

# Approach

- Keep Markdown files as source of truth.
- Use SQLite as an optional index and query accelerator.
- Specify and implement resolver + migration plan for `uid`/`id` usage.

# Alternatives

# Acceptance Criteria

- Index can be rebuilt from scratch safely (no source file mutation).
- Views can use index when available, otherwise fall back to file scan.
- Resolver spec and migration plan are documented and implementable.

# Risks / Dependencies

- Identifier strategy needs careful UX to avoid ambiguity and merge conflicts.
- Local-only indexing must not leak secrets or become a new dependency.

# Links

- Feature: [[KABSD-FTR-0007_optional-db-index-and-embedding-rag-pipeline|KABSD-FTR-0007 Optional DB index and embedding/RAG pipeline]]
- Feature: [[KABSD-FTR-0008_identifier-strategy-and-id-resolver-adr-0003|KABSD-FTR-0008 Identifier strategy and ID resolver (ADR-0003)]]

# Worklog

2026-01-06 08:26 [agent=codex-cli] Created milestone epic for v0.0.2.
2026-01-06 08:34 [agent=codex-cli] Populated milestone scope and linked the indexing/resolver Feature.
2026-01-06 08:33 [agent=codex-cli] State -> Planned. Milestone 0.0.2 queued after 0.0.1 core demo; scope focuses on indexing + resolver.
2026-01-06 08:36 [agent=antigravity] Auto-sync from child KABSD-TSK-0049 -> InProgress.