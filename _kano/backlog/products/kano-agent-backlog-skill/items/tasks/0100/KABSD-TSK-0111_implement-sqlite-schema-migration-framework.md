---
id: KABSD-TSK-0111
uid: 019b9722-64d7-7271-9ff6-8bfd19c9742d
type: Task
title: "Implement SQLite Schema Migration Framework"
state: Done
priority: P1
parent: KABSD-FTR-0007
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

Currently, the SQLite indexer has basic schema versioning (`schema_meta.schema_version = "1"`) but lacks a proper migration framework. When adding new tables/columns (e.g., VCS cache tables in TSK-0110), we risk breaking existing DBs. Need a robust migration system before expanding the schema.

**Current limitations**:
- No version detection logic (version is written but never read)
- Hard-coded migrations in `apply_schema()` (not scalable)
- No migration script registry or ordering
- `ALTER TABLE` wrapped in `try-except` is fragile

# Goal

Implement a lightweight, Flyway-style migration framework for SQLite index schema evolution:
1. **Version detection**: Read `schema_meta.schema_version` on startup
2. **Migration registry**: Apply numbered SQL scripts from `references/migrations/`
3. **Idempotent migrations**: Each migration runs exactly once
4. **Auto-upgrade on rebuild**: `build_sqlite_index.py --mode rebuild` applies pending migrations
5. **Backward compatibility**: Old skill versions fail gracefully on newer DBs

# Non-Goals

- Down migrations (rollback) — too complex for local-first design; users can delete DB and rebuild
- Multi-tenant schema branching (single product backlog only)
- Runtime schema introspection API (migrations are build-time only)

# Approach

## 1. Migration File Structure
```
references/migrations/
  001_add_target_uid.sql          # Existing ad-hoc migration
  002_add_vcs_cache_tables.sql    # Future: VCS cache schema
  003_add_worklog_indexed_at.sql  # Example
```

**Naming convention**: `{version:03d}_{description}.sql`

## 2. Migration Runner Logic
```python
def get_current_version(conn) -> int:
    """Return current schema version (0 if fresh DB)."""
    try:
        row = conn.execute(
            "SELECT value FROM schema_meta WHERE key='schema_version'"
        ).fetchone()
        return int(row[0]) if row else 0
    except sqlite3.OperationalError:
        return 0  # Table doesn't exist yet

def apply_migrations(conn, skill_root: Path) -> None:
    """Apply pending migrations in order."""
    current_version = get_current_version(conn)
    migration_dir = skill_root / "references" / "migrations"
    
    if not migration_dir.exists():
        # No migrations directory = schema_version stays at base (from indexing_schema.sql)
        return
    
    migrations = sorted(migration_dir.glob("*.sql"))
    
    for migration_file in migrations:
        version = int(migration_file.stem.split("_")[0])
        if version > current_version:
            print(f"Applying migration {version}: {migration_file.name}")
            conn.executescript(migration_file.read_text(encoding="utf-8"))
            conn.execute(
                "UPDATE schema_meta SET value=? WHERE key='schema_version'",
                (str(version),)
            )
            conn.commit()
            current_version = version
```

## 3. Integration Points

**In `build_sqlite_index.py`**:
```python
def apply_schema(conn: sqlite3.Connection, skill_root: Path) -> None:
    # 1. Apply base schema (creates schema_meta with version=0 or baseline)
    conn.executescript(load_schema_sql())
    
    # 2. Apply migrations (upgrades to latest version)
    apply_migrations(conn, skill_root)
```

**Version check on query scripts**:
```python
def check_schema_compatibility(conn):
    """Warn if DB schema is newer than skill version."""
    db_version = get_current_version(conn)
    skill_max_version = 2  # Hard-coded or read from VERSION file
    if db_version > skill_max_version:
        print(f"Warning: DB schema v{db_version} is newer than skill v{skill_max_version}. Consider upgrading skill.")
```

## 4. Migration 001: Retrofit Existing Ad-Hoc Change

Create `references/migrations/001_add_target_uid.sql`:
```sql
-- Migration 001: Add target_uid to item_links (2026-01-07)
ALTER TABLE item_links ADD COLUMN target_uid TEXT;
CREate INDEX IF NOT EXISTS idx_item_links_target_uid ON item_links(target_uid);
```

Remove hard-coded logic from `apply_schema()`.

# Alternatives

- **Alembic/SQLAlchemy**: Overkill for this use case (requires ORM, Python-based migrations)
- **Manual versioning in code**: Current approach (doesn't scale)
- **Delete-and-rebuild on version mismatch**: Too destructive (loses incremental mode benefits)

# Acceptance Criteria

- [ ] `get_current_version()` implemented and tested
- [ ] `apply_migrations()` implemented with sorted file processing
- [ ] Migration 001 created for `target_uid` column
- [ ] `apply_schema()` refactored to call migration runner
- [ ] Test: Fresh DB applies all migrations in order
- [ ] Test: Existing v1 DB upgrades to latest version
- [ ] Test: Query scripts warn on version mismatch (newer DB)
- [ ] Documentation updated in `references/indexing.md`

# Risks / Dependencies

- **Risk**: Migration script errors leave DB in inconsistent state → Wrap in transaction, rollback on failure
- **Risk**: Users manually edit `schema_version` → Document as internal-only field
- **Dependency**: Must not break existing DBs (test with pre-migration DB snapshot)

# Worklog

2026-01-07 14:26 [agent=copilot] Created from template.
2026-01-07 14:27 [agent=copilot] Populated migration framework design: version detection, numbered SQL scripts in references/migrations/, auto-upgrade on rebuild, backward compatibility checks.
2026-01-07 15:12 [agent=copilot] Starting implementation: create migrations directory, implement version detection and migration runner.
2026-01-07 15:14 [agent=copilot] Implemented migration framework: get_current_version(), apply_migrations() with sorted file processing, auto-upgrade on rebuild. Tested with fresh DB (v0) and migration upgrade (v0→v1). Migration 001 skipped (target_uid already in base schema).
2026-01-07 15:14 [agent=copilot] Framework完成: get_current_version, apply_migrations自動升級, 已測試v0到v1
