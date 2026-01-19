---
area: backlog
created: '2026-01-19'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-USR-0041
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
- topic
- experimental
title: Archive/unarchive topics and hide archived topics from default views
type: UserStory
uid: 019bd4b8-14c0-7446-ac02-8cf5bf6b0340
updated: '2026-01-19'
---

# Context

Expired topics and finished topics should be out of sight for humans, but still recoverable and searchable for agents. Topic is the primary human focus surface.

# Goal

Provide topic archive/unarchive operations that physically archive topics into a cold store and hide them from default topic lists and dashboards.

# Approach

1) Experimental config gate. 2) Implement  and . 3) Physical archive strategy: materialize topic metadata (brief/digest/publish outputs) into sqlite cold store and optionally move topic folder to a cold directory only if resolver exists. 4) Ensure topic gather/evidence pack can target archived topics with explicit scope.

# Acceptance Criteria

- Topic archive hides archived topics from default topic list/view. - Archived topics remain searchable for agents (scope=all). - Unarchive restores hot visibility deterministically.

# Risks / Dependencies

Topic folder moves can break references; start with DB materialization first.

# Worklog

2026-01-19 13:26 [agent=opencode] [model=unknown] Created item