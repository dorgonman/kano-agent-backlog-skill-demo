---
id: KABSD-TSK-0110
uid: 019b971c-ef4d-7635-9fe3-03cd450886e2
type: Task
title: "Evaluate VCS Query Cache Layer"
state: InProgress
priority: P2
parent: KABSD-FTR-0017
area: general
iteration: null
tags: []
created: 2026-01-07
updated: 2026-01-07
owner: copilot
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

Currently, `query_commits.py` and `view_generate_commits.py` query the VCS directly on every invocation. For large repos or when querying many items, this can be slow. A cache layer could significantly improve performance by storing derived commit data and only hitting VCS on cache miss.

# Goal

Evaluate caching strategies for VCS commit queries and produce a recommendation (ADR or follow-up ticket) on:
- **Storage options**: `.cache/` directory vs. SQLite `_index` DB (new tables: `vcs_commits`, `vcs_cache_metadata`)
- **Cache invalidation**: Time-based TTL, manual clear, or hybrid approach
- **Config keys**: `vcs.cache.enabled`, `vcs.cache.ttl`, `vcs.cache.backend` (file/sqlite)
- **Cache operations**: `vcs_cache_clear.py`, `vcs_cache_rebuild.py`, or integrate into existing indexer

# Non-Goals

- Full implementation (this is evaluation only; implementation would be a separate ticket)
- Real-time VCS webhook-based invalidation (too complex for local-first design)

# Approach

1. **Benchmark current performance**: Measure `query_commits.py` execution time for 1/10/100 items
2. **Design cache schema**:
   - SQLite-first (primary):
     - `vcs_commits(item_uid, commit_hash, author, date, message, cached_at, vcs_type)`
     - `vcs_cache_metadata(item_uid, last_query_at, ttl_seconds, backend)`
   - File fallback (optional): `_kano/backlog/.cache/vcs/<item-uid>.json` for environments without SQLite
3. **Compare trade-offs**:
   - File cache: simpler, easier to clear (rm -rf), but slower for bulk queries
   - SQLite cache: faster queries, atomic updates, but schema complexity + migration burden
4. **Draft config schema** (proposed):
   ```json
   {
     "vcs": {
       "cache": {
         "enabled": true,
         "backend": "sqlite",        // "sqlite" | "file"
         "ttl": 3600,                 // seconds, default 1h
         "path": null,                // sqlite: _kano/backlog/products/<product>/_index/backlog.sqlite3; file: _kano/backlog/.cache/vcs/
         "fallback_to_vcs": true,     // cache miss → query VCS directly
         "bypass_flag": "--no-cache" // CLI flag to force VCS direct query
       }
     }
   }
   ```
5. **Document recommendation** as ADR or inline Approach section with decision

# Alternatives

- **No cache**: Keep current design (simplest, always fresh, but slower)
- **VCS-native caching**: Rely on `git` disk cache (not portable across VCS types)
- **Worklog backfill**: Original 0017 design (rejected due to backlog pollution)

# Acceptance Criteria

- [ ] Benchmark results documented (execution time for 1/10/100 items)
- [ ] Cache schema designed for both file and SQLite backends
- [ ] Trade-off analysis written (performance, complexity, maintenance)
- [ ] Config schema drafted
- [ ] Recommendation documented (either ADR or inline decision with rationale)
- [ ] If proceeding: follow-up ticket created for implementation

# Risks / Dependencies

- **Risk**: Cache invalidation strategy may be too naive (e.g., TTL-only misses recent commits)
- **Risk**: SQLite schema migration burden if we add VCS tables to existing index
- **Dependency**: Requires benchmarking on a realistic repo size (current demo repo is too small)
- **Dependency**: KABSD-TSK-0111 (Schema Migration Framework) — must be implemented before adding new VCS cache tables to avoid breaking existing DBs

# Worklog

2026-01-07 14:20 [agent=copilot] Created from template.
2026-01-07 14:20 [agent=copilot] Populated task with cache evaluation scope: benchmark, schema design (file vs SQLite), config draft, and trade-off analysis.
2026-01-07 16:25 [agent=copilot] Start evaluation: benchmark VCS query cost (1/10/100 items), design cache schema (SQLite vs file), draft config keys.
2026-01-07 16:31 [agent=copilot] Start evaluation: benchmark VCS query cost (1/10/100 items), design cache schema (SQLite vs file), draft config keys.
2026-01-07 16:45 [agent=copilot] Benchmark: query_commits (Git) — 1x=0.33s, 10x=2.78s, 100x=27.48s (warm cache, same item).
