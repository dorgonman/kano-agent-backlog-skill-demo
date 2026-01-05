---
id: KABSD-TSK-0023
uid: 019b8f52-9f81-7735-9b7d-464d6f39a59f
type: Task
title: Ship built-in process definition files
state: Done
priority: P3
parent: KABSD-USR-0009
area: process
iteration: null
tags:
- process
- config
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

Users need ready-to-use process definitions without authoring custom profiles.

# Goal

Ship built-in process definition files in the skill repo.

# Non-Goals

- A large catalog of every possible process.

# Approach

- Store built-in profiles in a dedicated folder (e.g., `references/processes/`).
- Include metadata and version info per profile.

# Alternatives

- Require users to define their own profiles from scratch.

# Acceptance Criteria

- Built-in profile files are present and documented.
- Profiles align with the process schema.

# Risks / Dependencies

- Profile updates may require compatibility handling.

# Worklog

2026-01-04 18:23 [agent=codex] Created task to ship built-in process definition files.
2026-01-04 18:40 [agent=codex] Added scope and acceptance criteria for built-in profiles.
2026-01-04 20:12 [agent=codex] State -> InProgress.
2026-01-04 20:13 [agent=codex] Added built-in process definition files for Agile/Scrum/CMMI.
