---
id: KABSD-TSK-0115
uid: 019b9853-51dc-724c-9636-d8f9cfe8f136
type: Task
title: "Define core interfaces and module boundaries"
state: Proposed
priority: P1
parent: KABSD-FTR-0019
area: architecture
iteration: null
tags: ["core", "interfaces", "boundaries"]
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

We need a transport-agnostic `kano-backlog-core` that encapsulates domain logic and exposes stable interfaces. The core must not know who calls it (CLI/HTTP/MCP/GUI). Modules to define:

- Context/config loader (product/sandbox/repo roots)
- CanonicalStore (files) as SSOT
- DerivedStore interfaces (sqlite/postgres/mysql)
- Refs (parse/resolve against items/index)
- StateMachine (ready gate, status transitions)
- Audit (append-only worklog, file ops log)
- Workset (per-agent cache abstraction)
- Errors (typed exceptions)

We must also define invariants and ownership boundaries to prevent coupling.

# Goal

- Specify clear Python interfaces/classes for each module above.
- Document invariants (SSOT, rebuildability, auditability, compatibility).
- Outline a minimal internal service layer (if needed) that facades call.

# Non-Goals

- Implement all modules; this Task focuses on definitions.
- Decide HTTP/MCP specifics; captured in server facade Task.

# Approach

1. Write an interface map (module → classes/functions → responsibilities).
2. Define error taxonomy and cross-module exception contracts.
3. List invariants and pre/post-conditions per interface.
4. Identify seams for dependency injection (e.g., storage backends).
5. Call out what belongs strictly to facades (arg parsing, auth, formatting).

# Alternatives

- Keep ad-hoc functions without a core package (harder reuse/testing).

# Acceptance Criteria

- An interface document exists in this Task outlining modules and signatures (proto-level).
- Invariants and error taxonomy are listed.
- A small example call flow is described (core-only, no transport code).

# Risks / Dependencies

- Over-design can slow delivery; keep pragmatic.
- Leaking transport concerns into core causes long-term coupling.

# Worklog

2026-01-07 19:59 [agent=copilot] Create decision matrix for core lib interfaces and ownership; list invariants.
