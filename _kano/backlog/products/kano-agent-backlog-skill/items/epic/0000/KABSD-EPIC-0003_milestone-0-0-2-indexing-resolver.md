---
area: release
created: '2026-01-06'
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
updated: '2026-01-16'
---

# Context

This epic delivers the end-to-end local-first DB embedding pipeline: deterministic chunking, embedding generation, and a pluggable vector backend for indexing and retrieval.

# Goal

Complete the full DB embedding chain so that documents can be chunked, embedded, indexed, queried, and rebuilt locally.

# Non-Goals

- Making the database the single source of truth (DB-first).
- Requiring embeddings/vector DB for normal operation.

# Approach

- Deliver chunking/token-budget MVP (USR-0029, TSK-0207, TSK-0233).
- Deliver pluggable vector backend MVP (USR-0030, TSK-0208).
- Ensure local-first constraints and rebuildable indexes.

# Acceptance Criteria

- Chunking and token-budget pipeline is implemented and validated.
- Vector backend adapter is implemented with local persistence and rebuild.
- End-to-end indexing and retrieval works on a sample dataset.

# Risks / Dependencies

- Tokenizer differences and model limits may require per-model handling.
- Backend performance and storage constraints may require tuning.

# Worklog

2026-01-06 08:26 [agent=codex-cli] Created milestone epic for v0.0.2.
2026-01-06 08:34 [agent=codex-cli] Populated milestone scope and linked the indexing/resolver Feature.
2026-01-06 08:33 [agent=codex-cli] State -> Planned. Milestone 0.0.2 queued after 0.0.1 core demo; scope focuses on indexing + resolver.
2026-01-06 08:36 [agent=antigravity] Auto-sync from child KABSD-TSK-0049 -> InProgress.
2026-01-16 23:08 [agent=codex] [model=gpt-5.2-codex] Updated epic scope to cover the full local-first DB embedding chain (chunking -> embeddings -> vector backend) and mapped to new user stories.
2026-01-20 00:32 [agent=codex] [model=unknown] Artifact attached: [0.0.2.md](..\..\..\artifacts\KABSD-EPIC-0003\0.0.2.md) — Attach 0.0.2 release notes (topics + embedding pipeline foundations)
