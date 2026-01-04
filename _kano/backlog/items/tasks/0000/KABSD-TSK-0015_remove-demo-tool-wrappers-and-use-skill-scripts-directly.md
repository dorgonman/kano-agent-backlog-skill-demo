---
id: KABSD-TSK-0015
type: Task
title: "Remove demo tool wrappers and use skill scripts directly"
state: Done
priority: P3
parent: KABSD-USR-0004
area: demo
iteration: null
tags: ["tools", "cleanup"]
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

Wrapper scripts under `_kano/backlog/tools/` are not needed right now. The demo
should call the skill scripts directly and avoid an extra layer.

# Goal

Remove the wrapper layer and update docs to point to the skill scripts.

# Non-Goals

- Designing hook systems for wrappers (defer until needed).

# Approach

- Deprecate or remove `_kano/backlog/tools/*` wrappers.
- Update AGENTS and view commands to use skill script paths directly.
- Keep the tools directory as optional/empty for future hooks.

# Alternatives

- Keep wrappers and accept the extra layer for now.

# Acceptance Criteria

- Wrapper scripts are removed or clearly deprecated.
- Documentation references skill scripts directly.

# Risks / Dependencies

- Users might still run old wrapper commands.

# Worklog

2026-01-04 14:21 [agent=codex] Created task to remove demo tool wrappers and call skill scripts directly.
2026-01-04 14:21 [agent=codex] State -> InProgress.
2026-01-04 14:36 [agent=codex] Added scope and acceptance criteria for removing wrappers.
2026-01-04 14:24 [agent=codex] Deprecated demo wrappers and updated docs to point to skill scripts.
