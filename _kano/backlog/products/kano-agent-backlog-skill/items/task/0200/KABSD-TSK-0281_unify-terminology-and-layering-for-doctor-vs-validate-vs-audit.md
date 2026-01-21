---
area: architecture
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0281
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Proposed
tags:
- naming
- doctor
- validate
- audit
title: Unify terminology and layering for doctor vs validate vs audit
type: Task
uid: 019bde9d-e20a-742a-bb66-ced796c45b6b
updated: '2026-01-21'
---

# Context

Current CLI surface and docs use overlapping terms (doctor, validate/validator, audit, decision-audit, audit logs). This is confusing for users and makes it unclear which command is authoritative for 'health'.

# Goal

Define and document a clear, consistent terminology and responsibility split for doctor vs validate vs audit, and identify any command naming/alias changes needed for long-term clarity.

# Approach

1) Inventory existing commands and artifacts that map to these concepts (doctor, validate uids/links, topic decision-audit, audit log infrastructure).
2) Propose a canonical vocabulary with definitions, including which outputs are deterministic gates vs informational reports.
3) Define layering rules:
   - doctor: fast environment/readiness checks
   - validate: deterministic data integrity checks
   - audit: trace/logging of operations and/or auditable reports (explicitly defined)
4) Produce a short design note (ADR or references doc) and a migration plan (aliases, deprecations, doc updates).

# Acceptance Criteria

- A single document exists defining the terminology and layering rules.
- The document includes a mapping table: concept -> commands -> outputs -> intended usage (CI gate vs manual).
- Any recommended renames/aliases are listed with a non-breaking migration plan.
- Docs are updated to align with the chosen terminology (or a follow-up item is created if changes are large).

# Risks / Dependencies

Risk: Bikeshedding. Mitigation: constrain scope to user confusion reduction and consistent layering; avoid large refactors unless necessary.

# Worklog

2026-01-21 11:34 [agent=opencode] Created item