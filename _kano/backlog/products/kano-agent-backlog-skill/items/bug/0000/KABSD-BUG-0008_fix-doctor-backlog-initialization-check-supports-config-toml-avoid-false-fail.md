---
area: qa
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-BUG-0008
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: [KABSD-FTR-0053]
owner: None
parent: null
priority: P1
state: Proposed
tags:
- doctor
- config
title: Fix doctor backlog initialization check (supports config.toml; avoid false
  FAIL)
type: Bug
uid: 019bde9d-1b45-72b4-9d6f-6a028c524c4f
updated: '2026-01-21'
---

# Context

kano-backlog doctor --product kano-agent-backlog-skill reports Backlog Initialized = FAIL because it checks for _kano/backlog/products/<product>/_config/config.json.

In this repo, the product uses _kano/backlog/products/kano-agent-backlog-skill/_config/config.toml (and the product directory already contains items/views), so the doctor check false-fails and reduces trust in doctor as a health check and CI gate.

# Goal

Make doctor correctly detect product initialization in this repo layout, so it does not false-fail when the product is effectively initialized.

# Approach

Update the doctor initialization marker logic to match the current config system.

Candidate fixes (pick one consistent approach):
- Prefer config.toml as canonical marker for initialization.
- Accept either config.toml or config.json (with documented precedence).
- Or update init tooling to always materialize config.json and keep doctor unchanged.

Keep the check deterministic and fast (no full scans).

# Acceptance Criteria

- `kano-backlog doctor --product kano-agent-backlog-skill` passes the Backlog Initialized check in this repo.
- The initialization check matches the actual config format used by the product.
- Doctor output remains deterministic and fast (no heavy scans).
- If both config formats are supported, behavior is documented.

# Risks / Dependencies

Risk: Multiple config formats cause ambiguity. Mitigation: define a single canonical marker (preferred) or strict precedence order.

# Worklog

2026-01-21 11:33 [agent=opencode] Created item