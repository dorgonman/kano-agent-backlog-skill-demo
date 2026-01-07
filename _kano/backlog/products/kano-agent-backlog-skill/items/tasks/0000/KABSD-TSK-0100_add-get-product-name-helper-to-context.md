---
id: KABSD-TSK-0100
uid: null
type: Task
title: Add get_product_name() helper function to context.py
state: Proposed
priority: P3
parent: KABSD-FTR-0010
area: refactoring
iteration: "0.0.2"
tags: ["context", "product", "refactoring"]
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

Multiple CLI scripts need to determine the active product name from various sources (command-line argument, environment variable, or default). This logic is repeated across scripts and should be centralized in context.py.

# Goal

Create a unified `get_product_name()` function that handles product name resolution with fallback chain.

# Approach

1. Implement `get_product_name(args=None, env=None, default=None)` function
   - If args provided and has .product, use it
   - Else if KANO_PRODUCT environment variable set, use it
   - Else use default_product from defaults.json
   - Return result
   
2. Update all CLI scripts that determine product to use this function
   
3. Add docstring explaining fallback chain

4. Test with both CLI arguments and environment variables

# Acceptance Criteria

- [ ] get_product_name() function implemented
- [ ] Handles CLI args, env vars, and defaults
- [ ] Comprehensive docstring added
- [ ] At least 3 CLI scripts updated to use it
- [ ] Tests pass with various input combinations
- [ ] Backward compatible (no existing behavior changed)

# Risks / Dependencies

None

# Worklog

2026-01-07 02:10 [agent=copilot] Created task to centralize product name resolution logic in context.py.
