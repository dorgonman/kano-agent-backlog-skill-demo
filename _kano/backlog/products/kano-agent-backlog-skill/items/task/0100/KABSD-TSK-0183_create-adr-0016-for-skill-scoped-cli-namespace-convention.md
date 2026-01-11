---
area: docs
created: '2026-01-12'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0183
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0036
priority: P2
state: InProgress
tags:
- adr
- architecture
title: Create ADR-0016 for Skill-Scoped CLI Namespace Convention
type: Task
uid: 019bae59-7450-73c9-8c03-f19f75ff056b
updated: 2026-01-12
---

# Context

We need a formal ADR that locks in the convention: each skill ships its own skill-scoped CLI and Python packages; the global name 'kano' is reserved for a future umbrella CLI (out of scope here).

# Goal

Produce ADR-0016 under the product decisions folder to codify naming, scope, and migration expectations so future skills (e.g., kano-commit-convention-skill) can coexist without namespace collisions.

# Approach

- Add an ops+CLI command to create ADR files via scripts/kano (so file ops remain auditable).\n- Generate ADR number based on existing decisions folder contents.\n- Write ADR using the standard template and link related backlog items.

# Acceptance Criteria

- ADR-0016 exists in _kano/backlog/products/kano-agent-backlog-skill/decisions/ with correct frontmatter and sections.\n- Related items include KABSD-EPIC-0009 and relevant Features/Tasks.\n- CLI provides a stable way to create future ADRs (kano backlog adr create).

# Risks / Dependencies

- Incorrect ADR numbering or inconsistent filename slug; mitigated by scanning existing ADR IDs.\n- Additional CLI surface area; keep minimal and aligned to ADR-0013.

# Worklog

2026-01-12 02:37 [agent=copilot] Created item
2026-01-12 02:42 [agent=copilot] Started: implement ADR creation command and author ADR-0016.
