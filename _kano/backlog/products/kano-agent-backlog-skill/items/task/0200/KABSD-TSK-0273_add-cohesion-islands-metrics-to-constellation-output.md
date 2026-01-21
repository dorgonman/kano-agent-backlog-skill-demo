---
area: ux
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0273
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0051
priority: P2
state: Proposed
tags:
- constellation
- metrics
title: Add cohesion + islands metrics to Constellation output
type: Task
uid: 019bde94-deb6-7190-975f-f29c84300411
updated: '2026-01-21'
---

# Context

Constellation should not only draw a graph; it should help detect fragmentation (too many islands) and highlight key hubs.

# Goal

Compute simple deterministic graph metrics and include them in the Constellation report.

# Approach

Given the derived graph, compute: number of connected components, largest component ratio, average degree, list of isolated nodes (degree=0), and top bridge/hub candidates (by degree). Present these metrics at the top of the Markdown report.

# Acceptance Criteria

- Metrics are computed deterministically from the same graph.
- Report includes an explicit Islands section listing isolated nodes.
- Report includes a short Cohesion section with the key numbers.
- Metrics computation has no external dependencies beyond current stack.

# Risks / Dependencies

Risk: Metrics mislead if edge extraction is incomplete. Mitigation: clearly label metrics as derived-from-current-edge-model and iterate edge sources over time.

# Worklog

2026-01-21 11:24 [agent=opencode] Created item