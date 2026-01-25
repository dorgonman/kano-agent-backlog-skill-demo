---
area: infrastructure
created: '2026-01-25'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0297
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0058
priority: P1
state: Proposed
tags:
- search
- index
- cache
title: Define corpus boundaries and cache freshness policy
type: Task
uid: 019bf587-86af-73f5-9e30-a1a64f63ed4e
updated: '2026-01-25'
---

# Context

We are expanding search beyond product items. We need explicit corpus boundaries (backlog vs repo), DB locations, ID/path conventions, and a cache freshness policy that preserves speed.

# Goal

Record the design decisions for multi-corpus indexing (which corpuses exist, which DBs exist, how chunk IDs are defined, and how freshness is detected).

# Approach

Document the corpus model (backlog corpus = items + ADRs + topics; repo corpus = docs + code). Specify DB paths, default include/exclude patterns, and the freshness heuristic (mtime-based) with a --force rebuild escape hatch. Write the decision to a topic publish note and reference it from the implementation tasks.

# Acceptance Criteria

A written decision exists and is referenced by the implementation tasks. Default corpus/DB paths and include/exclude rules are specified. Freshness policy is documented (mtime heuristic + force rebuild).

# Risks / Dependencies

mtime-based freshness can produce false fresh/false stale results; mitigate with explicit --force rebuild and clear documentation. Scope creep: keep initial corpuses to two (backlog vs repo).

# Worklog

2026-01-25 22:20 [agent=opencode] Created item
2026-01-25 22:23 [agent=opencode] [model=unknown] Decision: cache freshness uses an mtime-based heuristic (fast) instead of strong manifest/content hashing. Escape hatch: --force rebuild when results look stale.