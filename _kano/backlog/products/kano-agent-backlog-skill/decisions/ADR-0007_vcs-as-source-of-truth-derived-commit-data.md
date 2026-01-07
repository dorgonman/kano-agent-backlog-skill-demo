---
id: ADR-0007
uid: 019b9725-8f12-7a3e-ae45-1234567890ab
type: Decision
title: "VCS as Source of Truth: Derived Commit Data"
state: Accepted
created: 2026-01-07
updated: 2026-01-07
related_items: ["KABSD-FTR-0017", "KABSD-USR-0018"]
tags: ["architecture", "vcs", "traceability", "derived-data"]
---

# Status

**Accepted** (2026-01-07)

Implemented in Feature KABSD-FTR-0017 (Traceability: Commit Refs → Worklog Backfill).

# Context

Backlog items need traceability to VCS commits to answer:
- "Which commits contributed to this item?"
- "What's the latest activity timestamp for this item?"
- "Generate a commit timeline view filtered by item state"

Two competing approaches:
1. **Worklog Backfill**: Parse VCS commits containing `Refs: <item-id>` and append them to item worklog
2. **Derived Data Query**: Keep VCS as source of truth; backlog queries VCS on-demand for commit data

# Decision

**We adopt the Derived Data Query approach**:
- VCS commits remain the canonical source of commit history
- Backlog items do NOT store commit data in worklog (no backfill)
- Query tools (`query_commits.py`, `view_generate_commits.py`) dynamically fetch commit data from VCS
- Commit messages use `Refs: <item-id>, <item-id>` pattern for traceable references
- Multi-VCS abstraction layer (`scripts/vcs/`) supports Git, Perforce, SVN

**Architecture**:
```
┌─────────────┐
│ VCS (Git)   │ ← Source of Truth (commit hash, author, date, message)
└──────┬──────┘
       │ query via adapter
       ▼
┌─────────────────────┐
│ VCS Adapter Layer   │ (Git/Perforce/SVN)
│ - base.py           │
│ - git_adapter.py    │
│ - perforce_adapter.py │
│ - svn_adapter.py    │
└──────┬──────────────┘
       │ query by ID/UID
       ▼
┌─────────────────────┐
│ Query Tools         │
│ - query_commits.py  │ (item → commits list)
│ - view_generate_commits.py │ (state → commit timeline)
└─────────────────────┘
```

# Rationale

## Why Derived Data (NOT Worklog Backfill)?

**Pros**:
1. **No Worklog Pollution**: Worklog stays clean for human-authored entries (decisions, state changes, manual notes)
2. **VCS is Authoritative**: No sync issues between VCS history and backlog; VCS is already immutable and auditable
3. **Deduplication**: Single commit referencing multiple items doesn't create N duplicate worklog entries
4. **Time-travel Queries**: Can query commits by date range without modifying backlog files
5. **Multi-VCS Support**: Abstraction layer allows querying Git, Perforce, SVN uniformly

**Cons**:
1. **Query Cost**: Every view generation requires VCS query (mitigated by future cache layer, see TSK-0110)
2. **VCS Dependency**: Backlog alone doesn't show commit history (requires VCS access)
3. **Complexity**: Multi-VCS adapter abstraction adds code complexity

## Why Multi-VCS Abstraction?

Real-world projects may use multiple VCS systems (monorepos with Git, legacy Perforce depots, SVN archives). The adapter pattern provides:
- **Uniform interface**: `VCSAdapter.query_commits(ref_pattern, since, until, max_count)`
- **Future-proof**: Easy to add new VCS types without changing query tools
- **Testable**: Mock adapters for unit tests

# Consequences

## Immediate Impact (Feature 0017)

**Implemented**:
- ✅ `scripts/vcs/base.py`: VCSAdapter abstract class, Commit dataclass, detect_vcs()
- ✅ `scripts/vcs/git_adapter.py`: Git implementation using `git log --grep`
- ✅ `scripts/vcs/perforce_adapter.py`: Perforce using `p4 changes -l`
- ✅ `scripts/vcs/svn_adapter.py`: SVN using `svn log --xml`
- ✅ `scripts/backlog/query_commits.py`: Resolve item → query VCS → output text/JSON
- ✅ `scripts/backlog/view_generate_commits.py`: Generate commit timeline views by state

