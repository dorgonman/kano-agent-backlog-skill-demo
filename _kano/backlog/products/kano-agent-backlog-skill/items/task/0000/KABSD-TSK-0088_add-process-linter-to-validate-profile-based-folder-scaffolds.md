---
id: KABSD-TSK-0088
uid: 019b9449-45fb-70be-9fdd-fb60dba923de
type: Task
title: "Add process_linter to validate profile-based folder scaffolds"
state: Done
priority: P2
parent: KABSD-FTR-0004
area: process
iteration: null
tags: ["process", "linter", "bootstrap"]
created: 2026-01-07
updated: 2026-01-07
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

# Goal

# Non-Goals

# Approach

# Alternatives

# Acceptance Criteria

# Risks / Dependencies

# Worklog

2026-01-07 01:09 [agent=codex] Track moving process-folder logic into process_linter and wiring bootstrap to it.
2026-01-07 01:09 [agent=codex] Implemented process_linter, refactored bootstrap to use it for process-based folders, and updated docs.
2026-01-07 01:15 [agent=codex] Fixed config_loader product path resolution, ran process_linter for kano-commit-convention-skill (created stories/subtasks), and noted extra legacy folders (features/userstories).
