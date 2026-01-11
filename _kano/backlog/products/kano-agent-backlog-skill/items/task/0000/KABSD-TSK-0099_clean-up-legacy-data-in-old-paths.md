---
area: cleanup
created: 2026-01-07
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0099
iteration: 0.0.2
links:
  blocked_by: []
  blocks: []
  relates: []
owner: null
parent: KABSD-FTR-0010
priority: P3
state: Proposed
tags:
- cleanup
- migration
- legacy
title: Clean up legacy data in old paths
type: Task
uid: 019bac4a-6834-7703-b648-6e58ba392b03
updated: 2026-01-07
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