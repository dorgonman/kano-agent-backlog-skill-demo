---
area: general
created: '2026-01-31'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0328
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Done
tags: []
title: Reorganize cache structure and clean up obsolete directories
type: Task
uid: 019c0fad-db8e-7683-99f5-c1b1635be8ca
updated: '2026-01-31'
---

# Context

Current cache structure is scattered across .cache/ and _kano/backlog/ with unclear naming. Two independent corpus (repo and backlog) need clear separation. Windows path length limits require shorter names.

# Goal

Reorganize all backlog-skill generated cache files into .kano/cache/backlog/ with descriptive, corpus-aware naming that avoids Windows path length limits

# Approach

1. Move .cache/{repo_chunks.sqlite3, repo_build_status.json} to .kano/cache/backlog/ with new names
2. Flatten .cache/vectors/ directory into .kano/cache/backlog/ with corpus-aware naming
3. Clean up obsolete directories in _kano/backlog/: items/, views/, sandboxes/, _tmp_tests/
4. Update code to use new paths
5. Create migration script for existing installations

# Acceptance Criteria

- All cache files moved to .kano/cache/backlog/
- Naming follows pattern: chunks.{corpus}.{version}.{ext} and vectors.{corpus}.{embedding}.{hash}.{ext}
- Obsolete directories removed from _kano/backlog/
- Code updated to generate new paths
- Migration script created and tested
- Documentation updated

# Risks / Dependencies

Breaking existing installations without migration path. Need to ensure backward compatibility or clear upgrade instructions.

# Worklog

2026-01-31 00:12 [agent=opencode] Created item
2026-01-31 00:14 [agent=opencode] [model=unknown] Created detailed implementation plan in .sisyphus/KABSD-TSK-0328-cache-reorganization-plan.md covering: new cache structure (.kano/cache/backlog/), file mappings, code updates (4 files), migration scripts, cleanup of obsolete directories, documentation updates, testing plan. Estimated effort: 5-7 hours
2026-01-31 00:25 [agent=opencode] Workset initialized: D:\_work\_Kano\kano-agent-backlog-skill-demo\_kano\backlog\.cache\worksets\items\KABSD-TSK-0328
2026-01-31 00:53 [agent=opencode] [model=unknown] Completed code updates: Updated 4 Python files (repo_chunks_db.py, repo_chunks_db_async.py, repo_vector_index.py, repo_vector_query.py, sqlite_backend.py) to use new cache structure (.kano/cache/backlog/) with corpus-aware naming. Created migration scripts for Unix and Windows. Removed obsolete directories (items/, views/, sandboxes/, _tmp_tests/). Now updating documentation.
2026-01-31 00:54 [agent=opencode] State -> Done.
2026-01-31 00:54 [agent=opencode] [model=unknown] ✅ Task completed successfully! All 5 phases done: (1) Created .kano/cache/backlog/ structure, (2) Updated 5 Python files with new paths and naming convention, (3) Created migration scripts for Unix/Windows, (4) Removed obsolete directories (items/, views/, sandboxes/, _tmp_tests/), (5) Updated README.md with Cache Structure section. New naming: chunks.{corpus}.{version}.db and vectors.{corpus}.{emb}.{hash}.db. Ready for testing.
2026-01-31 00:57 [agent=opencode] Promoted 1 deliverable(s) to D:\_work\_Kano\kano-agent-backlog-skill-demo\_kano\backlog\products\kano-agent-backlog-skill\artifacts\KABSD-TSK-0328: implementation-summary.md
2026-01-31 01:02 [agent=opencode] [model=unknown] ✅ Migration executed successfully! Verified new cache structure in .kano/cache/backlog/ with all files present: chunks.repo.v1.db (46M), chunks.repo.v1.status (307B), vectors.repo.noop-d1536.af3c739f.db (213M), vectors.repo.noop-d1536.af3c739f.meta (605B). Old files preserved in .cache/ for safety. Task fully complete and tested.