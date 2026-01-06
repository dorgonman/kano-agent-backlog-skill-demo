---
id: KABSD-TSK-0027
uid: 019b8f52-9f89-7d9f-b0a2-cbe47d92dd8a
type: Task
title: Add user story validation test script
state: Done
priority: P3
parent: KABSD-USR-0010
area: testing
iteration: null
tags:
- tests
- validation
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

We need a repeatable way to validate each user story against the current repo
state without manual inspection.

# Goal

Create a test script that checks each user story’s acceptance criteria or
proxy signals and reports missing work.

# Non-Goals

- Full end-to-end tests for external systems.

# Approach

- Implement a script that maps user story IDs to checks.
- Keep checks read-only and scoped to `_kano/backlog` or the sandbox.
- Report pass/fail per user story and summarize missing items.

# Alternatives

- Manual checklist reviews.

# Acceptance Criteria

- Script outputs a per-user-story status table.
- Script exits non-zero when required checks fail.

# Risks / Dependencies

- Some user stories require heuristic checks (doc-based).

# Worklog

2026-01-04 21:07 [agent=codex] Created task for user story validation test script.
2026-01-04 21:07 [agent=codex] State -> InProgress.
2026-01-04 21:10 [agent=codex] Added scope and acceptance criteria for user story validation script.
2026-01-04 21:08 [agent=codex] Added validate_userstories.py script and updated references.
