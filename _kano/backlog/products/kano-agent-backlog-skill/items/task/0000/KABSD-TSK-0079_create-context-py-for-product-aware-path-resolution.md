---
id: KABSD-TSK-0079
uid: 019b93ba-db8a-7965-b77c-a45fac6f7bf7
type: Task
title: Create context.py for product-aware path resolution
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
  - KABSD-TSK-0080@019b93bb
  - KABSD-TSK-0082@019b93bb
  blocked_by: []
decisions: []
---

# Context

We need a centralized way to resolve paths in the new monorepo structure, taking into account the current product context and sandbox settings. Currently, path resolution is hardcoded or scattered across scripts, making it difficult to support multiple products.

# Goal

Implement `skills/kano-agent-backlog-skill/scripts/common/context.py` as a single source of truth for path resolution. The module should provide:

1. `find_repo_root()` — locate the workspace root (where `.git` exists).
2. `find_platform_root(repo_root)` — locate `_kano/backlog` (platform root).
3. `resolve_product_name(product_arg=None, env_var=None, defaults_file=None)` — resolve product name via arg → environment variable → `_shared/defaults.json` → fallback to `"kano-agent-backlog-skill"`.
4. `get_product_root(product_name)` — return `_kano/backlog/products/<product_name>`.
5. `get_sandbox_root(product_name)` — return `_kano/backlog/sandboxes/<product_name>`.
6. `load_shared_defaults()` — parse `_kano/backlog/_shared/defaults.json` and return a dict.

# Approach

1. Define helper functions for directory discovery (repo root, platform root).
2. Implement product name resolution with clear priority: argument → environment → defaults file → hardcoded fallback.
3. Ensure paths are returned as `pathlib.Path` objects (or strings as needed by callers).
4. Add minimal error handling (raise informative exceptions if paths do not exist).
5. Write docstrings explaining fallback behavior.

# Acceptance Criteria

- [x] `context.py` exists and is importable: `from scripts.common.context import ...`
- [x] `find_repo_root()` correctly locates the workspace root.
- [x] `find_platform_root()` correctly locates `_kano/backlog`.
- [x] `resolve_product_name(product_arg="test")` returns `"test"`.
- [x] `resolve_product_name()` with no args returns the default product from `_shared/defaults.json`.
- [x] `get_product_root("kano-agent-backlog-skill")` returns `<platform_root>/products/kano-agent-backlog-skill`.
- [x] `get_sandbox_root("test-product")` returns `<platform_root>/sandboxes/test-product`.
- [x] `load_shared_defaults()` correctly parses JSON and returns a dict.

# Worklog

2026-01-06 21:10 [agent=copilot] Transferred ownership from antigravity. Ready gate completed. This is the foundational task for monorepo architecture; blocks TSK-0080, TSK-0082, and TSK-0084.

2026-01-06 21:25 [agent=copilot] **IMPLEMENTATION COMPLETE**: Replaced context.py with comprehensive version including:
  - `find_repo_root()` with .git search
  - `find_platform_root()` with validation
  - `load_shared_defaults()` for JSON parsing
  - `resolve_product_name()` with 4-tier priority chain
  - `get_product_root()`, `get_sandbox_root()`, and optional _or_none() variants
  - Helper functions for items/, decisions/, views/, _config/, _config/config.json
  - Convenience `get_context()` for single-call resolution
  - Comprehensive docstrings and type hints
  - Smoke tested: all functions import and resolve correctly
  - Marked as InProgress; ready to unblock dependent tasks (TSK-0080, TSK-0082, TSK-0084)

2026-01-07 02:25 [agent=copilot] **TASK COMPLETE - All 8 AC met**: context.py fully implemented and tested. All dependent tasks (TSK-0080, TSK-0082, TSK-0084, TSK-0085) have successfully used context.py functions. Marking as Done.
