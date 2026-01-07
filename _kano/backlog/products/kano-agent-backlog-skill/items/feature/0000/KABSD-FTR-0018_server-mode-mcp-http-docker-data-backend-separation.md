---
id: KABSD-FTR-0018
uid: 019b980d-9c61-775b-96b0-ba88e4dfde72
type: Feature
title: "Server mode (MCP/HTTP) + Docker + data backend separation"
state: Proposed
priority: P2
parent: KABSD-EPIC-0004
area: infrastructure
iteration: null
tags: ["cloud", "server", "mcp", "http", "docker", "data"]
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
original_type: Feature
---

# Context

The roadmap already considers a Cloud Acceleration Layer (e.g., FastAPI + PostgreSQL/MySQL) and a derived index/cache. Before implementing anything, we need a coherent end-to-end server story:

- What protocol/interface should agents call (MCP vs plain HTTP)?
- How do we package and run it (Docker, compose, local vs remote)?
- How do we separate the server runtime from the data it operates on (local files, local SQLite, managed DB)?

This Feature is the container for making these architectural choices in a deliberate, compatible way.

# Goal

- Define a recommended “server mode” architecture that can run locally and in containers.
- Decide an interface contract (MCP and/or HTTP) suitable for agent integration.
- Define the data separation model and supported storage backends.
- Produce decision artifacts (ADRs) that guide subsequent implementation tickets.

# Non-Goals

- Implement the server in this Feature.
- Commit to a specific cloud vendor, Kubernetes, or a full CI/CD pipeline.
- Support every database under the sun; focus on a small, justified set.

# Approach

1. Run focused evaluation Tasks under this Feature:
  - KABSD-TSK-0112 (MCP vs HTTP interface)
  - KABSD-TSK-0113 (Docker packaging and runtime split)
  - KABSD-TSK-0114 (data backend options and SSOT implications)
2. For each topic, produce a short decision matrix and a recommended default.
3. Convert “load-bearing” decisions into ADRs (only when the trade-off is real).
4. Open follow-up implementation tickets once the approach is coherent end-to-end.

# Alternatives

- Stay CLI-only and rely on external orchestration to call scripts.
- Implement HTTP-only and treat MCP as an adapter layer later.
- Centralize writes into a DB-first master (conflicts with local-first/SSOT goals).

# Acceptance Criteria

- A documented recommended architecture for server mode exists (MCP vs HTTP, runtime model, and data separation boundaries).
- The evaluation Tasks (TSK-0112/0113/0114) are Ready/Done with clear outcomes.
- Follow-up implementation items are created with scoped, testable acceptance criteria.

# Risks / Dependencies

- Protocol choice affects long-term compatibility (MCP vs HTTP semantics, versioning).
- Data separation can trigger split-brain risks if writes are not constrained.
- Docker availability and cross-platform filesystem semantics (Windows/macOS/Linux).
- Security/auth decisions may be required earlier than expected if exposed remotely.

# Worklog

2026-01-07 18:43 [agent=copilot] Created to explore serverization options and end-to-end integration before implementation.
