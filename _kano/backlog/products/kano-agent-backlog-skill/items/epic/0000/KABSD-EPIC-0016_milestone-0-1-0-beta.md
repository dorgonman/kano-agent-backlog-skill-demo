---
area: release
created: '2026-02-07'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-EPIC-0016
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: copilot
parent: null
priority: P1
state: InProgress
tags:
- milestone
- beta
- 0.1.0
title: Milestone 0.1.0 Beta
type: Epic
uid: 019c377b-4da9-77fc-bdb6-973399a13bcb
updated: 2026-02-07
---

# Context

We plan to promote this project from pre-alpha milestone releases (0.0.x) to a 0.1.0 beta milestone. Current release gating shows Phase2 FAIL for 0.0.3 due to topic-merge-dry, and several areas are still marked experimental or in flux (schema, CLI surface, config). Beta requires a tighter definition of supported workflows, stability expectations, and a passing release gate.

# Goal

Define and ship the 0.1.0 beta milestone: (1) release checks pass end-to-end, (2) core file formats/config/CLI contracts are stable enough for beta users, (3) documentation matches behavior, and (4) we have an explicit beta scope with acceptance criteria tracked in child items.

# Approach

1) Codify beta Definition of Done (DoD) and scope boundaries. 2) Close the current release gate failure(s) and harden smoke checks. 3) Stabilize the minimal contract surface (schema/layout/config/CLI) and document it. 4) Add targeted tests and docs to prevent regressions. 5) Run release checks for 0.1.0 and publish the reports under a release topic.

# Acceptance Criteria

- A milestone Epic exists for 0.1.0 beta with child Features/Tasks/Bugs covering all required work. - Release checks (phase1 and phase2) pass for 0.1.0 and reports are committed under _kano/backlog/topics/release-0-1-0/publish/. - Core workflow commands (create item, set-ready, update-state, view refresh, topic create/distill/merge/split/snapshot) run successfully in a clean sandbox. - Documentation clearly states what is stable in beta vs experimental, including migration/upgrade notes if any breaking changes occur. - Beta scope explicitly excludes any server runtime per local-first-first clause.

# Risks / Dependencies

If we keep changing schema/CLI while labeling beta, users will experience churn and lose trust. Release gates currently rely on smoke topics and sandboxes; naming collisions and stale state can cause false failures. Experimental features (SQLite indexing, embeddings) can be unstable; beta should either gate them behind explicit flags or define them as out-of-scope.

# Worklog

2026-02-07 17:42 [agent=copilot] Created item
2026-02-07 17:42 [agent=copilot] Updated Ready fields: Context, Goal, Approach, Acceptance Criteria, Risks
2026-02-07 17:47 [agent=copilot] State -> Planned.
2026-02-07 18:28 [agent=copilot] Auto parent sync: child KABSD-TSK-0367 -> InProgress; parent -> InProgress.
2026-02-07 19:16 [agent=copilot] State -> InProgress. [Ready gate validated]
