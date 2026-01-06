---
id: KABSD-FTR-0010
uid: 019b93ba-9346-727c-b5a7-904ee79191f9
type: Feature
title: Monorepo Platform Migration
state: New
priority: P1
parent: null
area: architecture
iteration: null
tags:
- architecture
- migration
created: 2026-01-06
updated: 2026-01-06
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

The current repository is built around a single backlog root (`_kano/backlog`). We want to support multiple independent products/skills (e.g., `kano-agent-backlog-skill`, `kano-commit-convention-skill`) within the same "monorepo", while keeping their backlogs and configurations isolated.

Key constraints:
- Existing backlog data (items, decisions, views, configs) must migrate without data loss.
- Scripts must discover product context via `--product` flag, environment variable, or defaults.
- SQLite index must support multi-product queries and isolation.
- Backward compatibility during transition: graceful fallback to defaults.

# Goal

Refactor the architecture to a "Platform + Multi-Product" model with the following structure:

```
_kano/backlog/                      # Platform root
  products/
    kano-agent-backlog-skill/       # First product (migrated from root)
      _config/
      items/
      decisions/
      views/
    kano-commit-convention-skill/   # Second product (new)
      _config/
      items/
      decisions/
      views/
  sandboxes/                        # Test/demo isolation per product
    kano-agent-backlog-skill/
    kano-commit-convention-skill/
  _shared/
    defaults.json                   # { "default_product": "kano-agent-backlog-skill" }
  _meta/                            # Platform-level metadata (shared)
  _index/                           # Platform-level SQLite index (product-aware)
```

# Approach

**Phase 1: Foundational Infrastructure**
- Create centralized `context.py` module for product-aware path resolution.
- Establish `_shared/defaults.json` with default product name and fallback behaviors.

**Phase 2: Script Updates**
- Update `config_loader.py` to resolve `_config/config.json` relative to product root.
- Update bootstrap scripts to accept `--product` and initialize product-specific folders.
- Update CLI scripts (`create_item.py`, `update_state.py`, etc.) to accept and propagate product context.
- Update indexer and resolver to tag/filter items by product.

**Phase 3: Directory Migration**
- Archive current `_kano/backlog` state.
- Create `products/kano-agent-backlog-skill/` structure.
- Move existing `items/`, `decisions/`, `views/`, `_config/`, `_meta/` into product folder.
- Update SQLite index to reflect new product column.

**Phase 4: Verification & New Product**
- Verify `kano-agent-backlog-skill` product still works after migration.
- Initialize `kano-commit-convention-skill` product with own `_config/config.json`.
- Test cross-product isolation in index/search.

# Acceptance Criteria

- [x] SKILL.md updated with Owner & Agent Assignment rules.
- [ ] `context.py` correctly resolves product paths and defaults.
- [ ] `_shared/defaults.json` exists with `default_product` set.
- [ ] Directory structure follows `products/` and `sandboxes/` layout.
- [ ] Existing `kano-agent-backlog-skill` operates correctly in its new location.
- [ ] New `kano-commit-convention-skill` can be initialized independently with `--product` flag.
- [ ] CLI commands fail gracefully or use defaults if no product is specified.
- [ ] SQLite index includes `product` column and filters correctly.
- [ ] No data leakage between products in search/resolve results.

# Worklog

2026-01-06 21:10 [agent=copilot] Transferred ownership from antigravity; beginning work on FTR-0010 and dependent tickets. Updated SKILL.md with Owner & Agent Assignment rules. This Feature will orchestrate 7 dependent Tasks (TSK-0079 through TSK-0085) across four phases.

