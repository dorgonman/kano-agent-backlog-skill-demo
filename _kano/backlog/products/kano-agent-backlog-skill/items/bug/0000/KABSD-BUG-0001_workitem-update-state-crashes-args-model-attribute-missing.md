---
id: KABSD-BUG-0001
uid: 019ba3f4-17f5-72b8-8834-d3a12bcde09a
type: Bug
title: "workitem_update_state crashes: args.model attribute missing"
state: Done
priority: P0
parent: KABSD-FTR-0025
area: workflow
iteration: null
tags: ["bug", "cli", "state"]
created: 2026-01-10
updated: 2026-01-10
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

`skills/kano-agent-backlog-skill/scripts/backlog/workitem_update_state.py` crashes with:
`AttributeError: 'Namespace' object has no attribute 'model'`.

This blocks state transitions and Worklog updates via the canonical script.

# Goal

Make `workitem_update_state.py` run without crashing (no hidden/undefined CLI args).

# Non-Goals

Do not introduce new required CLI parameters.

# Approach

Remove the erroneous reference to `args.model` and pass `model=None` to `append_worklog`.

# Alternatives

Add a `--model` CLI argument. Rejected for now because model identity is not required for state updates and would expand surface area.

# Acceptance Criteria

Running `python skills/kano-agent-backlog-skill/scripts/backlog/workitem_update_state.py --help` and updating an item state does not raise an exception.

# Risks / Dependencies

None.
# Worklog

2026-01-10 02:10 [agent=codex] Found while updating KABSD-TSK-0145: workitem_update_state.py references args.model but CLI doesn't define it, causing AttributeError and blocking state updates.
2026-01-10 02:11 [agent=codex] Ready: reproduced crash and defined minimal fix.
2026-01-10 02:11 [agent=codex] Done: removed args.model reference (use model=None) so state updates no longer crash.
