---
area: workflow
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0052
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
- inbox
- capture
- triage
title: 'Inbox Flow: low-friction capture + triage (human/agent entrypoints)'
type: Feature
uid: 019bde93-6d75-76e8-857a-d91c6dcc7548
updated: '2026-01-21'
---

# Context

Users and agents frequently produce valuable fragments while context-switching (e.g., jumping from embeddings to voice mode to project health ideas). We need a low-friction way to 'drop' those fragments into the system without immediately turning them into backlog items or decisions. The flow must reduce loss of ideas while avoiding new long-lived data models that increase maintenance burden.

# Goal

Provide a unified capture + triage entrypoint ('Inbox Flow') that accepts human-initiated and agent-initiated inputs, stores them safely, and supports later promotion into canonical work items/ADRs or into a non-backlog brainstorm area.

# Approach

Expose a small CLI surface (example commands: kano-backlog inbox add, kano-backlog inbox list, kano-backlog inbox triage). Keep it local-first and deterministic. Prefer reusing existing structures (Topic/workset/artifacts) rather than introducing a new canonical entity type. Triage must be human-in-the-loop by default: generate drafts and require explicit promotion to create/update work items.

# Acceptance Criteria

- A capture command can accept a text transcript (pasted, stdin, or file) and record it as an inbox entry with minimal metadata (source/channel/kind/topic_hint).
- A triage command can promote an inbox entry into: (a) a draft proposal/work item (requires explicit create/update), or (b) a brainstorm entry that is explicitly not backlog.
- No fixed cadence assumptions; triggering is integration-defined (manual, CI, or agent-triggered).
- All artifacts produced are deterministic and auditable (agent id recorded where applicable).

# Risks / Dependencies

Risk: Becoming a new SoT/6th memory layer. Mitigation: reuse existing storage + derived views; keep inbox entries lightweight; allow cleanup/archival. Risk: Agent auto-promotes low-quality items. Mitigation: human confirmation is required for promotion.

# Worklog

2026-01-21 11:22 [agent=opencode] Created item