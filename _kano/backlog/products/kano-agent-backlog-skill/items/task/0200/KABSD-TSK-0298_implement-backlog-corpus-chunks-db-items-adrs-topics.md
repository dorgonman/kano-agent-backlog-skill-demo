---
area: infrastructure
created: '2026-01-25'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0298
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: KABSD-FTR-0058
priority: P1
state: InProgress
tags:
- search
- fts
- chunks
title: Implement backlog corpus chunks DB (items + ADRs + topics)
type: Task
uid: 019bf587-8b35-7527-9890-167e854ff24c
updated: 2026-01-25
---

# Context

Current chunks/FTS indexing is product-item-only, so ADRs and Topics are not searchable via the hybrid pipeline. This leaves key decisions and research context out of retrieval.

# Goal

Provide a backlog corpus chunks DB that indexes items, ADRs, and topics and supports FTS candidate retrieval for hybrid search.

# Approach

Implement a backlog-corpus builder that scans products/*/items/**, products/*/decisions/**, and topics/** (excluding derived/cache dirs). Reuse the canonical schema (items/chunks/chunks_fts) and the canonical chunk_id contract. For topic docs without frontmatter, generate deterministic synthetic IDs/UIDs. Expose build/query commands and add tests.

# Acceptance Criteria

A backlog corpus chunks DB can be built and queried with FTS. Results include matches from at least one item, one ADR, and one topic document. Derived/cache directories are excluded. Automated tests cover the builder and query surface.

# Risks / Dependencies

Topics may not have frontmatter; requires synthetic identity and collision avoidance. Corpus size may grow; keep freshness checks fast and provide --force rebuild.

# Worklog

2026-01-25 22:20 [agent=opencode] Created item
2026-01-25 23:29 [agent=opencode] Started implementation of backlog corpus chunks DB. Plan: 1) Expand scanning to include ADRs and Topics in chunks_db.py; 2) Ensure stable ID generation for non-item files; 3) Update build_chunks_db to process these new sources.
