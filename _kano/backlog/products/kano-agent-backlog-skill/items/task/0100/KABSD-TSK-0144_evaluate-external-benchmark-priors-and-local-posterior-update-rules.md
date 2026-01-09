---
id: KABSD-TSK-0144
uid: 019ba3c4-9194-7847-a817-540420ea141a
type: Task
title: "Evaluate external benchmark priors and local posterior update rules"
state: Proposed
priority: P3
parent: KABSD-USR-0027
area: dispatch
iteration: null
tags: ["dispatcher", "benchmark", "prior", "posterior", "governance"]
created: 2026-01-10
updated: 2026-01-10
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

External benchmarks can help when a new model/agent joins (a “prior”), but they can be misleading for a specific repo and workload.
We need explicit rules for how priors are used and how local outcomes update tiers (posterior).

# Goal

Define:
- what external priors (if any) are acceptable as inputs,
- how to initialize agent tiering from priors,
- how to update tiers based on local performance,
- how to record these changes audibly (decision log).

# Non-Goals

- Do not depend on any specific external benchmark provider.
- Do not auto-change tiers without a recorded rationale (no hidden heuristics).
- Do not require network access in the core workflow.

# Approach

- Define “prior input” format:
  - optional fields on agent registry (or config) that reference a benchmark score/source.
- Define posterior metrics mapping:
  - which local metrics dominate priors and when (e.g., after N completed items).
- Define update rules:
  - escalation triggers (too many failures/reworks),
  - de-escalation triggers (consistent success on risky items),
  - cooling-off windows to avoid oscillation.
- Define governance record:
  - every tier change writes a Worklog entry and links to an ADR/policy note.

# Alternatives

- Never use priors (slower onboarding for new agents).
- Always trust priors (wrong in repo-specific conditions).

# Acceptance Criteria

- A documented policy describing priors vs posterior updates.
- A proposed schema for storing priors and local performance summaries.
- At least 2 example scenarios showing tier updates over time.

# Risks / Dependencies

- If tiering oscillates, dispatch becomes unstable; needs hysteresis.
- Needs the outcome metrics definition (TSK-0143).

# Worklog

2026-01-10 01:18 [agent=codex] Planning task: document how external benchmarks act as priors and how local repo outcomes adjust tiers.
2026-01-10 02:06 [agent=codex] Added prior vs posterior policy goals, update rules, and governance record expectations.
