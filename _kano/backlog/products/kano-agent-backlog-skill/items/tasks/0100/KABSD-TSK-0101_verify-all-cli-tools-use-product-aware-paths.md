---
id: KABSD-TSK-0101
uid: null
type: Task
title: Verify all CLI tools use product-aware paths
state: Proposed
priority: P4
parent: KABSD-FTR-0010
area: quality
iteration: "0.0.2"
tags: ["audit", "cli", "paths", "quality"]
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

To ensure the multi-product platform works correctly, all CLI tools must use product-aware path resolution. We need a comprehensive audit to verify this and catch any tools still using hardcoded or old paths.

# Goal

Audit all backlog CLI scripts to ensure they correctly use product-aware paths via context.py.

# Approach

1. List all CLI scripts in scripts/backlog/
2. For each script, verify:
   - Uses context.py path resolution functions
   - Does NOT hardcode _kano/backlog/items paths
   - Respects --product argument if provided
   - Falls back to defaults.json default_product correctly
   
3. Create regression test script that:
   - Tests each script with --product flag
   - Tests each script without --product (uses default)
   - Verifies correct path resolution
   
4. Document findings and update scripts as needed

# Acceptance Criteria

- [ ] All 18+ CLI scripts audited
- [ ] No hardcoded old paths found
- [ ] All tools properly use context.py
- [ ] Regression test script created
- [ ] Test script runs successfully for all tools
- [ ] Test results documented

# Risks / Dependencies

None

# Worklog

2026-01-07 02:10 [agent=copilot] Created task for comprehensive audit of CLI tool path usage across multi-product platform.
