---
area: backlog
created: '2026-01-19'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-EPIC-0010
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P1
state: Proposed
tags:
- milestone
- 0.0.3
- archive
- experimental
title: 0.0.3 Archive semantics + topic evidence packs
type: Epic
uid: 019bd4b7-de07-730b-8ad0-e0162793d8ae
updated: '2026-01-19'
---

# Context

Backlog scale is now too large for humans to rely on work item lists. Humans mainly operate via topic briefs, while agents can search quickly. We need an archive mechanism that hides from human default views but remains agent-searchable, and a deterministic topic evidence-pack workflow for deep decision work.

# Goal

Ship an experimental archive + evidence-pack system for milestone 0.0.3: (1) physical archive pathway design (DB cold store vs directory move), (2) scope-aware retrieval where agents default to scope=all, and (3) deterministic topic evidence packs (brief/digest/evidence) to support focus vs sculpt modes.

# Approach

Implement as experimental-by-default (config disabled). Add scope semantics (hot|cold|all) and wire into search and topic gather. Prefer DB cold store for physical archive (minimal ref breakage). Keep file canonical as source-of-truth; archived material may be materialized into sqlite for agent search. Produce deterministic artifacts under topic publish/ and item artifacts/ with stable ordering and no time-based noise.

# Acceptance Criteria

- Experimental flag gates all archive/evidence-pack behavior; default config keeps current behavior. - Agents can search scope=all and retrieve archived materials when enabled. - Humans can stay focused on topic briefs; archived items/topics are out-of-sight by default. - Deterministic topic evidence pack generation exists and is reproducible from the same source state.

# Risks / Dependencies

Cross-reference stability if using directory move; requires resolver/UID mapping. Migration/index synchronization between file and sqlite must be deterministic and auditable. Avoid server runtime per local-first-first clause.

# Worklog

2026-01-19 13:26 [agent=opencode] [model=unknown] Created item