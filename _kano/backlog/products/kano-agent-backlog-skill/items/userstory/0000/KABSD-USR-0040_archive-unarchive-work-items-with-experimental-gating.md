---
area: backlog
created: '2026-01-19'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-USR-0040
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0030
priority: P1
state: Proposed
tags:
- archive
- workitem
- experimental
title: Archive/unarchive work items with experimental gating
type: UserStory
uid: 019bd4b8-0eba-7674-8968-0861b1c63107
updated: '2026-01-19'
---

# Context

Humans need archive to reduce visible ticket volume, but agents must still search archived materials with low incremental cost. This feature must be experimental-by-default and off in config until stabilized.

# Goal

Provide workitem archive/unarchive commands that physically archive items into a cold store (prefer sqlite cold store), while keeping canonical IDs resolvable and agent search defaulting to scope=all when experimental is enabled.

# Approach

1) Add experimental config gate (disabled by default). 2) Implement  and . 3) Physical archive path: materialize archived item records into sqlite cold store table(s) keyed by uid/id with full text for search; hot store remains file-first. 4) Unarchive restores/moves back to hot representation. 5) Each operation appends a Worklog entry with action, reason, and evidence pointers.

# Acceptance Criteria

- Archive/unarchive are idempotent and safe to retry. - When disabled, commands error with a clear 'experimental feature disabled' message. - Archived items are hidden from default human views/lists. - Agent search (when enabled) includes archived items by default (scope=all).

# Worklog

2026-01-19 13:26 [agent=opencode] [model=unknown] Created item