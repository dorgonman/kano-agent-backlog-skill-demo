---
id: KABSD-TSK-0016
uid: 019b8f52-9f72-7fb7-889f-fc1e745096dd
type: Task
title: Restrict skill scripts to _kano/backlog paths
state: Done
priority: P2
parent: KABSD-USR-0002
area: infra
iteration: null
tags:
- logging
- guardrails
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

We need to prevent skill scripts from operating on arbitrary files so audit logs
stay clean and other repos/skills cannot misuse the tooling.

# Goal

Enforce that backlog/skill scripts only operate on paths under `_kano/backlog/`.

# Non-Goals

- Access controls outside the repo scope.
- Broad sandboxing beyond path checks.

# Approach

- Add path guards to `scripts/backlog/*` and `scripts/fs/*`.
- Reject any target path outside `_kano/backlog/` with a clear error.
- Update docs to state the restriction.

# Alternatives

- Rely on user discipline (not sufficient for audit integrity).

# Acceptance Criteria

- All backlog/fs scripts refuse paths outside `_kano/backlog/`.
- Error messages explain the allowed root.
- Documentation mentions the restriction.

# Risks / Dependencies

- Tests using temp folders must be adjusted to stay within `_kano/backlog/`.

# Worklog

2026-01-04 18:04 [agent=codex] Created task to restrict skill scripts to _kano/backlog paths.
2026-01-04 18:08 [agent=codex] Added scope and acceptance criteria for path restrictions.
2026-01-04 18:05 [agent=codex] State -> InProgress.
2026-01-04 18:09 [agent=codex] Added path guards so backlog/fs scripts only operate under _kano/backlog.
