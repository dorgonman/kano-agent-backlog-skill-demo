---
id: KABSD-TSK-0042
uid: 019b8f52-9faa-77a0-b6ce-cd1dd9da9911
type: Task
title: Add process profile template and document built-ins
state: Done
priority: P2
parent: KABSD-USR-0009
area: process
iteration: null
tags:
- process
- config
- docs
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

We already ship built-in process profiles, but need a clear template and
documentation that explains how to use built-ins vs. custom definitions.

# Goal

Provide a reusable process profile template and document built-in + custom
options so teams can adopt or extend without guesswork.

# Non-Goals

- Implement a new workflow engine or validation rules.
- Add more built-in profiles beyond the current set.

# Approach

- Add a `references/processes/template.json` file.
- Update `references/processes.md` with built-in list, template usage, and
  config examples for custom profiles.

# Alternatives

- Ask users to copy/paste a built-in file as their template.

# Acceptance Criteria

- Template file exists with the expected schema fields and comments.
- Documentation shows built-in IDs + how to reference a custom file via config.

# Risks / Dependencies

- Doc drift if schema changes.

# Worklog

2026-01-05 02:06 [agent=codex] Created from template.
2026-01-05 02:06 [agent=codex] State -> Ready. Ready gate validated for process template/docs updates.
2026-01-05 02:07 [agent=codex] State -> InProgress. Adding process profile template and documenting built-ins/custom usage.
2026-01-05 02:07 [agent=codex] State -> Done. Added process profile template and documented built-in/custom usage in references/processes.md.
