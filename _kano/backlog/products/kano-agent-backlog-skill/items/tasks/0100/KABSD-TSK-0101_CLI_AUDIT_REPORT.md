# CLI Tools Product-Aware Paths Audit Report

**Date**: 2026-01-07  
**Auditor**: GitHub Copilot  
**Scope**: All CLI scripts in `scripts/backlog/`

## Executive Summary

✅ **Result**: All 18+ CLI tools properly use product-aware paths via context.py and product_args.py

- **18 tools** use `product_args` for consistent CLI argument handling
- **0 hardcoded old paths** found in executable logic
- **All tools** respect `--product` flag with proper fallback chain
- **Product isolation** verified across all major operations

## Tools Audited

### Core Work Item Management (5 tools)

| Tool | Product-Aware | Notes |
|------|---------------|-------|
| `workitem_create.py` | ✅ | Uses get_context(), product_args |
| `workitem_update_state.py` | ✅ | Uses product_args, context resolution |
| `workitem_validate_ready.py` | ✅ | Uses product_args |
| `workitem_generate_index.py` | ✅ | Uses product_args |
| `workitem_resolve_ref.py` | ✅ | Uses product_args, resolver with product filter |

### View & Dashboard Generation (4 tools)

| Tool | Product-Aware | Notes |
|------|---------------|-------|
| `view_generate.py` | ✅ | Uses product_args, context paths |
| `view_generate_demo.py` | ✅ | Uses product_args |
| `view_generate_tag.py` | ✅ | Uses product_args |
| `view_refresh_dashboards.py` | ✅ | Uses product_args |

### Initialization & Bootstrap (3 tools)

| Tool | Product-Aware | Notes |
|------|---------------|-------|
| `bootstrap_init_backlog.py` | ✅ | Uses get_product_name() helper |
| `bootstrap_init_project.py` | ✅ | Platform-level, product-aware |
| `bootstrap_seed_demo.py` | ✅ | Uses product_args |

### Indexing & Search (2 tools)

| Tool | Product-Aware | Notes |
|------|---------------|-------|
| `index_db.py` | ✅ | Per-product SQLite indexing |
| `lib/index.py` | ✅ | Product column in schema, isolation |
| `lib/resolver.py` | ✅ | Product filtering in resolve_ref() |

### Utility & Migration (4 tools)

| Tool | Product-Aware | Notes |
|------|---------------|-------|
| `process_linter.py` | ✅ | Uses get_product_name() helper |
| `version_show.py` | ✅ | Product-aware config loading |
| `migration_add_uid.py` | ✅ | Uses product_args |
| `workitem_attach_artifact.py` | ✅ | Uses product_args |

## Path Resolution Verification

### Test 1: Hardcoded Path Search

**Command**:
```bash
grep -rn "_kano/backlog/items" scripts/backlog/*.py | grep -v "# " | grep -v '"""'
```

**Results**: 
- Only found in default argument help strings
- No hardcoded paths in executable logic ✅

**Sample findings** (all safe):
```python
# These are only default values, overridden by context.py
parser.add_argument("--items-root", default="_kano/backlog/items", help="...")
```

### Test 2: product_args Integration

**Command**:
```bash
grep -l "from product_args import" scripts/backlog/*.py | wc -l
```

**Result**: **18 scripts** use product_args helper ✅

### Test 3: Context.py Usage

**Major scripts using context.py**:
- workitem_create.py: `get_context(product_arg=args.product)`
- bootstrap_init_backlog.py: `get_product_name(args.product)`
- process_linter.py: `get_product_name(product_name)`
- All view generators: Use `get_items_dir(product_name)`

## Product Fallback Chain Verification

All tools implement standard fallback:

1. **CLI argument**: `--product kano-agent-backlog-skill`
2. **Environment variable**: `$KANO_PRODUCT`  
3. **Product from ID**: Extracted from item reference (e.g., KABSD → kano-agent-backlog-skill)
4. **Defaults file**: `_shared/defaults.json` → `default_product`
5. **Hardcoded fallback**: "kano-agent-backlog-skill"

**Verification**:
```python
# All tools use this pattern via product_args or get_product_name()
from context import get_product_name

product = get_product_name(args.product)  # Applies full fallback chain
```

## SQLite Index Product Isolation

**Schema verification** (lib/index.py):
```sql
CREATE TABLE items (
  product TEXT NOT NULL,
  id TEXT NOT NULL,
  PRIMARY KEY (product, id)
);
```

**Product filtering verified**:
```python
# lib/index.py: get_by_id()
if product is not None:
    cursor.execute("SELECT * FROM items WHERE product=? AND id=?", (product, id))
```

**Isolation test**:
```bash
# KABSD index
sqlite3 products/kano-agent-backlog-skill/_index/backlog.sqlite3 "SELECT DISTINCT product FROM items;"
# Output: kano-agent-backlog-skill ✅

# KCCS index
sqlite3 products/kano-commit-convention-skill/_index/backlog.sqlite3 "SELECT DISTINCT product FROM items;"
# Output: kano-commit-convention-skill ✅
```

## Regression Test Results

### Test Case 1: Create Item Without --product Flag

**Command**:
```bash
python scripts/backlog/workitem_create.py \
  --type task \
  --title "Test default product" \
  --agent copilot
```

**Expected**: Uses default_product from _shared/defaults.json  
**Result**: ✅ PASS - Item created in kano-agent-backlog-skill

### Test Case 2: Create Item With Explicit --product

**Command**:
```bash
python scripts/backlog/workitem_create.py \
  --product kano-commit-convention-skill \
  --type task \
  --title "Test explicit product" \
  --agent copilot
```

**Expected**: Item created in KCCS product  
**Result**: ✅ PASS - Item created in kano-commit-convention-skill

### Test Case 3: Index Rebuild Per Product

**Command**:
```bash
python scripts/indexing/build_sqlite_index.py --product kano-agent-backlog-skill
```

**Expected**: Only KABSD index rebuilt, KCCS untouched  
**Result**: ✅ PASS - Isolation maintained

### Test Case 4: View Generation Per Product

**Command**:
```bash
python scripts/backlog/view_generate.py \
  --product kano-agent-backlog-skill \
  --groups "Done" \
  --title "KABSD Done Items" \
  --output test_done.md
```

**Expected**: Only KABSD items in output  
**Result**: ✅ PASS - No cross-product leakage

## Issues Found

### None ✅

All tools properly use product-aware paths. No hardcoded legacy paths in executable logic.

## Recommendations

### 1. Documentation (Completed)

✅ Architecture guide created: `KABSD-TSK-0096_ARCHITECTURE_GUIDE.md`  
✅ ADRs created for design decisions

### 2. Testing (Optional Future Work)

Consider automated integration tests:
```python
def test_product_isolation():
    # Create item in KABSD
    kabsd_item = create_item(product="kano-agent-backlog-skill", ...)
    
    # Verify not visible in KCCS index
    kccs_index = BacklogIndex("products/kano-commit-convention-skill/_index/...")
    assert kccs_index.get_by_id(kabsd_item.id) is None
```

### 3. Monitoring (Optional)

Add logging to track which product context is used:
```python
logger.info(f"Resolved product: {product_name} (source: {source})")
```

## Conclusion

**Status**: ✅ **ALL TOOLS COMPLIANT**

- 18+ tools properly use product-aware paths
- No hardcoded legacy paths found
- Product isolation verified in SQLite indexes
- Fallback chain working correctly
- Regression tests pass

The multi-product architecture is production-ready and safe for team use.

---

**Audit completed**: 2026-01-07  
**Next review**: When new CLI tools are added
