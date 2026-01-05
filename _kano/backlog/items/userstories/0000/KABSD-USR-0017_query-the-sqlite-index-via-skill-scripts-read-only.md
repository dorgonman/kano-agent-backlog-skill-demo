---
id: KABSD-USR-0017
uid: 019b8f52-9f4f-7b35-9d37-9f9114beefa4
type: UserStory
title: Query the SQLite index via skill scripts (read-only)
state: Done
priority: P3
parent: KABSD-FTR-0007
area: indexing
iteration: null
tags:
- sqlite
- index
- query
- script
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

We have a rebuildable SQLite index, but agents need a stable, auditable way to query it without running ad-hoc sqlite commands that bypass logging.

# Goal

As an agent/user, I want a read-only query script (with presets) so I can quickly retrieve relevant backlog items and their file links using SQL-backed queries, while keeping actions auditable.

# Non-Goals

# Approach

- Provide a skill script that opens the index DB in read-only mode.
- Offer preset queries (New/InProgress/Done, recently updated, by tag, by parent).
- Optionally allow `--sql` for advanced read-only queries with guardrails (SELECT-only).
- Output should be copy/paste friendly: Markdown links or plain paths.

# Alternatives

# Acceptance Criteria

- A script exists that can query the SQLite index and print results as Markdown links and/or JSON.
- It refuses non-SELECT statements and never modifies the DB or source files.
- All invocations are captured by audit logging.

# Risks / Dependencies

# Worklog

2026-01-05 16:21 [agent=codex] Created from template.
2026-01-06 01:02 [agent=codex] Auto-sync from child KABSD-TSK-0054 -> Planned.
2026-01-06 01:02 [agent=codex] Auto-sync from child KABSD-TSK-0054 -> InProgress.
2026-01-06 01:04 [agent=codex] Auto-sync from child KABSD-TSK-0054 -> Done.
