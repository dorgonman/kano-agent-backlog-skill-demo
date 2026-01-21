---
area: product
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0054
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P3
state: Proposed
tags:
- brainstorm
- ideas
title: 'Brainstorm Pulse: generate non-backlog idea feed (time-ordered)'
type: Feature
uid: 019bde94-6114-76ee-b3cf-4f0cf65c7490
updated: '2026-01-21'
---

# Context

We want a lightweight way to inject 'fresh fuel' (ideas/suggestions) without turning them into backlog commitments. The conversation explicitly warned about Goodhart traps (fixed cadence/KPI) and about premature idea clustering (similarity is hard and can create noise).

# Goal

Provide an on-demand Brainstorm Pulse that writes time-ordered idea entries to a dedicated area that is explicitly not part of the backlog workflow, while keeping the output deterministic and easy to review.

# Approach

Add a command to generate N ideas into a time-partitioned file path (e.g., YYYY-MM). Use a fixed schema per idea (id, title, pitch, why_it_might_help, cost/risk, related). Do not implement automatic clustering initially; rely on time order + search. Optionally add a later follow-up item for deterministic linking/clustering once there is real volume and a clear signal.

# Acceptance Criteria

- A command can generate N brainstorm entries on-demand (no cadence assumption).
- Entries are written to a dedicated brainstorm area, clearly separated from backlog items (not proposals).
- Each entry uses a consistent schema and stable identifiers.
- The system does not automatically promote brainstorm entries into backlog items.
- No clustering is required for MVP.

# Risks / Dependencies

Risk: Idea spam / low signal. Mitigation: optional human feedback rating + limits. Risk: Misunderstood as commitments. Mitigation: explicit storage location + labeling 'not backlog'.

# Worklog

2026-01-21 11:23 [agent=opencode] Created item