---
area: docs
created: '2026-01-25'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0301
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0058
priority: P2
state: Proposed
tags:
- docs
- search
title: Document multi-corpus search usage and rebuild commands
type: Task
uid: 019bf587-a111-74d9-8c72-8e7c899d831c
updated: '2026-01-25'
---

# Context

Multi-corpus search introduces new build/query commands and derived DB locations. Users and agents need a clear workflow to keep caches fresh without paying hash-based costs.

# Goal

Document how to build and query backlog vs repo corpuses, including rebuild/force behavior and safe defaults.

# Approach

Update SKILL.md and product docs with: (1) corpus definitions, (2) DB paths, (3) build/query commands, (4) recommended chat prompts, and (5) cache freshness policy (mtime heuristic + --force). Link to the implementing work items and topics.

# Acceptance Criteria

Docs describe both corpuses and provide copy/paste CLI commands and suggested chat prompts. Cache freshness policy is recorded and points to an escape hatch. Links to relevant work items/topics are included.

# Risks / Dependencies

Documentation drift if commands change; mitigate by keeping docs minimal and pointing to --help output where possible.

# Worklog

2026-01-25 22:21 [agent=opencode] Created item