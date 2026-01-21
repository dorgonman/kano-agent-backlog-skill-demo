---
area: ux
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0272
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0051
priority: P1
state: Proposed
tags:
- constellation
- graph
- mermaid
title: Implement Constellation build command (nodes/edges -> Mermaid + JSON)
type: Task
uid: 019bde94-a88f-74b3-af98-5275848084d9
updated: '2026-01-21'
---

# Context

Kano Constellation is the flagship 'Product Blueprint' view. It must be derived from existing SoT artifacts (no manual graph maintenance).

# Goal

Add a CLI command that builds a bounded graph from a seed artifact and emits Mermaid + JSON outputs.

# Approach

Implement a Constellation builder that:
1) resolves a seed artifact (work item / ADR / topic) to a node
2) extracts explicit edges from references (IDs, markdown links, Related sections) and allowlisted structural edges
3) traverses breadth-first up to --depth
4) writes (a) Markdown report containing Mermaid graph and summary, and (b) JSON graph with evidence refs.

# Acceptance Criteria

- A CLI command exists (name TBD) that accepts --from and --depth.
- The Mermaid output is stable given the same inputs (deterministic ordering).
- The JSON output includes nodes, edges, and for each edge a source reference (file path and/or referenced ID).
- Traversal respects depth and fanout limits to avoid explosion.

# Risks / Dependencies

Risk: Parsing references is brittle across formats. Mitigation: start with ID regex + explicit markdown links; keep heuristics allowlisted.

# Worklog

2026-01-21 11:24 [agent=opencode] Created item