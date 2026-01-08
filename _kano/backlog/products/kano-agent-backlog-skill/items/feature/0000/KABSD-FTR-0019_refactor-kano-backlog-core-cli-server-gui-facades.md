---
area: architecture
created: '2026-01-07'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0019
iteration: null
links:
  blocked_by: []
  blocks: []
  relates: []
owner: null
parent: KABSD-EPIC-0004
priority: P1
state: Done
tags:
- refactor
- core
- facade
- modularization
title: 'Refactor: kano-backlog-core + CLI/Server/GUI facades'
type: Feature
uid: 019b9853-3e84-7ee9-b9cc-5b82b10d8de5
updated: '2026-01-08'
---

# Context

Before proceeding with Cloud-related work, we need a cohesive modular architecture that isolates domain logic from transports and presentation. The goal is to extract a `kano-backlog-core` library (no dependency on CLI/HTTP/MCP/GUI) and wrap it with thin facades:

- Core library: Context/config, CanonicalStore (files), DerivedStore (sqlite/postgres/mysql) interfaces, Refs parsing/resolution, StateMachine (ready gate, transitions), Audit (append-only worklog, file ops log), Workset (per-agent cache), Errors (typed exceptions), plus invariants.
- CLI facade: arg parsing, core invocation, human/JSON formatting, exit codes; legacy scripts gradually migrated to thin wrappers.
- Server facade: HTTP (FastAPI) or MCP server; request→validate→core→response; auth, rate limit, logging/redaction live here.
- GUI facade: view models invoking core; presents search results, refs, claim state, workset contents; UX only.

# Goal

- Define the module boundaries and ownership model for `kano-backlog-core`.
- Specify facades’ responsibilities and their interfaces to the core.
- Produce a phased migration plan for existing scripts to thin wrappers.
- Unblock Cloud serverization by ensuring the core is transport-agnostic.

# Non-Goals

- Implement all facades in this Feature.
- Decide production deployment stack (Kubernetes, etc.).
- Build full GUI; only define the boundary.

# Approach

1. Create evaluation Tasks to define core interfaces (TSK-0115), CLI migration plan (TSK-0116), and server facade layering (TSK-0117).
2. Capture invariants and typed error taxonomy in the core design.
3. Document facade contracts and cross-cutting concerns (auth, rate limit, logging/redaction, versioning).
4. Write ADRs only for decisions with real trade-offs; otherwise, keep detailed design in Tasks.

# Alternatives

- Keep monolithic scripts and add ad-hoc HTTP endpoints (high coupling, harder to test).
- Implement HTTP-only and treat MCP as future adapter; or vice versa.

# Acceptance Criteria

- Core module boundaries and interfaces are documented and agreed.
- CLI migration plan exists with entry points and output formatting guidance.
- Server facade design describes request flow, cross-cutting concerns, and layering.
- Follow-up implementation tickets exist for the first migration steps.

# Risks / Dependencies

- Refactor breadth can stall feature work; keep phases small.
- Coupling sneaks into core via convenience imports; enforce rules.
- Versioning and compatibility across transports need early definition.

# Worklog

2026-01-07 19:59 [agent=copilot] Opened to plan modularization before cloud work; define core lib + facades.
2026-01-07 23:30 [agent=copilot] Auto-sync from child KABSD-TSK-0115 -> InProgress.
2026-01-08 07:20 [agent=copilot] Feature complete: core interface specifications (TSK-0115), CLI migration plan (TSK-0116), and server facade design (TSK-0117) all documented
2026-01-08 07:21 [agent=copilot] Completed design tasks for CLI migration (TSK-0116) and server facade layering (TSK-0117); core interfaces already defined (TSK-0115)
2026-01-08 16:26 [agent=cli-test] Testing CLI worklog append