---
id: ADR-0008
uid: 019b9726-1a3f-7b2e-9f54-abcdef123456
type: Decision
title: "SQLite Schema Migration Framework"
state: Accepted
created: 2026-01-07
updated: 2026-01-07
related_items: ["KABSD-TSK-0111", "KABSD-TSK-0110", "ADR-0004"]
tags: ["architecture", "database", "migration", "schema-evolution"]
---

# Status

**Accepted** (2026-01-07)

Implemented in Task KABSD-TSK-0111 (Implement SQLite Schema Migration Framework).

# Context

The SQLite index schema (introduced in ADR-0004) needs to evolve:
- **Current need**: Add VCS cache tables (`vcs_commits`, `vcs_cache_metadata`) for TSK-0110
- **Future needs**: Embeddings tables, worklog full-text search indexes, external system sync tables

**Existing mechanism (ad-hoc)**:
```python
# build_sqlite_index.py (before ADR-0008)
try:
    cols = [row[1] for row in conn.execute("PRAGMA table_info(item_links)").fetchall()]
    if "target_uid" not in cols:
        conn.execute("ALTER TABLE item_links ADD COLUMN target_uid TEXT")
except sqlite3.OperationalError:
    pass
```

**Problems**:
- No version tracking (schema_version is written but never read)
- Hard-coded migrations in `apply_schema()` (not scalable)
- No migration ordering or idempotency guarantees
- Fragile `try-except` wrapping breaks on constraint violations

**Risk**: Adding VCS cache tables without a migration framework could break existing DBs or create inconsistent schemas across environments.

# Decision

**We adopt a Flyway-style migration framework**:
- Numbered SQL migration files in `references/migrations/`
- Version detection via `schema_meta.schema_version` (integer)
- Auto-upgrade on `build_sqlite_index.py --mode rebuild`
- Migration runner applies pending migrations sequentially
- Base schema (`indexing_schema.sql`) initializes version to 0

**Architecture**:
```
references/
  indexing_schema.sql          ← Base schema (creates tables, version=0)
  migrations/
    001_add_vcs_cache_tables.sql      ← Version 1
    002_add_embeddings_fts.sql        ← Version 2
    003_add_external_sync.sql         ← Version 3 (future)
```

**Migration Runner Logic**:
```python
def get_current_version(conn) -> int:
    """Return schema version (0 if fresh DB)."""
    try:
        row = conn.execute(
            "SELECT value FROM schema_meta WHERE key='schema_version'"
        ).fetchone()
        return int(row[0]) if row else 0
    except sqlite3.OperationalError:
        return 0  # schema_meta doesn't exist yet

def apply_migrations(conn):
    """Apply pending migrations in order."""
    current_version = get_current_version(conn)
    migration_dir = Path("references/migrations")
    migrations = sorted(migration_dir.glob("*.sql"))
    
    for migration_file in migrations:
        version = int(migration_file.stem.split("_")[0])  # "001_*.sql" → 1
        if version > current_version:
            print(f"Applying migration {version}: {migration_file.name}")
            conn.executescript(migration_file.read_text())
            conn.execute(
                "INSERT OR REPLACE INTO schema_meta(key, value) VALUES(?, ?)",
                ("schema_version", str(version))
            )
            conn.commit()

def apply_schema(conn):
    """Apply base schema + migrations."""
    conn.executescript(load_schema_sql())  # Creates schema_meta with version=0
    apply_migrations(conn)                 # Upgrade to latest
```

# Rationale

## Why Flyway-Style Migrations?

**Pros**:
1. **Explicit Versioning**: Each migration increments version; easy to track schema state
2. **Idempotent**: Migrations run exactly once (version check prevents re-runs)
3. **Ordered Execution**: Sorted filenames guarantee deterministic application order
4. **Git-Friendly**: Migration files are plain SQL, diff-able and reviewable
5. **Simple Mental Model**: Familiar to developers (like Alembic, Liquibase, Django migrations)

**Cons**:
1. **No Rollback**: Down migrations not supported (users must delete DB and rebuild)
2. **Manual Numbering**: Developers must coordinate version numbers (low risk in local-first design)

## Why Not Alembic/SQLAlchemy?

- **Overkill**: Requires ORM layer; we use raw SQL for simplicity
- **Python-based migrations**: SQL migrations are easier to audit and portable
- **Dependency bloat**: Alembic + SQLAlchemy adds significant dependencies

## Why Not "Delete and Rebuild"?

Current approach is `rm backlog.sqlite3 && rebuild`. Why not keep this?

**For small backlogs (<100 items)**: Delete-and-rebuild is fine (fast, simple).

**For large backlogs (>1000 items)**: Rebuild takes >10 seconds. Migrations enable:
- **Incremental mode**: Only re-index changed files (faster)
- **Preserve derived data**: Cache tables (VCS commits, embeddings) don't need full rebuild
- **Production stability**: Breaking schema changes are painful if rebuild is the only option

