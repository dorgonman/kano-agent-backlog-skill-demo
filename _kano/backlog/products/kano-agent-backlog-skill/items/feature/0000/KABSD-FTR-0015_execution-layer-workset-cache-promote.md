---
id: KABSD-FTR-0015
uid: 019b96cb-fd5e-7656-9103-e2948c9212bb
type: Feature
title: "Execution Layer: Workset Cache + Promote"
state: Proposed
priority: P2
parent: KABSD-EPIC-0006
area: general
iteration: null
tags: ["roadmap", "execution", "workset"]
created: 2026-01-07
updated: 2026-01-09
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: [ADR-0011]
original_type: Feature
---

# Context

**Architecture**: See [ADR-0011](../../decisions/ADR-0011_workset-graphrag-context-graph-separation-of-responsibilities.md) for the complete specification of Workset responsibilities and how it relates to GraphRAG/Context Graph.

Workset provides per-agent/per-task execution memory and cache. Key properties:
- Materialized cache bundle (SQLite + optional filesystem)
- Derived and rebuildable from canonical files + repo-level index
- Ephemeral (TTL-based cleanup)
- Local (not source of truth; promotes back to canonical on important updates)

# Goal

# Non-Goals

# Approach

# Alternatives

# Acceptance Criteria

# Risks / Dependencies

# Worklog

2026-01-07 12:51 [agent=copilot] Seed minimal landing: workset init/refresh/promote; next defaults to plan checklist; gitignore _kano/.cache/**; cache discardable, canonical promotion required.

2026-01-07 13:02 [agent=copilot] Attach demo artifact for testing auto-refresh
- Artifact: [artifact_test.txt](../../../../../artifacts/KABSD-FTR-0015/artifact_test.txt)
2026-01-07 13:04 [agent=copilot] Workset initialized: _kano/backlog/sandboxes/.cache/019b96cb-fd5e-7656-9103-e2948c9212bb
