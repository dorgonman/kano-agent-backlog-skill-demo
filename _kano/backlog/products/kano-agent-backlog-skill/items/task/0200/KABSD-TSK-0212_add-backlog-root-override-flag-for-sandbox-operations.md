---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0212
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: null
priority: P2
state: Done
tags: []
title: Add backlog-root override flag for sandbox operations
type: Task
uid: 019bc4a1-74c8-72f1-bcfa-347b10653277
updated: '2026-01-16'
---

# Context

Sandbox operations need to target alternate backlog roots, but many CLI commands only resolve _kano/backlog from the workspace root. This blocks creating or updating items in sandbox backlogs during testing.

# Goal

Add a --backlog-root-override CLI option so workitem/state/worklog commands can target an alternate backlog root (e.g., _kano/backlog_sandbox/<name>).

# Approach

Add a backlog root resolver in kano_backlog_cli.util that accepts an override path. Update CLI commands that currently call resolve_product_root to accept and pass --backlog-root-override, and for workitem create pass the resolved product root into ops_create_item.

# Acceptance Criteria

- CLI commands that manage items support --backlog-root-override.\n- Overridden root is validated and used to resolve products.\n- Sandbox operations can create/update items using the override.

# Risks / Dependencies

- Incorrect override could point outside a backlog root; validate path and error clearly.\n- Ensure the override does not break existing default resolution.

# Worklog

2026-01-16 10:27 [agent=codex] [model=unknown] Created item
2026-01-16 10:28 [agent=codex] [model=GPT-5.2-Codex] Start implementation for --backlog-root-override option.
2026-01-16 10:29 [agent=codex] [model=GPT-5.2-Codex] Implemented backlog root override resolver and exposed --backlog-root-override on workitem read/validate/create/set-ready/update-state/attach-artifact plus worklog append and state transition.
2026-01-16 10:30 [agent=codex] [model=GPT-5.2-Codex] Completed --backlog-root-override support in CLI resolution paths.
2026-01-16 10:30 [agent=codex] [model=GPT-5.2-Codex] Completed --backlog-root-override support in CLI resolution paths.
2026-01-16 11:11 [agent=codex] [model=GPT-5.2-Codex] Verified --backlog-root-override by creating and updating GT-TSK-0001 under _kano/backlog_sandbox/_tmp_tests/guide_test_backlog.