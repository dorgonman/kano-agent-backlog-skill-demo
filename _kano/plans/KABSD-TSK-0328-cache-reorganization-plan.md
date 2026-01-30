# KABSD-TSK-0328: Cache Reorganization and Cleanup Plan

**Task**: Reorganize cache structure and clean up obsolete directories
**Created**: 2026-01-31
**Agent**: opencode (Prometheus)

---

## 📊 Current State Analysis

### Current Cache Structure (`.cache/`)
```
.cache/
├── opencode/                           # Keep (OpenCode CLI cache)
├── repo_chunks.sqlite3                 # Move & Rename (46M)
├── repo_build_status.json              # Move & Rename (307 bytes)
└── vectors/
    ├── repo_chunks.af3c739f96c8.sqlite3    # Move & Rename (213M)
    └── repo_chunks.af3c739f96c8.meta.json  # Move & Rename (605 bytes)
```

### Obsolete Directories in `_kano/backlog/`
```
_kano/backlog/
├── items/          # REMOVE (empty, superseded by products/<product>/items/)
├── views/          # REMOVE (empty, superseded by products/<product>/views/)
├── sandboxes/      # REMOVE (old testing directory)
└── _tmp_tests/     # REMOVE (temporary test directory)
```

### Target Structure (`.kano/cache/backlog/`)
```
.kano/cache/backlog/
├── chunks.repo.v1.db                           # Renamed from repo_chunks.sqlite3
├── chunks.repo.v1.status                       # Renamed from repo_build_status.json
├── vectors.repo.noop-d1536.af3c739f.db        # Flattened & renamed
└── vectors.repo.noop-d1536.af3c739f.meta      # Flattened & renamed
```

---

## 🎯 Naming Convention Design

### Rationale
1. **Corpus-aware**: Support both `repo` and `backlog` corpus
2. **Windows-safe**: Total path length < 100 chars (well under 260 limit)
3. **Self-documenting**: File name explains content
4. **Collision-free**: Different configs won't overwrite each other

### Patterns

**Chunks Database:**
```
chunks.{corpus}.{version}.db
chunks.{corpus}.{version}.status
```
- `corpus`: `repo` | `backlog`
- `version`: `v1`, `v2`, etc. (chunking strategy version)
- Extension: `.db` (SQLite), `.status` (JSON status file)

**Vectors Database:**
```
vectors.{corpus}.{embedding-short}.{hash-8}.db
vectors.{corpus}.{embedding-short}.{hash-8}.meta
```
- `corpus`: `repo` | `backlog`
- `embedding-short`: Simplified embedding model ID (e.g., `noop-d1536`, `openai-3small-d1536`)
- `hash-8`: First 8 chars of config hash (from meta.json)
- Extension: `.db` (SQLite), `.meta` (JSON metadata)

### Example Mappings

| Old Path | New Path | Size |
|----------|----------|------|
| `.cache/repo_chunks.sqlite3` | `.kano/cache/backlog/chunks.repo.v1.db` | 46M |
| `.cache/repo_build_status.json` | `.kano/cache/backlog/chunks.repo.v1.status` | 307B |
| `.cache/vectors/repo_chunks.af3c739f96c8.sqlite3` | `.kano/cache/backlog/vectors.repo.noop-d1536.af3c739f.db` | 213M |
| `.cache/vectors/repo_chunks.af3c739f96c8.meta.json` | `.kano/cache/backlog/vectors.repo.noop-d1536.af3c739f.meta` | 605B |

---

## 📝 Implementation Plan

### Phase 1: Create New Directory Structure

**Action**: Create `.kano/cache/backlog/` directory

**Commands**:
```bash
# Unix/Linux/macOS
mkdir -p .kano/cache/backlog

# Windows PowerShell
New-Item -ItemType Directory -Force -Path .kano\cache\backlog
```

**Verification**: Directory exists and is writable

---

### Phase 2: Update Code to Generate New Paths

**Files to Modify**:

#### 2.1 `src/kano_backlog_ops/repo_chunks_db.py`

**Current behavior**: Generates `.cache/repo_chunks.sqlite3`

**Changes needed**:
- Update default DB path to `.kano/cache/backlog/chunks.repo.v1.db`
- Update status file path to `.kano/cache/backlog/chunks.repo.v1.status`
- Add corpus parameter support (default: `repo`)

**Key functions to update**:
- `get_default_db_path()` or similar path generation logic
- Status file path generation

