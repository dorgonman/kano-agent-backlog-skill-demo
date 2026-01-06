---
id: KABSD-TSK-0081
uid: 019b93bb-187d-786d-b5a7-904ee79191f9
type: Task
title: Execute directory restructuring for monorepo platform
state: Done
priority: P1
parent: KABSD-FTR-0010
area: architecture
iteration: null
tags:
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
  blocked_by:
  - KABSD-TSK-0080
decisions: []
---

# Context

With `context.py` and updated bootstrap scripts in place, we must execute the one-time data migration to move the existing backlog into the new monorepo structure. This is a critical step that preserves all historical data while establishing the new layout.

# Goal

1. Back up current `_kano/backlog` to `_kano/backlog.archive_<timestamp>` (for rollback if needed).
2. Move the following from `_kano/backlog/` into `_kano/backlog/products/kano-agent-backlog-skill/`:
   - `items/` → `products/kano-agent-backlog-skill/items/`
   - `decisions/` → `products/kano-agent-backlog-skill/decisions/`
   - `views/` → `products/kano-agent-backlog-skill/views/`
   - `_config/` → `products/kano-agent-backlog-skill/_config/`
   - `_meta/` (move or keep at platform level, pending decision)
   - `_index/` (keep at platform level or move; decision pending)
3. Create `_kano/backlog/sandboxes/kano-agent-backlog-skill/` with test sandbox structure.
4. Create `_kano/backlog/_shared/defaults.json` with `{ "default_product": "kano-agent-backlog-skill" }`.
5. Verify no data is lost; Git status should show moved/renamed files (not deletions).

# Approach

1. Use shell or Python script (`scripts/fs/mv_file.py` or `mv` commands) to move directories.
2. Preserve `.git` history: commit the move as a single logical changeset.
3. Validate by checking file counts and verifying samples of frontmatter/content.
4. Run a quick smoke test: load a sample item from the new location and verify UID/ID integrity.
5. Update Git index if needed to reflect renames.

# Acceptance Criteria

- [x] `_kano/backlog/products/kano-agent-backlog-skill/items/` contains all original items (by file count and sample validation).
- [x] `_kano/backlog/products/kano-agent-backlog-skill/decisions/` contains all ADRs.
- [x] `_kano/backlog/products/kano-agent-backlog-skill/views/` contains all views.
- [x] `_kano/backlog/sandboxes/kano-agent-backlog-skill/` exists and is ready for test data.
- [x] `_kano/backlog/_shared/defaults.json` exists with correct content.
- [x] Git log shows the migration as a clean commit (no orphaned "delete" then "add" commits).
- [x] All file UIDs and metadata remain intact.

# Worklog

2026-01-06 21:10 [agent=copilot] Transferred ownership from antigravity. Ready gate completed. Depends on TSK-0080 (bootstrap script update).

2026-01-06 22:05 [agent=copilot] **IMPLEMENTATION COMPLETE**:
  - Created complete product directory structure: items/{epics,features,userstories,tasks,bugs}, decisions/, views/, _config/, _meta/
  - Executed migration: moved all items, decisions, views, _config, _meta from root to products/kano-agent-backlog-skill/
  - Verified _shared/defaults.json exists with default_product set correctly
  - Git correctly recognized moves as renames (not deletions), preserving history
  - Committed migration in single changeset: "[Migration] TSK-0081: Move kano-agent-backlog-skill items/decisions/views to products directory"
  - All AC criteria met ✓
  - State marked Done
