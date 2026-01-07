---
id: KABSD-TSK-0112
uid: 019b980d-bfa4-7a37-a268-19635fdded6b
type: Task
title: "Evaluate server interface: MCP vs HTTP"
state: Proposed
priority: P2
parent: KABSD-FTR-0018
area: infrastructure
iteration: null
tags: ["cloud", "server", "mcp", "http"]
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

To support “cloud acceleration” and multi-agent collaboration, the skill may need to run as a long-lived service. Before implementation, we need to choose the primary interface contract:

- MCP server: likely better aligned with agent tooling ecosystems and standardized tool invocation.
- HTTP server: a widely compatible option (e.g., FastAPI + OpenAPI) that is easy to deploy and observe.

This decision affects client integration, versioning, auth, observability, and the future compatibility surface.

# Goal

- Produce a recommendation: MCP-only, HTTP-only, or dual-interface (with clear layering).
- Define the minimum viable API surface for server mode (read/write operations and constraints).
- Identify required cross-cutting concerns (authn/authz, rate limiting, logging/redaction, versioning).

# Non-Goals

- Building the full server implementation.
- Designing UI/console dashboards.
- Solving full multi-tenant SaaS concerns.

# Approach

1. Define evaluation criteria (weighted):
  - Agent integration ergonomics
  - Backward compatibility/versioning story
  - Security/auth model feasibility
  - Observability (logs, tracing) and debuggability
  - Deployment constraints (local/dev, Docker, remote)
2. Enumerate the minimal endpoint/tool list for both options.
3. Recommend an architecture:
  - If dual: define a single internal service layer with adapters (MCP adapter, HTTP adapter).
4. Capture the decision in an ADR if the trade-off is significant.

# Alternatives

- Keep everything as CLI commands invoked by a supervisor.
- Start with HTTP-only and add MCP later when demand proves out.
- Start with MCP-only and expose HTTP as a thin compatibility proxy later.

# Acceptance Criteria

- A decision matrix (MCP vs HTTP) is written into this Task.
- A recommended default is clearly stated, including rationale.
- A proposed public contract exists (tool names or HTTP routes) at MVP scope.
- Identified required cross-cutting features and “must-not” constraints are listed.

# Risks / Dependencies

- Premature protocol commitment can create long-term migration costs.
- Different clients may require different auth models (local dev vs remote).
- Some operations may be unsafe in a remote context (writes) without stronger constraints.

# Worklog

2026-01-07 18:43 [agent=copilot] Created for architecture trade-off evaluation.
