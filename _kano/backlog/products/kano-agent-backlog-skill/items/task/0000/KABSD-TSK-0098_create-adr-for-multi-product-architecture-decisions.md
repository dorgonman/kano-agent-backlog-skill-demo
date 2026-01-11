---
area: documentation
created: 2026-01-07
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0098
iteration: 0.0.2
links:
  blocked_by: []
  blocks: []
  relates: []
owner: null
parent: KABSD-FTR-0010
priority: P2
state: Planned
tags:
- adr
- architecture
- documentation
- cross-product
title: Create ADR for multi-product architecture decisions
type: Task
uid: 019bac4a-6833-74ff-ba8f-533b97372f59
updated: 2026-01-07
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
2026-01-07 08:23 [agent=copilot] Validate parent resolution: moving task to Ready.
2026-01-07 08:23 [agent=copilot] Smoke-test parent validation with same-product parent.