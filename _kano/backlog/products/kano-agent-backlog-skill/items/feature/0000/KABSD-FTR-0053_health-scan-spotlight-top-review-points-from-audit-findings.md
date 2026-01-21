---
area: qa
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0053
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: [KABSD-BUG-0008]
owner: None
parent: null
priority: P2
state: Proposed
tags:
- health
- audit
- review
title: 'Health Scan: spotlight top review points from audit findings'
type: Feature
uid: 019bde94-288b-74a8-bcdc-bd7f8f330afc
updated: '2026-01-21'
---

# Context

Audit commands are good at finding all violations, but humans cannot review long lists continuously. We want an attention-efficient 'spotlight' that selects a small number of high-value review points (decisions/risks/regressions/inconsistencies) based on evidence, without duplicating audit rule logic.

# Goal

Provide an on-demand Health Scan that consumes structured audit findings (and optionally other deterministic signals) and emits top-N review cards with evidence, a clear question, and suggested next steps.

# Approach

Define a structured Finding schema (rule_id, severity, message, evidence refs, fingerprint). Ensure audit commands can emit findings as JSON. Implement Health Scan as a pure consumer: load findings, apply deterministic ranking, apply cooldown/dedup using fingerprint, and format top-N cards. Do not implement independent validation rules in Health Scan.

# Acceptance Criteria

- Audit commands can emit a machine-readable list of findings (JSON) with stable fingerprints.
- Health Scan command can generate top-N review cards on-demand given a revision/window.
- Each card includes: kind, evidence (>=2 refs when available), question, suggested next step, confidence.
- No fixed cadence assumptions; execution timing is integration-defined.
- Health Scan does not duplicate audit validation rules; it consumes audit output.

# Risks / Dependencies

Risk: Ranking becomes subjective/hallucinated. Mitigation: deterministic ranking rules + evidence requirement + human feedback hook (useful/ignore/incorrect) as a follow-up. Risk: Audit output not structured. Mitigation: first task is to add JSON output + fingerprints.

# Worklog

2026-01-21 11:23 [agent=opencode] Created item