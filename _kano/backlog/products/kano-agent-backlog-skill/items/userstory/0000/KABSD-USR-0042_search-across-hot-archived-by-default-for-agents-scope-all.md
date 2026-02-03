---
area: search
created: '2026-01-19'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-USR-0042
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-EPIC-0010
priority: P1
state: Proposed
tags:
- search
- scope
- all
- archive
- experimental
title: Search across hot + archived by default for agents (scope=all)
type: UserStory
uid: 019bd4b8-1b11-7475-94e5-a712448b52ba
updated: 2026-02-03
---

# Context

Agents must gather all useful material (hot + archived). Humans primarily look at topic brief and do not want noise. Scope defaults must reflect this.

# Goal

Implement search behavior where agent-facing search defaults to scope=all (hot+cold) when experimental archive is enabled, with explicit flags to narrow to hot or cold.

# Approach

1) Extend search/query operations to accept . 2) When experimental enabled, default to all for search commands; keep views/list commands default hot. 3) Query both stores and merge results deterministically (stable sort keys). 4) Clearly label which store each hit came from.

# Acceptance Criteria

- Search defaults to all when experimental enabled. - Results include hits from archived cold store without manual steps. - Deterministic ordering and stable identifiers across merged results.

# Risks / Dependencies

Merging from two backends needs stable ranking and tie-breakers; avoid nondeterminism.

# Worklog

2026-01-19 13:26 [agent=opencode] [model=unknown] Created item
2026-02-03 18:49 [agent=opencode] [model=openai/gpt-5.2] Parent updated: KABSD-FTR-0030 -> KABSD-EPIC-0010.
