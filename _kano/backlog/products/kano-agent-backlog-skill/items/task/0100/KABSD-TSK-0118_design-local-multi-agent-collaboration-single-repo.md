---
id: KABSD-TSK-0118
uid: 019b985a-dd84-7df1-8713-491415539d85
type: Task
title: "Design local multi-agent collaboration: single repo"
state: Proposed
priority: P1
parent: KABSD-FTR-0020
area: collaboration
iteration: null
tags: ["multi-agent", "single-repo"]
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

Local multi-agent collaboration within a single repository requires clear workflows to prevent conflicts and ensure auditable progress. Agents need claim/lease mechanisms on items, predictable state transitions, and conventions for file operations.

# Goal

- Define single-repo collaboration workflows (claim/lease, handoff, merge etiquette).
- Document conflict avoidance: file-level locks or logical leases, plus commit conventions.
- Specify minimal tooling/hooks to assist agents (e.g., pre-commit checks, status validation).

# Non-Goals

- Implement remote synchronization or multi-repo setups.

# Approach

1. Describe claim/lease lifecycle on Tasks/Features/UserStories.
2. Propose file operation rules (append-only worklog, no history rewrite; consistent timestamps/agents).
3. Define merge/review etiquette and compatibility with dashboards/index.
4. Identify lightweight hooks/scripts to enforce Ready gate and prevent in-progress collisions.

# Alternatives

- Ad-hoc coordination via chat alone (low auditability, higher conflict risk).

# Acceptance Criteria

- A documented single-repo workflow exists with claim/lease steps.
- Conflict avoidance practices are listed and testable.
- Hook/script suggestions are captured for enforcement.

# Risks / Dependencies

- Human discipline on leases can drift; require automation assists.
- Windows/macOS/Linux differences for file locks.

# Worklog

2026-01-07 20:07 [agent=copilot] Created to define workflows, claims/leases, and conflict avoidance in one repository.
