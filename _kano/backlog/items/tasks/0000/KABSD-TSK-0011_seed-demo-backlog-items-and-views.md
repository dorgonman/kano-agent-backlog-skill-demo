---
id: KABSD-TSK-0011
uid: 019b8f52-9f67-7609-928c-87dc5814a802
type: Task
title: Seed demo backlog items and views
state: Done
priority: P3
parent: KABSD-USR-0005
area: demo
iteration: null
tags:
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
---

# Context

The demo needs a scriptable way to generate a small dataset and views for
repeatable walkthroughs.

# Goal

Implement a script that seeds minimal demo items and view files.

# Non-Goals

- Creating a full production-sized backlog.
- Overwriting existing demo data by default.

# Approach

- Add `scripts/backlog/seed_demo.py`.
- Create a minimal Epic/Feature/UserStory/Task set with links.
- Generate demo views (Dataview/Base/Plain Markdown) in `_kano/backlog/views`.
- Provide a `--force` flag for rebuilds.

# Alternatives

- Keep a pre-seeded folder in version control and copy it manually.

# Acceptance Criteria

- Script produces a small, consistent set of items across types.
- Demo view files are generated alongside the items.
- Default behavior is non-destructive unless `--force` is used.

# Risks / Dependencies

- Seed content can drift from current skill conventions.

# Worklog

2026-01-04 13:51 [agent=codex] Created task for demo seeding script.
2026-01-04 13:55 [agent=codex] Added scope and acceptance criteria for demo seeding.
2026-01-04 21:21 [agent=codex] Implemented seed_demo.py to create demo items and views.
