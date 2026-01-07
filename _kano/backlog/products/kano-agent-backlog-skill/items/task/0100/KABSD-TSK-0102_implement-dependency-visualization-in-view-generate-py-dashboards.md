---
id: KABSD-TSK-0102
uid: 019b947e-db58-7624-a86f-9506e8b41a63
type: Task
title: "Implement dependency visualization in view_generate.py dashboards"
state: Proposed
priority: P2
parent: KABSD-FTR-0001
area: general
iteration: null
tags: []
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

Currently, the generated Markdown dashboards (views) only show parent-child hierarchy. There is no visual indication of blocking relationships, making it difficult for users to see which tasks are stalled by dependencies.

# Goal

Enhance `view_generate.py` to display `blocks` and `blocked_by` relationships in the "All Items" and other relevant dashboard views.

# Approach

1.  Modify `view_generate.py` to extract `links` data from the SQLite index or item frontmatter.
2.  Add a "Dependencies" column or a suffix to item titles in the generated markdown tables.
3.  Use clear visual cues (e.g., `[Blocked by KABSD-TSK-0001]`) to indicate dependencies.
4.  Optionally, include a dedicated "Blocked Items" section in the dashboard.

# Alternatives

# Acceptance Criteria

- [ ] Generated dashboards show `blocked_by` relationships for items.
- [ ] Dependency links in views are clickable (standard markdown links to items).
- [ ] Dashboards distinguish between internal (same product) and external/relational links.

# Risks / Dependencies

- Ensuring that visualization remains readable even with many cross-links.

# Worklog

2026-01-07 02:08 [agent=antigravity] Created from template.
2026-01-07 02:21 [agent=antigravity] Created from template.
2026-01-07 02:25 [agent=antigravity] Filled in goal and approach.
