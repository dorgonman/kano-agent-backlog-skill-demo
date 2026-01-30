---
id: KABSD-TSK-0002
uid: 019b8f52-9f53-70c2-be2c-a81af61ac4ec
type: Task
title: Create Obsidian Base demo views
state: Done
priority: P2
parent: KABSD-USR-0001
area: backlog
iteration: null
tags:
- views
- obsidian
- bases
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

We want a plugin-free dashboard demo using Obsidian Bases so the repo can showcase
Dataview, Bases, and plain Markdown views side-by-side.

# Goal

Provide working Base view config and a short README so the demo is usable without
Dataview and still points to the same backlog items.

# Non-Goals

- Remove the Dataview dashboards.
- Achieve full Dataview feature parity (tree rendering remains in Epic MOCs).

# Approach

- Add `Dashboard_ObsidianBase.base` with Base view definitions and filters.
- Add `Dashboard_ObsidianBase_Readme.md` with usage notes and view mapping.

# Links

- [[_kano/backlog/views/Dashboard_ObsidianBase.base]]
- [[_kano/backlog/views/Dashboard_ObsidianBase_Readme.md]]

# Alternatives

- Keep only Dataview + plain Markdown dashboards.
- Ask users to build Bases manually in their own vaults.

# Acceptance Criteria

- `.base` opens without parse errors in Obsidian Bases.
- New/Active/Done views match the intended state filters.
- Epics/Features/UserStories/Tasks+Bugs views hide Done/Dropped.
- README explains how to open and adapt the Base views.

# Risks / Dependencies

- Bases syntax or filter support may differ by Obsidian version.
- Nested filters might need to be simplified in older Bases builds.
# Worklog

2026-01-04 00:33 [agent=codex] Created task for Obsidian Base demo views.
2026-01-04 00:46 [agent=codex] Marked Done after Base dashboard config and README update.
