---
area: ux
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0051
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
- constellation
- context-graph
- views
title: Kano Constellation derived product blueprint (Context Graph view)
type: Feature
uid: 019bde93-2db6-704c-910a-f512ed3f90b0
updated: '2026-01-21'
---

# Context

We want a flagship way to visualize the product as a graph, without introducing a new source of truth. The conversation highlighted human attention drift (rapid topic switching) and the need to re-orient to a 'north star' goal. The system should project existing SoT artifacts (ADRs/workitems/topics/worksets) into a navigable graph view, not create/maintain a separate graph dataset.

# Goal

Provide a memorable, high-signal visualization (Kano Constellation) that lets humans explore product structure, detect fragmentation (islands), and validate cohesion from existing backlog artifacts.

# Approach

Implement Kano Constellation as a derived view only. Build nodes/edges from explicit references (IDs, links, Related sections) and deterministic structural relationships. Output Mermaid for human reading and JSON for tooling. Compute simple cohesion metrics (connected components, largest component ratio, degree stats) and an islands list. Add guardrails: no manual edge maintenance; every edge must be traceable to evidence refs.

# Acceptance Criteria

- Command exists to build a Constellation from a seed artifact (ADR/work item/topic) with bounded depth.
- Output includes a Mermaid graph and a machine-readable JSON graph.
- Every edge includes an evidence reference (file/ID/link) or is from an allowlisted deterministic structural rule.
- Output includes cohesion/islands metrics and a list of isolated nodes.
- View artifacts are safe-to-delete and reproducible from SoT.

# Risks / Dependencies

Risk: Scope creep into a new SoT (manual graph editing). Mitigation: derived-only rule + evidence requirement. Risk: noisy heuristics; start with explicit links first and keep heuristics optional/allowlisted.

# Worklog

2026-01-21 11:22 [agent=opencode] Created item