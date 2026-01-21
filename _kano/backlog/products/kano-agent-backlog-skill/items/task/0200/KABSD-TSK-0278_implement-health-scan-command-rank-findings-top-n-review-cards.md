---
area: qa
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0278
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0053
priority: P2
state: Proposed
tags:
- health
- ranking
title: Implement Health Scan command (rank findings -> top-N review cards)
type: Task
uid: 019bde96-3a9d-70a7-ae30-f1d22fb1702a
updated: '2026-01-21'
---

# Context

Humans cannot continuously inspect full audit output. We need a deterministic spotlight that selects a small number of high-value review cards from audit findings.

# Goal

Add a Health Scan command that consumes JSON findings and emits top-N review cards with evidence and suggested next actions.

# Approach

Load Finding list from audit JSON. Apply deterministic ranking rules (severity first, then novelty vs cooldown, then breadth of impact via evidence count). Apply dedup/cooldown using fingerprint. Emit a Markdown report with N cards. Keep it on-demand; cadence is not assumed.

# Acceptance Criteria

- Given the same findings input, ranking and output are deterministic.
- Each card includes: kind, evidence refs, question, suggested next step, confidence.
- Supports top-N selection.
- Supports a cooldown window using stable fingerprints.

# Risks / Dependencies

Risk: Ranking becomes gamed/Goodharted if tied to fixed cadence. Mitigation: do not encode cadence; add human feedback later if needed.

# Worklog

2026-01-21 11:25 [agent=opencode] Created item