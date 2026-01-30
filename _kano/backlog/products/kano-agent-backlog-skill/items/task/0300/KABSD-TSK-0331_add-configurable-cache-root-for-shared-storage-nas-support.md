---
area: general
created: '2026-01-31'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0331
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
title: Add configurable cache root for shared storage (NAS support)
type: Task
uid: 019c0ffd-b32b-75b2-85be-3709495ab240
updated: '2026-01-31'
---

# Context

Cache path is hardcoded as backlog_root.parent.parent / '.kano' / 'cache' / 'backlog'. Users want to store cache on NAS or other shared location for team collaboration. Need config option + CLI override for cache location.

# Goal

Add explicit cache.root configuration option for maximum flexibility. Support config file override and CLI parameter override.

# Approach

1. Add get_chunks_cache_root() method to ConfigLoader that reads config.cache.root with fallback to default. 2. Add cache_root parameter to build_chunks_db(), build_vector_index(), and search functions. 3. Add --cache-root CLI option to embedding and search commands. 4. Update config.template.toml with [cache] section documentation.

# Acceptance Criteria

1. ConfigLoader.get_chunks_cache_root() reads config.cache.root and falls back to default. 2. All build/query functions accept optional cache_root parameter. 3. CLI commands support --cache-root option. 4. Config template documents cache.root option with NAS example. 5. Documentation updated with usage examples.

# Risks / Dependencies

None - backward compatible, defaults to existing behavior

# Worklog

2026-01-31 01:40 [agent=opencode] Created item
2026-01-31 01:45 [agent=opencode] State -> Done. Implementation complete: Added ConfigLoader.get_chunks_cache_root() method, updated backlog_chunks_db.py, backlog_vector_index.py, backlog_vector_query.py with cache_root parameter. Added --cache-root CLI option to embedding.py and search.py commands. Updated config.template.toml with [cache] section. Documentation updated in README.md files. All tests pass (133 config-related tests). Feature supports: 1) Config file override (config.cache.root), 2) CLI parameter override (--cache-root), 3) Default fallback (.kano/cache/backlog/). Use cases: team collaboration on NAS, external projects sharing cache, CI/CD persistent volumes.
