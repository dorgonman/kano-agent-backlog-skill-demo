---
id: KABSD-TSK-0034
uid: 019b8f52-9f98-7821-b140-9fe16ab03083
type: Task
title: Show state labels for all index items and drop epic aliases
state: Done
priority: P2
parent: KABSD-FTR-0001
area: views
iteration: null
tags:
- index
- views
created: 2026-01-05
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

Index output currently labels state only for Task/Bug lines, so Feature/UserStory entries appear without state. The script also still accepts deprecated epic alias flags, which you want removed.

# Goal

Always show state labels for all items in the index tree and remove deprecated epic alias arguments.

# Non-Goals

- Changing backlog states or hierarchy rules.
- Adding new view types beyond the current index generator.

# Approach

- Update the generator to show state for all items (or flag unknown when missing).
- Remove --epic-id/--epic-path aliases and adjust help/error messages.
- Regenerate the demo epic index to reflect the new formatting.

# Alternatives

Keep task-only labels and rely on Dataview tables for state.

# Acceptance Criteria

- MOC tree entries for Feature/UserStory include state labels.
- The script rejects deprecated epic alias flags.
- Demo index reflects the updated format.

# Risks / Dependencies

- Existing docs or automation using the old flags must be updated.

# Worklog

2026-01-05 00:02 [agent=codex] Created from template.
2026-01-05 00:02 [agent=codex] Filled Ready sections for state labels + alias removal.
2026-01-05 00:03 [agent=codex] State -> Ready.
2026-01-05 00:03 [agent=codex] Updating index generator to show state everywhere and drop epic aliases.
2026-01-05 00:03 [agent=codex] Removed epic alias flags and now label state for all index items.
2026-01-05 00:05 [agent=codex] Fix indentation bug so all items get state labels.
2026-01-05 00:05 [agent=codex] State labels now render for all items; root index regenerates correctly.