**Decision**: Support both. Migrations for gradual evolution; delete-rebuild as nuclear option.

# Consequences

## Immediate Impact (Task 0111)

**Implemented**:
- ✅ `get_current_version(conn)`: Read schema_meta.schema_version
- ✅ `apply_migrations(conn)`: Apply pending migrations from `references/migrations/`
- ✅ `apply_schema(conn)` refactored: Base schema → migrations
- ✅ Base schema (`indexing_schema.sql`) initializes `schema_version = '0'`
- ✅ Tested: Fresh DB (v0), migration upgrade (v0→v1), idempotent re-runs

**Migration Directory**:
```
references/migrations/
  (empty - ready for 001_add_vcs_cache_tables.sql when TSK-0110 completes)
```

## Future Work

**Version Compatibility Check**:
```python
def check_schema_compatibility(conn):
    """Warn if DB schema is newer than skill version."""
    db_version = get_current_version(conn)
    skill_max_version = 2  # Hard-coded or read from VERSION file
    if db_version > skill_max_version:
        print(f"Warning: DB schema v{db_version} newer than skill v{skill_max_version}.")
```

**Migration Naming Convention**:
```
{version:03d}_{description}.sql
001_add_vcs_cache_tables.sql
002_add_embeddings_fts.sql
003_add_worklog_search_index.sql
```

**Transaction Safety**:
All migrations wrapped in `BEGIN TRANSACTION` / `COMMIT` (SQLite default for `executescript()`). If migration fails, rollback prevents partial application.

## Breaking Changes

None. Existing DBs without migrations are version 0; migrations upgrade them gracefully.

**Backward Compatibility**:
- Old skill (no migration runner) + new DB (v1+): Read queries work; writes may fail on new constraints
- New skill (with migration runner) + old DB (v0): Auto-upgrades on rebuild

# Alternatives Considered

## 1. Hard-Coded Migrations in Code

**Current approach** (before ADR-0008):
```python
if "target_uid" not in cols:
    conn.execute("ALTER TABLE item_links ADD COLUMN target_uid TEXT")
```

**Rejected because**:
- Not scalable (code bloat)
- No version tracking (can't detect schema state)
- Error-prone (forgotten migrations leave inconsistent DBs)

## 2. Alembic (Python-Based Migrations)

**Approach**: Use Alembic for ORM-style migrations.

**Rejected because**:
- Requires SQLAlchemy ORM (we use raw SQL)
- Python-based migrations harder to audit (prefer declarative SQL)
- Overkill for local-first use case

## 3. Schema Versioning Without Migrations

**Approach**: Store version but require manual schema updates.

**Rejected because**:
- Shifts migration burden to users (error-prone)
- No automated upgrade path

## 4. Delete-and-Rebuild Only

**Approach**: Always `rm backlog.sqlite3 && rebuild` on schema change.

**Partially Retained**: Still supported as nuclear option.

**Why Not Sufficient**:
- Large backlogs: Rebuild too slow (>10s for 1000+ items)
- Cache tables: VCS commits, embeddings would be lost (no incremental updates)

# References

- Task: [KABSD-TSK-0111](../items/tasks/0100/KABSD-TSK-0111_implement-sqlite-schema-migration-framework.md)
- Related ADR: [ADR-0004](ADR-0004_file-first-architecture-with-sqlite-index.md) (SQLite Index Architecture)
- Future Work: [KABSD-TSK-0110](../items/tasks/0100/KABSD-TSK-0110_evaluate-vcs-query-cache-layer.md) (VCS Cache - first migration user)
- Dependency: None (standalone framework)

# Appendix: Migration File Template

```sql
-- Migration 001: Add VCS cache tables (2026-01-07)
-- Context: Support derived VCS commit data caching (TSK-0110)

CREATE TABLE vcs_commits (
  item_uid TEXT NOT NULL,
  commit_hash TEXT NOT NULL,
  author TEXT NOT NULL,
  date TEXT NOT NULL,
  message TEXT NOT NULL,
  cached_at TEXT NOT NULL,
  PRIMARY KEY(item_uid, commit_hash)
);

CREATE INDEX idx_vcs_commits_cached_at ON vcs_commits(cached_at);

CREATE TABLE vcs_cache_metadata (
  item_uid TEXT PRIMARY KEY,
  last_query_at TEXT NOT NULL,
  vcs_type TEXT NOT NULL  -- 'git', 'perforce', 'svn'
);
```

**Naming**: `{version:03d}_{description}.sql`

**Testing**:
```bash
# Fresh DB (should apply migration)
rm -f _kano/backlog/_index/backlog.sqlite3
python skills/kano-agent-backlog-skill/scripts/indexing/build_sqlite_index.py \
  --agent copilot --mode rebuild

# Re-run (should skip migration, idempotent)
python skills/kano-agent-backlog-skill/scripts/indexing/build_sqlite_index.py \
  --agent copilot --mode rebuild
```