#### 2.2 `src/kano_backlog_ops/repo_chunks_db_async.py`

**Current behavior**: Async version of chunks DB

**Changes needed**:
- Same path updates as `repo_chunks_db.py`
- Ensure consistency between sync and async versions

#### 2.3 `src/kano_backlog_ops/repo_vector_index.py`

**Current behavior**: Generates `.cache/vectors/repo_chunks.{hash}.sqlite3`

**Changes needed**:
- Update vector DB path to `.kano/cache/backlog/vectors.{corpus}.{embedding-short}.{hash-8}.db`
- Update meta file path to `.kano/cache/backlog/vectors.{corpus}.{embedding-short}.{hash-8}.meta`
- Extract embedding model short name from `embedding_space_id`
- Truncate hash to 8 characters

**Key logic**:
```python
# Extract from embedding_space_id:
# "corpus:repo|emb:noop:noop-embedding:d1536|tok:heuristic:text-embedding-3-small:max8192|chunk:chunk-v1|metric:cosine"

def parse_embedding_space_id(space_id: str) -> dict:
    """Parse embedding_space_id into components."""
    parts = {}
    for segment in space_id.split('|'):
        key, value = segment.split(':', 1)
        parts[key] = value
    return parts

def get_embedding_short_name(emb_component: str) -> str:
    """Convert 'noop:noop-embedding:d1536' to 'noop-d1536'."""
    parts = emb_component.split(':')
    model_type = parts[0]  # 'noop'
    dimensions = parts[-1]  # 'd1536'
    return f"{model_type}-{dimensions}"

def get_vector_db_path(corpus: str, embedding_space_id: str, config_hash: str) -> Path:
    """Generate new vector DB path."""
    components = parse_embedding_space_id(embedding_space_id)
    emb_short = get_embedding_short_name(components['emb'])
    hash_short = config_hash[:8]
    
    return Path(f".kano/cache/backlog/vectors.{corpus}.{emb_short}.{hash_short}.db")
```

#### 2.4 `src/kano_backlog_ops/repo_vector_query.py`

**Current behavior**: Queries vector DB

**Changes needed**:
- Update path resolution to use new naming convention
- Ensure compatibility with new meta file format

#### 2.5 Configuration Files

**Files to check**:
- `src/kano_backlog_core/config.py` - Default cache paths
- `_kano/backlog/_shared/defaults.toml` - Default configuration

**Changes needed**:
- Update default cache directory to `.kano/cache/backlog/`
- Add configuration options for corpus-specific paths

---

### Phase 3: Create Migration Script

**File**: `scripts/migrate-cache-v003.sh` (Unix) and `scripts/migrate-cache-v003.ps1` (Windows)

**Script Logic**:

```bash
#!/bin/bash
# migrate-cache-v003.sh - Migrate cache structure for v0.0.3

set -e

echo "🔄 Migrating cache structure to v0.0.3..."

# Check if old structure exists
if [ ! -d ".cache" ]; then
    echo "✅ No old cache structure found. Nothing to migrate."
    exit 0
fi

# Create new directory
echo "📁 Creating .kano/cache/backlog/..."
mkdir -p .kano/cache/backlog

# Migrate chunks database
if [ -f ".cache/repo_chunks.sqlite3" ]; then
    echo "📦 Migrating chunks database..."
    cp .cache/repo_chunks.sqlite3 .kano/cache/backlog/chunks.repo.v1.db
    echo "  ✓ chunks.repo.v1.db ($(du -h .cache/repo_chunks.sqlite3 | cut -f1))"
fi

# Migrate build status
if [ -f ".cache/repo_build_status.json" ]; then
    echo "📊 Migrating build status..."
    cp .cache/repo_build_status.json .kano/cache/backlog/chunks.repo.v1.status
    echo "  ✓ chunks.repo.v1.status"
fi

# Migrate vectors
if [ -d ".cache/vectors" ]; then
    echo "🔢 Migrating vector databases..."
    for db in .cache/vectors/*.sqlite3; do
        if [ -f "$db" ]; then
            # Extract hash from filename: repo_chunks.af3c739f96c8.sqlite3 -> af3c739f96c8
            basename=$(basename "$db")
            hash=$(echo "$basename" | sed 's/repo_chunks\.\(.*\)\.sqlite3/\1/')
            hash_short=${hash:0:8}
            
            # Copy database
            cp "$db" ".kano/cache/backlog/vectors.repo.noop-d1536.${hash_short}.db"
            echo "  ✓ vectors.repo.noop-d1536.${hash_short}.db ($(du -h "$db" | cut -f1))"
            
            # Copy meta file if exists
            meta="${db%.sqlite3}.meta.json"
            if [ -f "$meta" ]; then
                cp "$meta" ".kano/cache/backlog/vectors.repo.noop-d1536.${hash_short}.meta"
                echo "  ✓ vectors.repo.noop-d1536.${hash_short}.meta"
            fi
        fi
    done
fi

echo ""
echo "✅ Migration complete!"
echo ""
echo "📋 Summary:"
echo "  Old location: .cache/"
echo "  New location: .kano/cache/backlog/"
echo ""
echo "⚠️  Old files are preserved. To remove them:"
echo "  rm -rf .cache/repo_chunks.sqlite3 .cache/repo_build_status.json .cache/vectors/"
echo ""
```

