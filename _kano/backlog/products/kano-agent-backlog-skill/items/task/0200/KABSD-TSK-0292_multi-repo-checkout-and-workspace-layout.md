---
id: KABSD-TSK-0292
uid: 019be6eb-321e-76b4-84e4-ea4f2d4ac0a1
type: Task
title: "Multi-repo Checkout and Workspace Layout"
state: Proposed
priority: P2
parent: KABSD-FTR-0057
area: general
iteration: backlog
tags: []
created: 2026-01-23
updated: 2026-01-23
owner: None
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

The GitHub Pages documentation pipeline needs to checkout and integrate content from three separate repositories:
1. Quartz (documentation engine)
2. Demo repo (examples, guides, demo content)
3. Skill repo (core documentation, ADRs, API docs)

The build agent workspace must have a predictable, fixed layout to avoid path conflicts and enable reliable scripting.

# Goal

Define and implement a standardized workspace layout for the multi-repo checkout process that:
- Uses actions/checkout with repository and path parameters
- Provides fixed, predictable paths for build scripts
- Separates source content from build artifacts
- Enables clean content "cooking" and Quartz build process

# Non-Goals

- Dynamic path resolution or workspace discovery
- Nested submodule handling
- Workspace persistence across workflow runs
- Complex dependency resolution between repos

# Approach

**Fixed Workspace Structure:**
```
_ws/
├── quartz/          # Quartz engine (checkout)
├── demo/            # Demo source (checkout)
├── skill/           # Skill source (checkout)
├── content/         # Cooked content (generated)
├── public/          # Quartz build output (generated)
└── skill-pages/     # Skill repo gh-pages (checkout for push)
```

**GitHub Actions Implementation:**
- Use multiple actions/checkout steps with repository and path parameters
- Checkout Quartz engine to `_ws/quartz/`
- Checkout Demo repo to `_ws/demo/`
- Checkout Skill repo to `_ws/skill/`
- Checkout Skill repo gh-pages branch to `_ws/skill-pages/`

# Alternatives

- **Git submodules**: More complex, requires submodule management
- **Dynamic paths**: Harder to script, more error-prone
- **Single repo approach**: Doesn't meet multi-repo requirement
- **Nested checkouts**: Can cause path conflicts

# Acceptance Criteria

- [ ] Workspace layout defined with fixed paths
- [ ] GitHub Actions workflow can checkout all three repos to specified paths
- [ ] Build scripts can reference predictable paths (_ws/quartz/, _ws/demo/, etc.)
- [ ] No path conflicts between different repo checkouts
- [ ] Skill repo gh-pages branch checkout works for push operations
- [ ] Workspace structure documented for future maintenance

# Risks / Dependencies

**Technical Risks:**
- Path length limits on Windows runners
- Checkout failures due to network issues or repo access
- Workspace directory conflicts or permission issues
- Large repo checkout times affecting workflow duration

**Dependencies:**
- actions/checkout action availability and stability
- Read access to Quartz, Demo, and Skill repositories
- GitHub Actions runner disk space for multiple checkouts
- Consistent branch/tag naming across repositories

**Mitigation:**
- Use short, predictable path names
- Add retry logic for checkout operations
- Implement workspace cleanup between runs
- Use shallow checkouts where possible to reduce size

# Worklog

2026-01-23 02:15 [agent=amazonq] Created item
