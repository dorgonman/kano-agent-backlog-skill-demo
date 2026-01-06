---
id: KABSD-TSK-0030
uid: 019b8f52-9f90-7fa8-8c10-f155177d08c1
type: Task
title: Require explicit agent identity in script worklogs
state: Done
priority: P2
parent: KABSD-FTR-0005
area: compliance
iteration: null
tags:
- agent
- identity
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

Multiple agents can operate on the same backlog. Using a default agent name (e.g. codex) in Worklog entries makes attribution unreliable and causes collisions.

# Goal

Require an explicit `--agent` value for script-generated Worklog entries.

# Non-Goals

- Verifying the authenticity of agent identity.
- Introducing a global allowlist of agent names.

# Approach

- Remove default agent values from backlog scripts.
- Make `--agent` a required argument wherever Worklog entries are written.
- Update script tests and docs accordingly.

# Alternatives

Keep a default agent name (rejected: leads to misattribution).

# Acceptance Criteria

- `workitem_create.py` and `workitem_update_state.py` fail without `--agent`.
- Test scripts pass by supplying explicit agent values.
- Skill docs state that agent identity must be provided.

# Risks / Dependencies

- Callers must update their scripts or wrappers to pass `--agent`.

# Worklog

2026-01-04 23:27 [agent=codex] Created from template.
2026-01-04 23:28 [agent=codex] Filled Ready sections for agent identity enforcement.
2026-01-04 23:28 [agent=codex] State -> Ready.
2026-01-04 23:28 [agent=codex] Enforcing required --agent in backlog scripts and tests.
2026-01-04 23:29 [agent=codex] Made --agent required in Worklog scripts, updated tests and docs.
