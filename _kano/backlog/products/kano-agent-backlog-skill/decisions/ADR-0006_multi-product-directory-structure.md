---
id: ADR-0006
title: Multi-Product Directory Structure and Naming Conventions
status: Accepted
decision_date: 2026-01-07
---

# Context

A monorepo containing multiple independent products (skills) needs a consistent directory layout that:
- Keeps products isolated from each other
- Supports independent configuration and indexing
- Allows shared tools and metadata at the platform level
- Scales to many products without directory explosion
- Maintains backward compatibility during migration

## Competing Designs

1. **Platform + Products model** (chosen):
   ```
   _kano/backlog/
     products/<product-name>/
       _config/
       items/
       decisions/
       views/
     _shared/
       defaults.json
   ```

2. **Flat product namespacing**:
   ```
   _kano/backlog/
     items/<product>-<type>/
     decisions/<product>/
     views/<product>/
   ```

3. **Single root (pre-migration)**:
   ```
   _kano/backlog/
     items/
     decisions/
     views/
   ```

# Decision

**Implement Platform + Products hierarchical model.**

Directory structure:

```
_kano/backlog/                          # Platform root
├── products/                           # Product container
│   ├── kano-agent-backlog-skill/       # First product
│   │   ├── _config/
│   │   │   └── config.json             # Product-specific config
│   │   ├── items/                      # Product's backlog items
│   │   │   ├── epics/0000/
│   │   │   ├── features/0000/
│   │   │   ├── userstories/0000/
│   │   │   ├── tasks/0000/
│   │   │   ├── tasks/0100/             # Buckets per 100 items
│   │   │   └── bugs/0000/
│   │   ├── decisions/                  # Product's ADRs
│   │   ├── views/                      # Product's dashboards
│   │   ├── _index/
│   │   │   └── backlog.sqlite3         # Product-isolated index
│   │   └── _meta/
│   │       ├── schema.md
│   │       ├── conventions.md
│   │       └── indexes.md              # Epic index registry
│   │
│   └── kano-commit-convention-skill/   # Second product
│       └── ... (same structure)
│
├── sandboxes/                          # Isolated test/demo environments
│   ├── kano-agent-backlog-skill/       # Can test schema changes here
│   └── kano-commit-convention-skill/
│
├── _shared/                            # Platform-level shared data
│   ├── defaults.json                   # { "default_product": "..." }
│   └── config_template.json            # Shared config seed
│
├── _meta/                              # Platform metadata (if needed)
├── _index/                             # Platform index (optional, future)
├── views/                              # Platform-level dashboards
│   ├── Dashboard_PlainMarkdown_Active.md
│   ├── Dashboard_PlainMarkdown_New.md
│   └── Dashboard_PlainMarkdown_Done.md
└── _logs/                              # Audit logs (platform-level)
    └── agent_tools/
        └── tool_invocations.jsonl
```

# Rationale

## 1. Isolation and Autonomy

Products live under `products/<name>/`:
- Team A manages `products/product-a/`
- Team B manages `products/product-b/`
- No namespace collisions, no coordination needed
- Clear ownership boundaries

## 2. Scalability

Hierarchical structure scales linearly:
- 2 products: 2 directories
- 10 products: 10 directories
- 100 products: 100 directories
- No explosion of files at top level

## 3. Unified Schema Across Products

Each product has identical internal structure:
- All products use `items/`, `decisions/`, `views/`, `_config/`, `_meta/`
- Tools can be generic: "for each product, scan `items/`"
- Reduces special-case logic in scripts

## 4. Backward Compatibility

Existing KABSD backlog migrates as:
- Old: `_kano/backlog/items/task/0000/KABSD-TSK-0007.md`
- New: `_kano/backlog/products/kano-agent-backlog-skill/items/task/0000/KABSD-TSK-0007.md`

Path change is clean; no file modifications required. Git correctly tracks as renames.

## 5. Per-Product Isolation in Indexing

Each product gets:
- Own SQLite database: `products/<name>/_index/backlog.sqlite3`
- Own metadata: `products/<name>/_meta/indexes.md`
- Own config: `products/<name>/_config/config.json`

Rebuild product A's index without touching product B.

## 6. Flexible Sandboxing

`sandboxes/<product-name>/` allows safe testing:
- Develop schema changes on test data
- Run migration scripts without affecting production backlog
- Easy cleanup: just delete sandbox directory

## 7. Platform-Level Aggregation (Future)

`_shared/` and `_index/` support future features:
- Global embedding database
- Cross-product analytics dashboards
- Unified search index (optional, opt-in)

Products remain independent; platform layer is additive.

# Implementation

### Path Resolution

All scripts use context.py for product-aware resolution:

```python
from context import get_product_root, get_items_dir

product_name = args.product or os.getenv("KANO_PRODUCT") or defaults["default_product"]
product_root = get_product_root(product_name)  # _kano/backlog/products/<name>
items_dir = get_items_dir(product_name)        # products/<name>/items
```

### Configuration

- Platform level: `_kano/backlog/_shared/defaults.json` (default product)
- Product level: `products/<name>/_config/config.json` (product-specific)

Fallback chain:
1. CLI `--product` flag
2. `KANO_PRODUCT` environment variable
3. Product embedded in filename (e.g., task parsing)
4. `defaults.json` default_product
5. Hardcoded fallback: "kano-agent-backlog-skill"

### CLI Integration

All major scripts accept `--product` flag:

```bash
scripts/backlog/workitem_create.py --product kano-agent-backlog-skill --type task --title "..."
scripts/backlog/index_db.py --product kano-commit-convention-skill
```

# Alternatives Considered

### Flat namespacing
```
items/kabsd-tasks/0000/
items/kccs-features/0000/
```
- **Cons**: No clear product boundaries, harder to extend to 100 products
- **Rejected**: Doesn't scale well

### Single legacy structure
- **Cons**: Cannot coexist multiple products, forces coordination
- **Rejected**: Defeats purpose of monorepo autonomy

# References

- [[KABSD-FTR-0010]]: Monorepo Platform Migration feature
- [[KABSD-TSK-0081]]: Directory migration implementation
- [[ADR-0004]]: Per-Product Index Architecture
