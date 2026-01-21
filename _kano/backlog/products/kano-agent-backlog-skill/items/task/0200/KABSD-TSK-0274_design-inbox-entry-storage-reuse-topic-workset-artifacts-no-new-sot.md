---
area: workflow
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0274
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0052
priority: P1
state: Proposed
tags:
- inbox
- storage
title: Design Inbox entry storage (reuse Topic/workset/artifacts; no new SoT)
type: Task
uid: 019bde95-153f-730d-8056-40942d281096
updated: '2026-01-21'
---

# Context

We want an inbox-like capture buffer but we must avoid introducing a new canonical entity type that increases maintenance cost.

# Goal

Decide and document how inbox entries are stored using existing primitives (Topic/workset/artifacts), including cleanup policy and how triage promotes entries.

# Approach

Evaluate 2-3 storage options that reuse existing structures, e.g.: (A) a dedicated Topic (e.g., topic 'inbox') with entries as notes/materials; (B) per-agent inbox Topic; (C) store entries under product artifacts with a stable schema. Choose one based on minimal new concepts and easy promotion into work items/brainstorm. Document the chosen layout, filename rules, and how commands map to files.

# Acceptance Criteria

- Chosen storage layout is documented with exact paths and example files.
- The design explicitly states what is canonical vs derived vs cache.
- Promotion path (inbox -> work item draft / brainstorm) is defined.
- Cleanup/archival approach is specified.

# Risks / Dependencies

Risk: Mixing inbox artifacts with Topics breaks Topic semantics. Mitigation: keep inbox as a thin reuse layer and avoid auto-distill/active topic side effects.

# Worklog

2026-01-21 11:24 [agent=opencode] Created item