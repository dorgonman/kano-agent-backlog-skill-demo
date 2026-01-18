---
area: rag
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0243
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: KABSD-USR-0031
priority: P2
state: InProgress
tags:
- embedding
- tests
- telemetry
title: Implement noop embedding adapter and telemetry tests
type: Task
uid: 019bcbf5-7073-70c0-a0c7-4d0f5a7c6c32
updated: 2026-01-19
---

# Context

We need a lightweight reference implementation to validate the embedding adapter contract and allow downstream pipeline tests to run without external dependencies.

# Goal

Provide a noop embedding adapter and tests that validate telemetry and error handling paths.

# Approach

Implement a deterministic noop adapter that returns fixed-dimension vectors (e.g., zeros or a hash-based pseudo-vector) and always populates telemetry fields. Write unit tests that assert fields are present and stable and that missing/invalid config is reported clearly.

# Acceptance Criteria

- Noop adapter is selectable via config. - Tests validate telemetry fields, including trimmed=false behavior and token_count passthrough when available. - No external network calls or server components are required.

# Risks / Dependencies

A hash-based pseudo-vector must be deterministic across platforms; if used, specify encoding and hashing explicitly.

# Worklog

2026-01-17 20:36 [agent=copilot] [model=unknown] Created item
2026-01-19 03:00 [agent=opencode] [model=unknown] Start: implement noop embedding adapter + telemetry tests.
