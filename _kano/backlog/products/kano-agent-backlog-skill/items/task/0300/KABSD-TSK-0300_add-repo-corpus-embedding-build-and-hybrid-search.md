---
area: infrastructure
created: '2026-01-25'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0300
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0058
priority: P1
state: Proposed
tags:
- search
- embedding
- hybrid
title: Add repo corpus embedding build and hybrid search
type: Task
uid: 019bf587-97c1-77a6-b874-6d5fb4f86b96
updated: '2026-01-25'
---

# Context

Repo corpus keyword search is useful, but semantic rerank and hybrid search improve relevance for ambiguous queries and natural-language intent.

# Goal

Add embedding build and hybrid search for the repo corpus using canonical chunk IDs as the join key.

# Approach

Implement repo-corpus embedding build that reads chunks from the repo corpus DB and writes embeddings into the vector backend keyed by chunk_id. Ensure embedding_space_id includes corpus identity to prevent mixing corpuses/models. Implement hybrid query: FTS candidates (top N) -> vector rerank over candidate chunk_ids -> snippet/highlight from FTS. Support incremental skip and prune stale vectors.

# Acceptance Criteria

Repo hybrid search returns top-k results with file path and highlighted snippet. Embedding build is incremental (skips already indexed chunks) and prunes stale chunk_ids. Tests cover end-to-end repo hybrid search.

# Risks / Dependencies

Vector rerank over large candidate sets can be slow; mitigate by limiting FTS candidates and adding candidate filtering support in the backend. Corpus churn may require periodic force rebuild.

# Worklog

2026-01-25 22:21 [agent=opencode] Created item