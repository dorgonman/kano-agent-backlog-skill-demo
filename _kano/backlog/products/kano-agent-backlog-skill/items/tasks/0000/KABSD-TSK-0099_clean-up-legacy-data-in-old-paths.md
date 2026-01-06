---
id: KABSD-TSK-0099
uid: null
type: Task
title: Clean up legacy data in old paths
state: Proposed
priority: P3
parent: KABSD-FTR-0010
area: cleanup
iteration: "0.0.2"
tags: ["cleanup", "migration", "legacy"]
created: 2026-01-07
updated: 2026-01-07
owner: null
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

During the multi-product migration (FTR-0010), the directory structure was moved from _kano/backlog/items/ to _kano/backlog/products/. Some legacy files and directories remain in the old location and should be cleaned up to avoid confusion.

# Goal

Remove all legacy data from old paths and verify all tools use new product-aware paths.

# Approach

1. Inventory remaining files in _kano/backlog/items/ directory
2. Verify they are truly obsolete or duplicates
3. Remove files if safe, or migrate if necessary
4. Check that no tools reference old paths
5. Verify directory structure clean

# Acceptance Criteria

- [ ] _kano/backlog/items/ directory cleaned or removed
- [ ] No tools contain hardcoded references to old paths
- [ ] Verified no data loss
- [ ] All scripts use product-aware path resolution
- [ ] Changes committed to git

# Risks / Dependencies

- Risk: Deleting important files
- Mitigation: Verify files are duplicates before deletion

# Worklog

2026-01-07 02:10 [agent=copilot] Created task to clean up legacy directory structure from multi-product migration.