**Commit Message Convention**:
```
feat: implement VCS adapter abstraction

Refs: KABSD-TSK-0105, KABSD-FTR-0017
```
Pattern: `Refs: <id>[, <id>]*` (case-insensitive, extracted via regex)

## Future Work

**Cache Layer (TSK-0110)**:
- Evaluation pending: SQLite cache vs. file-based cache
- Cache invalidation: TTL-based + manual clear
- Config: `vcs.cache.enabled`, `vcs.cache.backend`, `vcs.cache.ttl`
- **Note**: Cache is derived data; VCS remains source of truth

**Integration**:
- Dashboard auto-refresh: View generators can be called from `view_refresh_dashboards.py`
- Worklog hints: Query tools can suggest worklog entries (human decides whether to add)
- ADR references: Commits referencing ADRs can link to decision artifacts

## Breaking Changes

None. This is a new capability; existing backlog items are unaffected.

# Alternatives Considered

## 1. Worklog Backfill (Original Design)

**Approach**: Parse VCS commits and append to item worklog:
```markdown
2026-01-07 14:08 [agent=vcs-bot] Commit 2048e1c: Test commit for VCS adapter
```

**Rejected because**:
- Worklog pollution: Noisy with many commits
- Sync burden: Requires periodic backfill script runs
- Deduplication issue: Multi-item commits create duplicate entries
- Not time-travel friendly: Can't query "commits since yesterday" without re-parsing

## 2. Commit Index Table (Persistent Storage)

**Approach**: Store commits in SQLite `commits(hash, author, date, message, item_refs)` table.

**Deferred to TSK-0110** (cache evaluation):
- Would solve query performance
- Requires cache invalidation strategy
- Schema migration burden (needs TSK-0111 framework first)

## 3. VCS-Native Tools Only

**Approach**: Use `git log --grep "KABSD-"` directly; no backlog integration.

**Rejected because**:
- Not multi-VCS portable
- No item-to-commits resolution (requires manual filtering)
- No state-based filtering (can't generate "InProgress items with commits" view)

# References

- Feature: [KABSD-FTR-0017](../items/features/0000/KABSD-FTR-0017_traceability-commit-refs-worklog-backfill.md)
- UserStory: [KABSD-USR-0018](../items/userstories/0000/KABSD-USR-0018_vcs-adapter-abstraction-layer.md)
- Tasks: KABSD-TSK-0105 (Git), KABSD-TSK-0106 (Perforce), KABSD-TSK-0107 (SVN), KABSD-TSK-0108 (query_commits.py), KABSD-TSK-0109 (view_generate_commits.py)
- Future Work: [KABSD-TSK-0110](../items/tasks/0100/KABSD-TSK-0110_evaluate-vcs-query-cache-layer.md) (VCS Query Cache Evaluation)
- Depends On: None (standalone capability)

# Appendix: Example Usage

## Query Commits for an Item
```bash
# Text format
python skills/kano-agent-backlog-skill/scripts/backlog/query_commits.py \
  --item KABSD-TSK-0105

# JSON format
python skills/kano-agent-backlog-skill/scripts/backlog/query_commits.py \
  --item KABSD-TSK-0105 --format json
```

## Generate Commit Timeline View
```bash
# All "Done" items with commits
python skills/kano-agent-backlog-skill/scripts/backlog/view_generate_commits.py \
  --state Done --output _kano/backlog/views/commits_done.md

# All "InProgress" items (useful for daily standup)
python skills/kano-agent-backlog-skill/scripts/backlog/view_generate_commits.py \
  --state InProgress --output _kano/backlog/views/commits_active.md
```

## Commit Message Pattern
```
feat(vcs): add Perforce adapter with p4 changes parsing

Long description of the change...

Refs: KABSD-TSK-0106, KABSD-FTR-0017
```
- Pattern is case-insensitive: `refs:`, `Refs:`, `REFS:` all work
- Multiple items: comma-separated `Refs: ITEM-1, ITEM-2, ITEM-3`
- Deduplication: Same commit appears once even if queried by multiple item IDs
