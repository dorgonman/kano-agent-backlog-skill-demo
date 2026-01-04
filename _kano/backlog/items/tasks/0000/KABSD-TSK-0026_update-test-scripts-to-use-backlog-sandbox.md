---
id: KABSD-TSK-0026
type: Task
title: "Update test scripts to use backlog sandbox"
state: Proposed
priority: P2
parent: KABSD-USR-0010
area: testing
iteration: null
tags: ["sandbox", "tests"]
created: 2026-01-04
updated: 2026-01-04
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

Test scripts currently write into `_kano/backlog/` via `_tmp_tests`, which we
want to isolate into a sandbox root.

# Goal

Update test scripts to use the backlog sandbox path for all test data.

# Non-Goals

- Building full test harnesses or CI integration.

# Approach

- Update `test_scripts.py` to use the sandbox root by default.
- Ensure cleanup stays within the sandbox directory.

# Alternatives

- Keep test output under `_kano/backlog/_tmp_tests`.

# Acceptance Criteria

- Test scripts write only under the sandbox root.
- Cleanup removes sandbox artifacts after runs.

# Risks / Dependencies

- Requires sandbox guardrails to be in place first.

# Worklog

2026-01-04 18:23 [agent=codex] Created task to update test scripts to use sandbox.
2026-01-04 18:40 [agent=codex] Added scope and acceptance criteria for sandboxed tests.
