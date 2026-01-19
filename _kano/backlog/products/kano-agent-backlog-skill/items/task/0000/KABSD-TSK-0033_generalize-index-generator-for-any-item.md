---
id: KABSD-TSK-0033
uid: 019b8f52-9f97-7ac0-ac03-fec58a4f7e10
type: Task
title: Generalize index generator for any item
state: Done
priority: P2
parent: KABSD-FTR-0042
area: views
iteration: null
tags:
- moc
- index
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

Current index generation targets Epics only. We need the same tree + state output for Features and UserStories as roots so any level can render its own descendant index.

# Goal

Allow the index generator to accept any root item and produce a MOC with task state labels.

# Non-Goals

- Changing the backlog hierarchy rules.
- Adding DataviewJS or other plugin dependencies.

# Approach

- Extend the generator to accept a generic root id/path.
- Keep Epic-specific flags as aliases for backward compatibility.
- Update Dataview section to use a generic parent filter.

# Alternatives

Maintain separate scripts for Epic/Feature/UserStory indexes.

# Acceptance Criteria

- Script can generate an index for Epic, Feature, or UserStory roots.
- Output includes Task/Bug state labels.
- Existing Epic workflow remains usable.

# Risks / Dependencies

- Ambiguous IDs require explicit path selection.

# Worklog

2026-01-04 23:51 [agent=codex] Created from template.
2026-01-04 23:51 [agent=codex] Filled Ready sections for index generalization.
2026-01-04 23:52 [agent=codex] State -> Ready.
2026-01-04 23:52 [agent=codex] Generalizing index generator to support any root item.
2026-01-04 23:53 [agent=codex] Generalized index generator to support any root item and updated dataview block.
