---
id: KABSD-TSK-0083
uid: 019b93bb-3c9e-7e6d-b5a7-904ee79191f9
type: Task
title: Update CLI scripts for product-aware execution
state: New
priority: P1
parent: KABSD-FTR-0010
area: architecture
iteration: null
tags:
- cli
created: 2026-01-06
updated: 2026-01-06
owner: copilot
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by:
  - KABSD-TSK-0082
decisions: []
---

# Context

All CLI scripts (e.g., `create_item.py`, `update_state.py`, `list_items.py`) currently assume a single backlog root. They need to accept `--product` and `--sandbox` flags to operate on the correct product's data.

# Goal

Update CLI argument parsers and execution paths in `scripts/backlog/` and `scripts/` to:

1. Accept `--product <name>` (optional, defaults to the product from `_shared/defaults.json` or `"kano-agent-backlog-skill"`).
2. Accept `--sandbox <path>` (optional, for test/demo isolation).
3. Use `context.py` to resolve the target product and sandbox directories.
4. Pass product context to lower-level functions (config loader, indexer, item reader/writer).
5. Update `--help` text to document the new options.

# Approach

1. Create a shared argument setup (e.g., `add_product_arguments(parser)`) in `scripts/common/` that all CLI scripts can reuse.
2. Update each CLI script's argument parser to call `add_product_arguments()`.
3. In each script's main logic, extract the product name from parsed args and pass it to context functions.
4. Update item I/O functions to use `context.get_product_root()` instead of hardcoded paths.
5. Test each CLI with `--product <name>` to verify correct folder resolution.

# Acceptance Criteria

- `python scripts/backlog/create_item.py --product test-skill --type Task --title "Sample" --agent copilot` creates items under the test-skill product.
- `python scripts/backlog/list_items.py --product test-skill` lists items from test-skill only.
- `--help` for each script mentions `--product` and `--sandbox` options.
- Default behavior (no `--product` flag) uses the default product from config.
- Scripts work for multiple products without modification.

# Worklog

2026-01-06 21:10 [agent=copilot] Transferred ownership from antigravity. Ready gate completed. Depends on TSK-0082 (config loader); unblocks TSK-0085.
