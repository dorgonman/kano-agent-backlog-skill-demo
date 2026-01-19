---
id: KABSD-USR-0010
uid: 019b8f52-9f40-7400-ac72-b640f7a14995
type: UserStory
title: Introduce backlog sandbox path for tests
state: Proposed
priority: P2
parent: KABSD-FTR-0004
area: testing
iteration: null
tags:
- sandbox
- tests
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

Tests should not write into the live backlog. We need a sandbox path for
test data to keep audit logs clean and avoid accidental pollution.

# Goal

As a maintainer, I want a dedicated backlog sandbox path so tests run in
isolation without touching `_kano/backlog/` data.

# Non-Goals

- Full test harness or CI integration.
- Removing all manual test usage.

# Approach

- Define a sandbox root path (e.g., `_kano/backlog_sandbox`).
- Update scripts/tests to use the sandbox when running in test mode.
- Adjust path guards to allow the sandbox explicitly.

# Links

- Feature: [[KABSD-FTR-0004_backlog-config-system-and-process-profiles|KABSD-FTR-0004 Backlog config system and process profiles]]
- Task: [[../../task/0000/KABSD-TSK-0025_define-backlog-sandbox-path-and-guardrails|KABSD-TSK-0025 Define backlog sandbox path and guardrails]]
- Task: [[../../task/0000/KABSD-TSK-0026_update-test-scripts-to-use-backlog-sandbox|KABSD-TSK-0026 Update test scripts to use backlog sandbox]]
- Task: [[../../task/0000/KABSD-TSK-0027_add-user-story-validation-test-script|KABSD-TSK-0027 Add user story validation test script]]

# Alternatives

- Continue using temp folders inside `_kano/backlog/`.

# Acceptance Criteria

- Sandbox root is defined and documented.
- Tests can run without touching the main backlog items.
- Guards prevent non-sandbox tests from leaking into `_kano/backlog/`.

# Risks / Dependencies

- Path guards must be updated to allow the sandbox safely.

# Worklog

2026-01-04 18:19 [agent=codex] Created story for a backlog sandbox path for tests.
2026-01-04 18:36 [agent=codex] Added scope, approach, and linked tasks for sandboxed tests.
2026-01-04 19:12 [agent=codex] Added task for user story validation tests.
