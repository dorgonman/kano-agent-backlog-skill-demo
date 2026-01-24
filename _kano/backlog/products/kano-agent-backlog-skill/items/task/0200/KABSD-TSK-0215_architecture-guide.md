---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: null
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: null
parent: null
priority: P2
state: Proposed
tags: []
title: null
type: null
uid: 019bf086-c324-73eb-adc7-4288521824da
updated: '2026-01-16'
---

# Multi-Product Architecture Guide

## Overview

This project uses a **Platform + Multi-Product** model where multiple independent skill/product projects coexist within a single monorepo backlog system.

### Directory Structure

```
_kano/backlog/
├── products/
│   ├── kano-agent-backlog-skill/     # First product (main)
│   │   ├── items/                    # Backlog items (epics, features, tasks, bugs)
│   │   ├── decisions/                # Architecture Decision Records (ADRs)
│   │   ├── views/                    # Obsidian dashboards
│   │   ├── _config/config.json       # Product-specific configuration
│   │   ├── _meta/                    # Metadata registry
│   │   └── _index/backlog.sqlite3    # Product-isolated SQLite index
│   │
│   └── kano-commit-convention-skill/ # Second product (separate team)
│       └── (identical structure)
│
├── _shared/                          # Shared platform defaults
│   └── defaults.json                 # default_product, fallback settings
│
└── sandboxes/                        # Isolated testing environments
    └── <product-name>/               # Test structures here safely
```

## Key Principles

### 1. Product Isolation

Each product owns its own:
- **Backlog items**: `products/<name>/items/`
- **Architecture decisions**: `products/<name>/decisions/`
- **Configuration**: `products/<name>/_config/config.json`
- **SQLite index**: `products/<name>/_index/backlog.sqlite3`
- **Metadata**: `products/<name>/_meta/`

No cross-product data sharing. Changes to one product don't affect others.

### 2. Autonomous Indexing

Each product can rebuild its SQLite index independently:

```bash
# Rebuild KABSD's index only
python scripts/indexing/build_sqlite_index.py --product kano-agent-backlog-skill

# Rebuild KCCS's index only
python scripts/indexing/build_sqlite_index.py --product kano-commit-convention-skill
```

### 3. Per-Product CLI Usage

All CLI scripts accept `--product` flag for explicit product selection:

```bash
# Create task in KABSD
python scripts/backlog/workitem_create.py \
  --product kano-agent-backlog-skill \
  --type task \
  --title "Fix critical bug"

# Create task in KCCS
python scripts/backlog/workitem_create.py \
  --product kano-commit-convention-skill \
  --type task \
  --title "Add new validation rule"
```

### 4. Fallback Resolution Chain

When `--product` is not specified, the system tries:

1. **CLI argument**: `--product kano-agent-backlog-skill`
2. **Environment variable**: `export KANO_PRODUCT=kano-commit-convention-skill`
3. **Product in filename**: Auto-extracted from item ID (e.g., "KABSD-TSK-0007" → "kano-agent-backlog-skill")
4. **Defaults file**: `_shared/defaults.json` → `default_product`
5. **Hardcoded fallback**: "kano-agent-backlog-skill"

### 5. SQLite Index Isolation

Key design: **Composite primary key `(product, id)`**

```sql
-- Per-product index schema
CREATE TABLE items (
  product TEXT NOT NULL,      -- e.g., "kano-agent-backlog-skill"
  id TEXT NOT NULL,          -- e.g., "TSK-0007"
  uid UUID,
  type TEXT,
  state TEXT,
  PRIMARY KEY (product, id)
);

-- All child tables use composite keys
CREATE TABLE item_tags (
  product TEXT NOT NULL,
  item_id TEXT NOT NULL,
  tag TEXT NOT NULL,
  PRIMARY KEY (product, item_id, tag),
  FOREIGN KEY (product, item_id) REFERENCES items(product, id)
);
```

**Benefits**:
- No data leakage between products
- Self-documenting data (product context in schema)
- Prepared for future cross-product aggregation

## Common Tasks

### Creating a New Product

1. **Initialize structure**:
   ```bash
   python scripts/backlog/bootstrap_init_backlog.py \
     --agent copilot \
     --product my-new-product
   ```

2. **Verify created**:
   ```bash
   ls -la _kano/backlog/products/my-new-product/
   # Should show: items/, decisions/, views/, _config/, _meta/
   ```

### Creating Backlog Items in a Specific Product

```bash
# Task in KABSD
python scripts/backlog/workitem_create.py \
  --product kano-agent-backlog-skill \
  --type task \
  --title "Implement feature X" \
  --parent KABSD-FTR-0010

# Feature in KCCS
python scripts/backlog/workitem_create.py \
  --product kano-commit-convention-skill \
  --type feature \
  --title "Add new commit type"
```

### Updating Item State

```bash
python scripts/backlog/workitem_update_state.py \
  --product kano-agent-backlog-skill \
  --item-id KABSD-TSK-0097 \
  --state Done \
  --agent copilot
```

### Rebuilding a Product's Index

```bash
# Full rebuild for KABSD
python scripts/indexing/build_sqlite_index.py \
  --product kano-agent-backlog-skill

# Verify index
sqlite3 _kano/backlog/products/kano-agent-backlog-skill/_index/backlog.sqlite3 \
  "SELECT DISTINCT product FROM items;"
# Output: kano-agent-backlog-skill
```

### Searching Within a Product

