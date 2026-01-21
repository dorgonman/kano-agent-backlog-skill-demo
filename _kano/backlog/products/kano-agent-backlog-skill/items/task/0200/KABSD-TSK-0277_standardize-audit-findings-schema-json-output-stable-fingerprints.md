---
area: qa
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0277
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0053
priority: P1
state: Proposed
tags:
- audit
- json
title: Standardize audit findings schema + JSON output (stable fingerprints)
type: Task
uid: 019bde96-07ab-73ea-9184-03a30c93ae9e
updated: '2026-01-21'
---

# Context

Health Scan should consume audit output rather than duplicating validation rules. This requires audit commands to emit structured, machine-readable findings.

# Goal

Define a common Finding schema and ensure audit commands can emit JSON findings with stable fingerprints for dedup/cooldown.

# Approach

Introduce a core Finding model (rule_id, severity, message, evidence_refs, fingerprint). Update existing audit-like commands to support --format json (or add a wrapper command) that outputs a list of findings. Fingerprint should be stable across runs given the same evidence (e.g., hash of rule_id + normalized evidence refs).

# Acceptance Criteria

- There is a documented Finding schema.
- At least one existing audit command can output findings as JSON.
- Each finding includes evidence references and a stable fingerprint.
- Output is deterministic (ordering and content) given the same inputs.

# Risks / Dependencies

Risk: Retro-fitting multiple commands is costly. Mitigation: start with one high-value audit, then expand.

# Worklog

2026-01-21 11:25 [agent=opencode] Created item