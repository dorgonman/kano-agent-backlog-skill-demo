---
id: KABSD-USR-0005
uid: 019b8f52-9f36-7ee6-9961-fd3ccffcd218
type: UserStory
title: Seed demo data and views from the skill
state: Done
priority: P3
parent: KABSD-FTR-0003
area: demo
iteration: null
tags:
- self-contained
- demo
- seed
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
original_type: UserStory
---

# Context

The demo should be reproducible without manual file edits. We need a scriptable
way to seed minimal sample items and views.

# Goal

As a demo owner, I want to seed sample backlog data and views from the skill
so the demo can be reset quickly.

# Non-Goals

- Creating a large, production-like dataset.
- Overwriting existing demo data by default.

# Approach

- Add a `bootstrap_seed_demo.py` script that creates a small, representative dataset.
- Generate demo views (Dataview/Base/Plain Markdown) alongside the items.
- Default to safe, non-destructive behavior unless explicitly forced.

# Links

- Feature: [[KABSD-FTR-0003_self-contained-skill-bootstrap-and-automation|KABSD-FTR-0003 Self-contained skill bootstrap and automation]]
- Task: [[KABSD-TSK-0011_seed-demo-backlog-items-and-views|KABSD-TSK-0011 Seed demo backlog items and views]]
- Task: [[KABSD-TSK-0012_document-self-contained-setup-and-bootstrap-scripts|KABSD-TSK-0012 Document self-contained setup and bootstrap scripts]]

# Alternatives

- Manually copy a pre-seeded `_kano/backlog` folder between repos.

# Acceptance Criteria

- Running the seed script produces a small set of items across key types.
- Demo view files are generated alongside the seeded items.
- Script avoids overwriting existing data unless explicitly requested.

# Risks / Dependencies

- Seeded data may drift from real workflows if not maintained.

# Worklog

2026-01-04 13:51 [agent=codex] Created user story for seeding demo data and views.
2026-01-04 13:55 [agent=codex] Added scope, approach, and linked tasks for demo seeding.
2026-01-05 01:47 [agent=codex] Auto-sync from child KABSD-TSK-0012 -> Planned.
2026-01-05 01:47 [agent=codex] Auto-sync from child KABSD-TSK-0012 -> InProgress.
2026-01-05 01:50 [agent=codex] Auto-sync from child KABSD-TSK-0012 -> Done.
