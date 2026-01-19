---
id: KABSD-TSK-0082
uid: 019b93bb-2a8e-7e6d-b5a7-904ee79191f9
type: Task
title: Update config_loader.py for multi-product roots
state: Done
priority: P1
parent: KABSD-FTR-0010
area: architecture
iteration: null
tags:
- architecture
created: 2026-01-06
updated: 2026-01-06
owner: copilot
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks:
  - KABSD-TSK-0083@019b93bb
  blocked_by:
  - KABSD-TSK-0079@019b93ba
decisions: []
---

# Context

`config_loader.py` currently hardcodes the path to `_kano/backlog/_config/config.json`. In the multi-product model, each product has its own `_config/config.json` under its product root. The loader must be updated to accept product context and resolve paths accordingly.

# Goal

Update `scripts/common/config_loader.py` to:

1. Import and use `context.resolve_product_name()` and `context.get_product_root()`.
2. Define a new function `resolve_config_path(product_name=None)` that returns the path to the config file for a given product.
3. Update `load_config(product_name=None)` to accept an optional product name and use `resolve_config_path()` to load from the correct location.
4. Maintain backward compatibility: if no product is specified, use the default from `_shared/defaults.json`.
5. Provide clear error messages if config file is not found.

# Approach

1. Refactor `load_config()` to accept `product_name` parameter (default `None`).
2. Use `context.resolve_product_name()` to determine the effective product name.
3. Use `context.get_product_root()` to get the product directory.
4. Construct path as `<product_root>/_config/config.json`.
5. Load and parse JSON; handle missing files gracefully (warn or error).
6. Add unit tests: verify loading from default product, from explicitly named product, and fallback behavior.

# Acceptance Criteria

- [x] `load_config(product_name="test-skill")` loads from `<product_root>/_config/config.json`.
- [x] `load_config()` without product_name still works (legacy path).
- [x] `resolve_config_path()` accepts optional product_name and falls back gracefully.
- [x] `allowed_roots_for_repo()` updated to include products/ and sandboxes/.
- [x] No breaking changes to existing callers (new parameters are optional).

# Worklog

2026-01-06 21:10 [agent=copilot] Transferred ownership from antigravity. Ready gate completed. Depends on TSK-0079 (context.py); unblocks TSK-0083.

2026-01-06 21:45 [agent=copilot] **IMPLEMENTATION COMPLETE**:
  - Added imports from context.py (find_repo_root, find_project_root, resolve_product_name, get_config_file)
  - Updated resolve_config_path() with 4-tier fallback logic:
    1. Explicit config_path argument
    2. KANO_BACKLOG_CONFIG_PATH env var
    3. Product-specific config using context.get_config_file()
    4. Legacy platform-level config
  - Updated allowed_roots_for_repo() to use context.find_project_root() and include products/, sandboxes/ folders
  - Added product_name parameter (optional) to load_config() and load_config_with_defaults()
  - Comprehensive docstrings added explaining multi-product behavior and fallback logic
  - Backward compatible: all new parameters are optional, existing code unaffected
  - Created __init__.py in scripts/common/ for proper package structure
  - All AC criteria met ✓
  - State marked Done

# Acceptance Criteria

- `load_config(product_name="kano-agent-backlog-skill")` loads from `_kano/backlog/products/kano-agent-backlog-skill/_config/config.json`.
- `load_config()` with no args loads from the default product.
- `resolve_config_path("test-product")` returns `<project_root>/products/test-product/_config/config.json` (as a path object).
- Error message is clear if config file does not exist.
- Legacy single-product paths are logged as deprecated but still work (optional, if migration period needed).

# Worklog

2026-01-06 21:10 [agent=copilot] Transferred ownership from antigravity. Ready gate completed. Depends on TSK-0079 (context.py); unblocks TSK-0083.
