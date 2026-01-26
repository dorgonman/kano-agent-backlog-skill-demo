---
area: infrastructure
created: '2026-01-25'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0299
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: KABSD-FTR-0058
priority: P1
state: Done
tags:
- search
- fts
- repo
title: Implement repo corpus chunks DB (docs + code)
type: Task
uid: 019bf587-9093-71fe-bfd8-c2305166a910
updated: 2026-01-26
---

# Context

We frequently need to search docs and code (errors, constants, symbol names, design notes). Without an index, we fall back to slow grep and cannot use hybrid rerank + snippet.

# Goal

Build a repo corpus chunks DB (FTS5) that indexes selected repo files (docs + code) with configurable include/exclude patterns.

# Approach

Implement a repo-corpus builder that scans the workspace with a safe default include set (e.g., *.md, *.py, *.toml, *.json) and an explicit exclude list (e.g., .git, .cache, *.sqlite3, .env). Treat each file as an item with id FILE:<relative-path>, store path relative to project root, and chunk content as plain text. Reuse canonical schema and chunk_id contract; store file metadata (ext/lang) in items.frontmatter. Add build/query CLI and tests.

# Acceptance Criteria

A repo corpus chunks DB can be built and queried with FTS. Query results include matches from both docs and code. Include/exclude rules work and prevent indexing derived/binary/secret files by default. Tests cover builder behavior.

# Risks / Dependencies

Large repos can increase build time; mitigate with conservative defaults and mtime-based freshness checks. Encoding issues and accidental secret indexing; mitigate with strict excludes and size limits.

# Worklog

2026-01-25 22:21 [agent=opencode] Created item
2026-01-26 08:41 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-01-26 08:51 [agent=opencode] [model=unknown] Implementation complete: Created repo_chunks_db.py with build_repo_chunks_db() and query_repo_chunks_fts() functions. Added CLI commands 'chunks build-repo' and 'chunks query-repo'. All 16 tests pass. Includes configurable include/exclude patterns, file size limits, and mtime-based scanning. DB stored at <workspace>/.cache/repo_chunks.sqlite3.
2026-01-26 08:51 [agent=opencode] State -> Done.
