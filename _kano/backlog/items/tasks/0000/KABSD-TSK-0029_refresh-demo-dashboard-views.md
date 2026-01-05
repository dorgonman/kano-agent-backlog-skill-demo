---
id: KABSD-TSK-0029
uid: 019b8f52-9f8e-7e4d-9da4-efa68a841408
type: Task
title: Refresh demo dashboard views
state: Done
priority: P2
parent: KABSD-USR-0005
area: views
iteration: null
tags:
- views
- dashboard
created: 2026-01-04
updated: '2026-01-06'
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

Dashboard demo files are out of sync with the current backlog and Base/Dataview definitions. The plain Markdown views are stale, and the Base/Dataview configs need to reflect the current view grouping rules.

# Goal

Ensure all demo dashboard views (Plain Markdown, Dataview, Bases) show the correct state groupings and are regenerated to match the latest backlog items.

# Non-Goals

- Redesigning the backlog schema or changing item states.
- Adding new dashboard types beyond the existing three demo variants.

# Approach

- Regenerate the Plain Markdown views using `scripts/backlog/generate_view.py`.
- Fix Base filter syntax for Tasks + Bugs and align view groupings.
- Update the Dataview dashboard sections to match the New/Active/Done grouping.

# Alternatives

Manually edit every view after each backlog change (error-prone).

# Acceptance Criteria

- Plain Markdown views show current items after regeneration.
- Obsidian Base file parses without filter errors and reflects correct groups.
- Dataview dashboard sections match the New/Active/Done grouping rules.

# Risks / Dependencies

- Obsidian Base syntax differences across versions may require manual tweaks.

# Worklog

2026-01-04 22:38 [agent=codex] Created from template.
2026-01-04 22:38 [agent=codex] Filled Ready sections for dashboard refresh.
2026-01-04 22:38 [agent=codex] State -> Ready.
2026-01-04 22:41 [agent=codex] Refreshing demo view files and fixing Base/Dataview definitions.
2026-01-04 22:41 [agent=codex] Regenerated plain Markdown dashboards, corrected Base filter syntax, and aligned Dataview sections.
