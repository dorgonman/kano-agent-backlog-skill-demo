---
id: KABSD-TSK-0085
uid: 019b93bb-60bf-7e6d-b5a7-904ee79191f9
type: Task
title: Initialize kano-commit-convention-skill and verify
state: New
priority: P1
parent: KABSD-FTR-0010
area: demo
iteration: null
tags:
- demo
- verification
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
  - KABSD-TSK-0080
  - KABSD-TSK-0083
decisions: []
---

# Context

Once all prior tasks are complete, we must verify the entire multi-product system works end-to-end. This task creates a second product (`kano-commit-convention-skill`) from scratch and confirms that product isolation is maintained.

# Goal

1. Run `bootstrap_init_backlog.py --product kano-commit-convention-skill --agent copilot` to create the new product structure.
2. Configure `_kano/backlog/products/kano-commit-convention-skill/_config/config.json` with:
   - `project.name`: `"kano-commit-convention-skill"`
   - `project.prefix`: `"KCCS"`
   - `process.path`: `"skills/kano-agent-backlog-skill/references/processes/jira-default.json"` (shared process definition)
3. Create a sample task in KCCS (e.g., `KCCS-TSK-0001`).
4. Verify isolation: query for KCCS items and confirm no KABSD items appear; vice versa.
5. Test cross-product operations (e.g., list all products, show summary by product).

# Approach

1. Use updated CLI with `--product kano-commit-convention-skill` to initialize the product.
2. Manually edit the config file to set the process path to the shared jira-default.json.
3. Use `create_item.py --product kano-commit-convention-skill` to add a test item.
4. Run `list_items.py --product kano-commit-convention-skill` and verify only KCCS items appear.
5. Run `list_items.py --product kano-agent-backlog-skill` and verify KCCS items are absent.
6. Query the SQLite index directly: `SELECT * FROM items WHERE product = ?` for both products.

# Acceptance Criteria

- `_kano/backlog/products/kano-commit-convention-skill/` exists with proper folder structure.
- `config.json` is initialized with correct name and prefix.
- `process.path` is set to a shared process definition (no duplication).
- Sample task `KCCS-TSK-0001` created and appears in SQLite index.
- `list_items --product KCCS` returns only KCCS items; `list_items --product KABSD` returns only KABSD items.
- SQLite index query `SELECT COUNT(*) FROM items WHERE product = 'kano-agent-backlog-skill'` matches original item count.
- SQLite index query `SELECT COUNT(*) FROM items WHERE product = 'kano-commit-convention-skill'` is 1 (the test item).
- No cross-product data leakage detected.

# Worklog

2026-01-06 21:10 [agent=copilot] Transferred ownership from antigravity. Ready gate completed. Final verification task for FTR-0010; depends on TSK-0080 (bootstrap) and TSK-0083 (CLI updates).
