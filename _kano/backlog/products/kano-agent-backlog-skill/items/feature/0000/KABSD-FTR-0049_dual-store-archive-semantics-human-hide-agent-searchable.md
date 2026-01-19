---
area: backlog
created: '2026-01-19'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0049
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
- archive
- hot-cold
- scope
- experimental
title: Dual-store archive semantics (human-hide, agent-searchable)
type: Feature
uid: 019bd4b8-02d8-71b1-9da1-a675617d1ec1
updated: '2026-01-19'
---

# Context

Humans interpret archive as 'out of sight'; agents must still retrieve archived materials cheaply via search. Current file-first backlog makes it hard to visually separate active vs completed at the filesystem level. We want physical archive pathways (especially DB cold store) while keeping refs stable.

# Goal

Add experimental archive semantics with hot/cold separation and scope-aware operations. When enabled: default human views show hot only; agents/search default to scope=all and can query hot+cold. Archive/unarchive is auditable and idempotent.

# Approach

1) Introduce experimental config gate (disabled by default). 2) Define archive metadata model and/or cold-store materialization strategy (DB preferred). 3) Add CLI commands: workitem archive/unarchive, topic archive/unarchive, plus scope flag plumbing (hot|cold|all) for retrieval/search. 4) Ensure refs remain resolvable; if directory move is used, add a resolver layer; if DB cold store is used, index by id/uid and expose unarchive materialization.

# Acceptance Criteria

- Feature is disabled unless experimental config enabled. - Archive/unarchive commands exist for workitems and topics; operations are idempotent and append Worklog entries. - Default list/view/dashboard excludes archived unless scope includes cold. - Search (agent-facing) defaults to scope=all when experimental enabled. - Error behavior is clear when cold store is unconfigured.

# Risks / Dependencies

Physical moves can break markdown path-based links and wikilinks; DB cold store needs UID/ID mapping and unarchive strategy. Must keep deterministic ordering across hot+cold results.

# Worklog

2026-01-19 13:26 [agent=opencode] [model=unknown] Created item