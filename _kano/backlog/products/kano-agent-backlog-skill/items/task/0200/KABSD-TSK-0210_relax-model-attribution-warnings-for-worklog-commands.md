---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0210
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: null
priority: P2
state: Done
tags:
- worklog
- model
- ux
title: Relax model attribution warnings for worklog commands
type: Task
uid: 019bc46a-1374-7115-914a-b14fdc6c74ba
updated: '2026-01-16'
---

# Context

Worklog/update-state commands currently warn when --model is omitted, which is disruptive when humans switch models frequently and do not want to manage environment variables.

# Goal

Make model attribution optional without warnings, while still recording model=unknown when no model can be determined.

# Approach

Remove the CLI warning paths for missing models in worklog append, workitem update-state, and state transition commands. Keep resolve_model behavior unchanged so the worklog still records a value. Ensure help text remains accurate (model optional).

# Acceptance Criteria

- Running worklog append or update-state without --model produces no warning. - The worklog entry still includes [model=unknown] when no model is provided. - No behavior changes when --model is explicitly provided.

# Risks / Dependencies

Risk: losing explicit prompt to set model; mitigate by keeping model field visible in worklog and retaining optional env var support.

# Worklog

2026-01-16 09:27 [agent=codex] [model=unknown] Created item
2026-01-16 09:27 [agent=codex] [model=unknown] Start removing model-missing warnings from CLI worklog/update-state commands.
2026-01-16 09:28 [agent=codex] [model=unknown] Verified worklog append without --model; no warning emitted.
2026-01-16 09:28 [agent=codex] [model=unknown] Removed model-missing warnings; validated worklog append without model.
2026-01-16 09:29 [agent=codex] [model=unknown] Removed remaining model-missing warnings in workitem/state commands.