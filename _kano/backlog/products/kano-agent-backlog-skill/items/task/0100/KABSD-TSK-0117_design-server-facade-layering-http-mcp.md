---
id: KABSD-TSK-0117
uid: 019b9853-86ed-7ac4-80af-e9bb0fcf0c50
type: Task
title: "Design server facade layering (HTTP/MCP)"
state: Proposed
priority: P2
parent: KABSD-FTR-0019
area: architecture
iteration: null
tags: ["server", "facade", "http", "mcp"]
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

Server facades (HTTP via FastAPI, MCP server) must share an internal service layer that calls `kano-backlog-core`. Cross-cutting concerns (auth, rate limit, logging/redaction, versioning) belong to the facade, not the core.

# Goal

- Define a layered architecture for server facades and the internal service boundary.
- Draft minimal MVP endpoints/tools and their mapping to core operations.
- Identify auth, rate limit, logging, and versioning strategies suitable for local dev and container runtime.

# Non-Goals

- Build the server; only design the layering and contracts.
- Decide internet-facing deployment posture.

# Approach

1. Define request→validate→core→response sequence and error mapping.
2. Propose facade adapters: MCP tool registry vs HTTP routes with OpenAPI.
3. Specify where to plug auth and rate limiting; define log redaction rules.
4. Describe configuration propagation (backlog roots, DB settings) and safe write policies.

# Alternatives

- Implement only one facade (HTTP or MCP) and defer the other.

# Acceptance Criteria

- A facade layering diagram and text description exist in this Task.
- MVP endpoint/tool list mapped to core functions is documented.
- Cross-cutting concern placements are explicitly listed.

# Risks / Dependencies

- Exposing write operations remotely increases consistency/security risk.
- Multiple facades must remain in sync when core evolves; require versioning.

# Worklog

2026-01-07 19:59 [agent=copilot] Define request→validate→core→response path and cross-cutting concerns (auth, rate-limit, logging).
