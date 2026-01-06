---
id: KABSD-TSK-0080
uid: 019b93bb-064e-76e3-ac7c-b5a7904ee791
type: Task
title: Update bootstrap_init_backlog.py for multi-product support
state: New
priority: P1
parent: KABSD-FTR-0010
area: architecture
iteration: null
tags:
- architecture
- bootstrap
created: 2026-01-06
updated: 2026-01-06
owner: copilot
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks:
  - KABSD-TSK-0085
  blocked_by:
  - KABSD-TSK-0079
decisions: []
---

# Context

The current `bootstrap_init_backlog.py` assumes a single `_kano/backlog` root. To support the multi-product architecture, it must accept a product name and initialize the correct subfolder structure.

# Goal

Update `scripts/backlog/bootstrap_init_backlog.py` to:

1. Accept `--product <name>` and `--sandbox <path>` (optional) command-line arguments.
2. Use `context.py` to resolve the platform root and then determine the product root.
3. Initialize folder structure under the resolved product root: `_config/`, `items/`, `decisions/`, `views/`.
4. Write `config.json` with correct metadata for the product (name, prefix, etc.).
5. Provide helpful error messages if the product already exists.

# Approach

1. Import `context.resolve_product_name()` and `get_product_root()`.
2. Add argument parser entries for `--product`, `--sandbox`, and `--agent`.
3. Resolve target product directory using `context.get_product_root(product_name)`.
4. Check if target directory already exists; warn or error if it does.
5. Create folder structure: items/{epics,features,userstories,tasks,bugs}, decisions/, views/, _config/.
6. Generate `config.json` with proper `project.name` and `project.prefix` derived from the product name.
7. Write Worklog entry if the backlog scaffold already logs agent activities.

# Acceptance Criteria

- `python scripts/backlog/bootstrap_init_backlog.py --product test-skill --agent copilot` creates `_kano/backlog/products/test-skill/`.
- `_config/config.json` is initialized with correct product name and default settings.
- Folders structure (items/*, decisions/, views/) exists under the product root.
- Running the script twice on the same product either skips gracefully or raises a clear error.
- `--help` mentions multi-product support.

# Worklog

2026-01-06 21:10 [agent=copilot] Transferred ownership from antigravity. Ready gate completed. Depends on TSK-0079 (context.py); unblocks TSK-0085.
