---
area: general
created: '2026-01-31'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0332
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: InProgress
tags: []
title: Separate repo and backlog corpus into different cache folders
type: Task
uid: 019c1012-284a-70b7-9e45-3a26643fa2c3
updated: 2026-01-31
---

# Context

Current cache naming: chunks.{corpus}.{product}.v1.db and vectors.{corpus}.{product}.{emb}.{hash}.db. This causes chunks and vectors to be sorted separately, making it hard to see which files belong to the same corpus. Additionally, repo corpus doesn't include project name, causing potential conflicts when multiple projects share the same cache location (e.g., NAS).

# Goal

Reorganize cache file naming to use corpus as prefix with consistent project/product identification: {corpus}.{project/product}.chunks.v1.db and {corpus}.{project/product}.vectors.{emb}.{hash}.db. This groups files by corpus and prevents naming conflicts.

# Non-Goals

- Changing cache directory structure (still .kano/cache/backlog/)
- Changing the cache.root configuration mechanism

# Approach

1. Update backlog corpus naming: backlog.{product}.chunks.v1.db, backlog.{product}.vectors.{emb}.{hash}.db
2. Update repo corpus naming: repo.{project}.chunks.v1.db, repo.{project}.vectors.{emb}.{hash}.db (add project name)
3. Update all code references in backlog_chunks_db.py, repo_chunks_db.py, backlog_vector_index.py, repo_vector_index.py
4. Create migration script to rename existing cache files
5. Update documentation with new naming convention

# Alternatives

- Keep current naming (rejected - causes sorting issues and repo conflicts)
- Use separate folders for repo/backlog (rejected - file naming is simpler)

# Acceptance Criteria

1. Backlog corpus naming: backlog.{product}.chunks.v1.db, backlog.{product}.vectors.{emb}.{hash}.db
2. Repo corpus naming: repo.{project}.chunks.v1.db, repo.{project}.vectors.{emb}.{hash}.db
3. Migration script successfully renames existing files
4. All code uses new naming convention
5. Tests pass with new naming
6. Documentation updated

# Risks / Dependencies

Breaking change - requires migration of existing cache files. Mitigate: provide clear migration script and documentation.

# Worklog

2026-01-31 02:02 [agent=opencode] Created item
2026-01-31 02:12 [agent=opencode] State -> InProgress. [Ready gate validated]