**PowerShell version** (`migrate-cache-v003.ps1`): Similar logic adapted for Windows

---

### Phase 4: Clean Up Obsolete Directories

**Directories to Remove**:

```bash
# After confirming they are empty or obsolete
rm -rf _kano/backlog/items/
rm -rf _kano/backlog/views/
rm -rf _kano/backlog/sandboxes/
rm -rf _kano/backlog/_tmp_tests/
```

**Safety checks**:
1. Verify directories are empty or contain only obsolete files
2. Check git status to ensure no uncommitted work
3. Create backup if uncertain

**Script addition** (add to migration script):

```bash
echo "🧹 Cleaning up obsolete directories..."

# Function to safely remove directory
safe_remove() {
    local dir=$1
    if [ -d "$dir" ]; then
        if [ -z "$(ls -A "$dir")" ]; then
            echo "  🗑️  Removing empty directory: $dir"
            rm -rf "$dir"
        else
            echo "  ⚠️  Directory not empty, skipping: $dir"
            echo "     Please review contents manually."
        fi
    fi
}

safe_remove "_kano/backlog/items"
safe_remove "_kano/backlog/views"
safe_remove "_kano/backlog/sandboxes"
safe_remove "_kano/backlog/_tmp_tests"

echo "✅ Cleanup complete!"
```

---

### Phase 5: Update Documentation

**Files to Update**:

#### 5.1 `README.md`

**Section**: Cache structure

**Add**:
```markdown
## Cache Structure

The backlog skill stores cache files in `.kano/cache/backlog/`:

```
.kano/cache/backlog/
├── chunks.{corpus}.{version}.db          # Document chunks database
├── chunks.{corpus}.{version}.status      # Build status
├── vectors.{corpus}.{emb}.{hash}.db      # Vector embeddings database
└── vectors.{corpus}.{emb}.{hash}.meta    # Vector metadata
```

**Corpus types**:
- `repo`: Repository code and documentation
- `backlog`: Backlog work items (future)

**Example files**:
- `chunks.repo.v1.db` - Repository chunks (46M)
- `vectors.repo.noop-d1536.af3c739f.db` - Vector embeddings (213M)
```

#### 5.2 `docs/releases/0.0.3.md`

**Add migration section**:
```markdown
### Cache Structure Migration

Version 0.0.3 reorganizes cache files for better clarity and Windows compatibility.

**Migration required**: Run the migration script to move existing cache files:

```bash
# Unix/Linux/macOS
bash scripts/migrate-cache-v003.sh

# Windows PowerShell
.\scripts\migrate-cache-v003.ps1
```

**What changes**:
- Cache location: `.cache/` → `.kano/cache/backlog/`
- Naming: Corpus-aware, descriptive names
- Structure: Flattened (no nested `vectors/` directory)

**Old files are preserved** - you can safely remove them after verifying the migration.
```

#### 5.3 `skills/kano-agent-backlog-skill/CHANGELOG.md`

**Add entry**:
```markdown
### Changed
- **BREAKING**: Cache structure reorganized to `.kano/cache/backlog/` with corpus-aware naming
- Flattened vector database directory structure
- Shortened file names to avoid Windows path length limits

### Migration
- Run `scripts/migrate-cache-v003.sh` (Unix) or `scripts/migrate-cache-v003.ps1` (Windows)
- Old cache files in `.cache/` are preserved for safety
```

---

## ✅ Acceptance Criteria Checklist

