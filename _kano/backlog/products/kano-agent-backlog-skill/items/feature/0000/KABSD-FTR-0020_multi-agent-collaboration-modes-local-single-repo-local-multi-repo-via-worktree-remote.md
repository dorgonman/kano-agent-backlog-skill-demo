---
id: KABSD-FTR-0020
uid: 019b985a-c5fe-7707-b445-0047686f84dc
type: Feature
title: "Multi-agent collaboration modes (local single repo / local multi repo via worktree / remote)"
state: Done
priority: P1
parent: KABSD-EPIC-0006
area: collaboration
iteration: null
tags: ["multi-agent", "collaboration", "worktree", "remote"]
created: 2026-01-07
updated: 2026-01-08
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

One of the key value propositions for this skill is enabling multi-agent collaboration. We need a clear breakdown of collaboration modes and their operational constraints:

- Local multi-agent (single repo)
- Local multi-agent (multi repo via Git worktree)
- Remote multi-agent

Each mode impacts workflows (claim/lease), conflict avoidance, consistency guarantees, and tooling integration.

# Goal

- Define the collaboration modes, workflows, and invariants.
- Specify how claim/lease and state transitions apply per mode.
- Identify Git worktree patterns for multi-repo local setups.
- Outline remote collaboration consistency and synchronization strategies.

# Non-Goals

- Implement full networking/server components here.
- Solve all remote deployment/security concerns.

# Approach

1. Create design Tasks for each mode (TSK-0118/0119/0120) to document workflows and constraints.
2. Reference existing coordination layer concepts (e.g., claim/lease; see KABSD-FTR-0016).
3. Capture risk areas and mitigation strategies per mode.
4. Generate ADRs only when real trade-offs are decided.

# Alternatives

- Enforce single-process workflows only (reduces collaboration potential).

# Acceptance Criteria

- Written mode definitions and workflows exist across the three Tasks.
- Claim/lease and conflict avoidance rules are documented.
- Remote mode includes a minimal consistency strategy and boundaries.

# Risks / Dependencies

- Split-brain risks in remote mode; requires strict SSOT and write policies.
- Git worktree complexity and developer ergonomics.
- Coordination layer dependencies (locks, leases) must be coherent.

# Worklog

2026-01-07 20:07 [agent=copilot] Opened to define collaboration modes and architecture before implementation.
2026-01-08 07:24 [agent=copilot] Auto-sync from child KABSD-TSK-0120 -> Done.
2026-01-08 07:24 [agent=copilot] Defined collaboration modes via tasks: single-repo (TSK-0118), worktree-based parallelism (TSK-0119), and remote (TSK-0120) with workflows, invariants, and conflict/consistency rules
