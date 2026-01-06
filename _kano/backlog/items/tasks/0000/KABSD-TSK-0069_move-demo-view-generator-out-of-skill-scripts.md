---
id: KABSD-TSK-0069
uid: 019b9158-d423-77ff-a4f7-9bdf0f930adb
type: Task
title: "Move demo view generator out of skill scripts"
state: Done
priority: P2
parent: KABSD-EPIC-0002
area: views
iteration: null
tags: ["demo", "views", "cleanup"]
created: 2026-01-06
updated: 2026-01-06
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

2026-01-06 11:27 [agent=codex-cli] Created task to move demo-only view generator from skill scripts into demo host repo tools and update docs.
2026-01-06 11:38 [agent=codex-cli] Moved demo view generation to _kano/backlog/tools/generate_demo_views.py; deprecated skill script; updated docs and regenerated demo outputs.