- [ ] `.kano/cache/backlog/` directory created
- [ ] All cache files follow new naming convention:
  - [ ] `chunks.{corpus}.{version}.db`
  - [ ] `chunks.{corpus}.{version}.status`
  - [ ] `vectors.{corpus}.{emb}.{hash}.db`
  - [ ] `vectors.{corpus}.{emb}.{hash}.meta`
- [ ] Code updated to generate new paths:
  - [ ] `repo_chunks_db.py`
  - [ ] `repo_chunks_db_async.py`
  - [ ] `repo_vector_index.py`
  - [ ] `repo_vector_query.py`
  - [ ] Configuration files
- [ ] Migration scripts created:
  - [ ] `scripts/migrate-cache-v003.sh`
  - [ ] `scripts/migrate-cache-v003.ps1`
- [ ] Obsolete directories removed:
  - [ ] `_kano/backlog/items/`
  - [ ] `_kano/backlog/views/`
  - [ ] `_kano/backlog/sandboxes/`
  - [ ] `_kano/backlog/_tmp_tests/`
- [ ] Documentation updated:
  - [ ] `README.md`
  - [ ] `docs/releases/0.0.3.md`
  - [ ] `CHANGELOG.md`
- [ ] Migration tested on clean installation
- [ ] Migration tested on existing installation
- [ ] Backward compatibility verified (old code can still read new structure)

---

## 🚨 Risks and Mitigations

### Risk 1: Breaking Existing Installations
**Mitigation**: 
- Provide clear migration script
- Preserve old files (copy, not move)
- Add fallback logic to check old paths if new paths don't exist

### Risk 2: Windows Path Length Issues
**Mitigation**:
- Keep total path length < 100 chars
- Use shortened hash (8 chars instead of 12)
- Test on Windows before release

### Risk 3: Data Loss During Migration
**Mitigation**:
- Migration script uses `cp` not `mv` (preserves originals)
- Add verification step to compare file sizes
- Document manual rollback procedure

### Risk 4: Incomplete Migration
**Mitigation**:
- Migration script checks for all expected files
- Provides clear success/failure messages
- Logs all operations for debugging

---

## 🔄 Testing Plan

### Test 1: Fresh Installation
1. Clone repo to new directory
2. Run `kano-backlog embedding build`
3. Verify files created in `.kano/cache/backlog/` with new names
4. Verify search works: `kano-backlog search query "test"`

### Test 2: Migration from v0.0.2
1. Set up v0.0.2 installation with existing cache
2. Run migration script
3. Verify all files copied correctly
4. Verify file sizes match
5. Verify search still works
6. Verify old files still exist (not deleted)

### Test 3: Windows Compatibility
1. Test on Windows 10/11
2. Verify path lengths < 260 chars
3. Verify migration script works in PowerShell
4. Verify no path separator issues

### Test 4: Backward Compatibility
1. Keep old cache structure
2. Update code to check both old and new paths
3. Verify graceful fallback to old paths if new paths don't exist

---

## 📦 Deliverables

1. **Code Changes**:
   - Updated path generation in 4 Python files
   - Updated configuration defaults

2. **Migration Scripts**:
   - `scripts/migrate-cache-v003.sh` (Unix)
   - `scripts/migrate-cache-v003.ps1` (Windows)

3. **Documentation**:
   - Updated `README.md`
   - Updated `docs/releases/0.0.3.md`
   - Updated `CHANGELOG.md`

4. **Cleanup**:
   - Removed 4 obsolete directories from `_kano/backlog/`

---

## 🎯 Success Metrics

- ✅ All cache files in `.kano/cache/backlog/`
- ✅ File names are self-documenting
- ✅ Path lengths < 100 chars (Windows-safe)
- ✅ Migration script works on Unix and Windows
- ✅ No data loss during migration
- ✅ Search functionality works with new structure
- ✅ Documentation is clear and complete

---

## 📅 Estimated Effort

- **Phase 1**: 15 minutes (directory creation)
- **Phase 2**: 2-3 hours (code updates and testing)
- **Phase 3**: 1-2 hours (migration script development)
- **Phase 4**: 30 minutes (cleanup)
- **Phase 5**: 1 hour (documentation)

**Total**: 5-7 hours

---

## 🚀 Next Steps

To execute this plan:

```bash
# Option 1: Use Sisyphus to execute automatically
/start-work KABSD-TSK-0328

# Option 2: Manual execution
# Follow each phase in order, checking off acceptance criteria
```

---

**Plan created by**: Prometheus (opencode)
**Date**: 2026-01-31
**Task**: KABSD-TSK-0328
