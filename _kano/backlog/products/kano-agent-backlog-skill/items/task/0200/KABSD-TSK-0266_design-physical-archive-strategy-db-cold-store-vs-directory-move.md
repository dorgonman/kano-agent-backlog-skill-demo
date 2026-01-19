---
area: design
created: '2026-01-19'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0266
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
- db
- directory
- refs
- design
title: 'Design: physical archive strategy (DB cold store vs directory move)'
type: Task
uid: 019bd4b8-2982-75b4-87b5-19afe9d85526
updated: '2026-01-19'
---

# Context

Physical archive can be implemented either by moving files into a cold directory or materializing into a SQLite cold store. File moves can break path-based references; DB materialization may require resolver tooling for unarchive and ref reconstruction.

# Goal

Decide a safe physical archive strategy for 0.0.3 and document the recommended approach, including how refs are preserved and how unarchive works.

# Approach

1) Enumerate existing ref/link mechanisms (wikilinks, path links, id references, uid usage in topic manifests). 2) Compare DB cold store vs directory move on: ref stability, simplicity, determinism, migration cost. 3) Propose minimal MVP: DB cold store first, directory move later behind separate flag. 4) Specify schemas and operations at a level implementable without server runtime.

# Acceptance Criteria

- Written recommendation captured in this task's Approach and/or linked ADR. - Clear MVP choice with rollback plan. - Identified failure modes and mitigations.

# Risks / Dependencies

Hidden coupling to filesystem paths; link fix tooling may need scope awareness.

# Worklog

2026-01-19 13:26 [agent=opencode] [model=unknown] Created item