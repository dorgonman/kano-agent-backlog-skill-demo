---
id: KABSD-TSK-0098
uid: null
type: Task
title: Create ADR for multi-product architecture decisions
state: Proposed
priority: P2
parent: null
area: documentation
iteration: "0.0.2"
tags: ["adr", "architecture", "documentation", "cross-product"]
created: 2026-01-07
updated: 2026-01-07
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
---

# Context

FTR-0010 implemented significant architectural decisions for the multi-product platform (per-product indexes, product column retention, directory structure). These decisions need formal documentation in Architecture Decision Records (ADRs) for future reference and understanding.

# Goal

Create 3 ADRs documenting the core architectural decisions made in FTR-0010.

# Approach

1. Create ADR-001: Per-Product Isolated Index Architecture
   - Problem: How to structure backlog indexes for multiple products
   - Decision: Each product has its own SQLite database file
   - Rationale: Isolation, performance, scalability
   
2. Create ADR-002: Product Column Retention in Index Schema
   - Problem: Is product column necessary when using per-product indexes?
   - Decision: Retain product column for consistency and extensibility
   - Rationale: Self-documenting data, future global aggregation
   
3. Create ADR-003: Multi-Product Directory Structure
   - Problem: How to organize backlog items for multiple products
   - Decision: _kano/backlog/products/<product>/ structure
   - Rationale: Clear isolation, convention over configuration

# Acceptance Criteria

- [ ] ADR-001 created and linked in decisions/
- [ ] ADR-002 created and linked in decisions/
- [ ] ADR-003 created and linked in decisions/
- [ ] ADRs formatted per ADR template standards
- [ ] All ADRs linked from FTR-0010
- [ ] ADRs added to git

# Risks / Dependencies

None

# Worklog

2026-01-07 02:10 [agent=copilot] Created task to document architectural decisions made in FTR-0010 multi-product implementation.
