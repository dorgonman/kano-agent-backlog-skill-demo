---
id: KABSD-TSK-0096
uid: null
type: Task
title: Document multi-product architecture and best practices
state: Planned
priority: P2
parent: KABSD-FTR-0011
area: documentation
iteration: "0.0.2"
tags: ["documentation", "architecture", "guide"]
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

The multi-product platform architecture (FTR-0010) is now operational, but lacks comprehensive documentation. Future developers and users need clear guidance on:
- Why we use per-product isolated indexes
- How the product column provides value despite per-product isolation
- Best practices for creating new products
- How to use cross-product features (when available)

# Goal

Create comprehensive documentation explaining the multi-product architecture design, rationale, and usage patterns.

# Approach

1. Update `references/schema.md` with product column rationale
2. Create multi-product architecture guide
3. Document best practices for:
   - Creating new products
   - Using --product flag in CLI tools
   - Index management per product
   - Future cross-product scenarios
4. Add examples and common patterns

# Acceptance Criteria

- [ ] Schema documentation includes product column rationale
- [ ] Architecture guide created with design decisions
- [ ] Best practices documented for common scenarios
- [ ] Examples provided for CLI usage patterns
- [ ] ADR created for per-product index decision

# Risks / Dependencies

None

# Worklog

2026-01-07 01:55 [agent=copilot] Task created to document multi-product architecture and rationale for future developers.
2026-01-07 08:32 [agent=copilot] Smoke-test blocked_by/product-aware resolution.