```python
from lib.index import BacklogIndex

# Load KABSD's index
index = BacklogIndex(
    "_kano/backlog/products/kano-agent-backlog-skill/_index/backlog.sqlite3"
)

# Query product
items = index.get_all_items(state="Done", product="kano-agent-backlog-skill")

# Resolve reference
item = index.get_by_id("TSK-0007", product="kano-agent-backlog-skill")
```

## Path Resolution Patterns

### From Scripts

```python
from context import get_product_root, get_items_dir, get_config_path

product_name = args.product or os.getenv("KANO_PRODUCT") or "kano-agent-backlog-skill"

# Get product root
root = get_product_root(product_name)
# Returns: _kano/backlog/products/kano-agent-backlog-skill

# Get items directory
items_dir = get_items_dir(product_name)
# Returns: _kano/backlog/products/kano-agent-backlog-skill/items

# Get config path
config_path = get_config_path(product_name)
# Returns: _kano/backlog/products/kano-agent-backlog-skill/_config/config.json
```

### Directory Naming Rules

**Item buckets**: Per 100 items
- `items/tasks/0000/` ← items 0-99
- `items/tasks/0100/` ← items 100-199
- `items/tasks/0200/` ← items 200-299

Automatic: `workitem_create.py` calculates bucket from next item number.

## CLI Tool Compatibility

**All tools updated for multi-product support**:

| Tool | Status | Notes |
|------|--------|-------|
| `workitem_create.py` | ✓ | `--product` flag, product fallback |
| `workitem_update_state.py` | ✓ | Product filtering |
| `workitem_validate_ready.py` | ✓ | Per-product validation |
| `view_generate.py` | ✓ | Per-product dashboard generation |
| `index_db.py` | ✓ | Per-product indexing |
| `bootstrap_init_backlog.py` | ✓ | Product initialization |
| `bootstrap_init_project.py` | ✓ | Project-level setup |

**Usage pattern** (all tools):
```bash
<script.py> --product <name> [other args]
```

## Configuration

### Platform Defaults

File: `_kano/backlog/_shared/defaults.json`

```json
{
  "default_product": "kano-agent-backlog-skill",
  "views": {
    "auto_refresh": true
  },
  "sandbox_enabled": true
}
```

### Product-Specific Config

File: `_kano/backlog/products/<name>/_config/config.json`

```json
{
  "project": {
    "name": "kano-agent-backlog-skill",
    "prefix": "KABSD"
  },
  "views": {
    "auto_refresh": true
  }
}
```

## Future Enhancements

### Cross-Product Features (Deferred)

Planned for future iterations:

1. **Global embedding database**: Aggregate embeddings from all products
2. **Cross-product search**: Unified query across all products  
3. **Dependency visualization**: Show task dependencies across products
4. **Portfolio analytics**: Aggregated metrics across products

All possible without breaking product isolation. Product column in schema already prepared for these.

### Backward Compatibility

Existing tools gracefully handle missing `--product`:
- Default to `default_product` from config
- Can read product from item ID prefix (KABSD-TSK-0007 → "kano-agent-backlog-skill")
- Maintains compatibility with automation scripts

## Troubleshooting

### Item Not Found

```bash
# Check in which product it exists
sqlite3 _kano/backlog/products/kano-agent-backlog-skill/_index/backlog.sqlite3 \
  "SELECT id FROM items WHERE id LIKE '%0097%';"

# Search other products if not found
sqlite3 _kano/backlog/products/kano-commit-convention-skill/_index/backlog.sqlite3 \
  "SELECT id FROM items WHERE id LIKE '%0097%';"
```

### Index Out of Sync

```bash
# Rebuild specific product's index
python scripts/indexing/build_sqlite_index.py \
  --product kano-agent-backlog-skill

# Verify rebuild
sqlite3 _kano/backlog/products/kano-agent-backlog-skill/_index/backlog.sqlite3 \
  "SELECT COUNT(*) FROM items;"
```

### Default Product Not Working

Check fallback chain:
```bash
# 1. Check CLI flag
./script.py --product kano-agent-backlog-skill ...

# 2. Check environment variable
echo $KANO_PRODUCT

# 3. Check defaults.json
cat _kano/backlog/_shared/defaults.json | grep default_product

# 4. Check if product directory exists
ls -la _kano/backlog/products/
```

## References

- [[ADR-0016_per-product-isolated-index-architecture]]: Per-Product Isolated Index Architecture
- [[ADR-0017_product-column-retention-rationale]]: Product Column Retention Rationale
- [[_kano/backlog/products/kano-agent-backlog-skill/decisions/ADR-0006_multi-product-directory-structure.md]]: Multi-Product Directory Structure
- [[_kano/backlog/products/kano-agent-backlog-skill/items/feature/0000/KABSD-FTR-0010_monorepo-platform-migration.md]]: Monorepo Platform Migration

# Worklog

2026-01-16 11:40 [agent=codex] [model=GPT-5.2-Codex] Remapped ID: KABSD-TSK-0215 -> KABSD-TSK-0214.
2026-01-16 11:41 [agent=codex] [model=GPT-5.2-Codex] Remapped ID: KABSD-TSK-0096 -> KABSD-TSK-0215.
2026-01-16 13:58 [agent=q-developer] [model=nova-pro] Auto-fixed missing fields: id, type, title, state, created, updated, priority, parent, owner, tags, area, iteration, external, links, decisions
