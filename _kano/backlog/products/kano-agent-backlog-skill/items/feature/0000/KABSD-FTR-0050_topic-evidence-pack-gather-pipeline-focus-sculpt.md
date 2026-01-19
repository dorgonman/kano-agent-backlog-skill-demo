---
area: backlog
created: '2026-01-19'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0050
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-EPIC-0010
priority: P1
state: Proposed
tags:
- topic
- evidence-pack
- gather
- experimental
title: Topic evidence pack gather pipeline (focus/sculpt)
type: Feature
uid: 019bd4b8-08f8-760b-9504-204ba39d6297
updated: '2026-01-19'
---

# Context

Topic is the primary human focus surface. For deep decision work (system sculpting), humans need a deterministic, repeatable evidence bundle that aggregates relevant materials across hot+cold without manual digging.

# Goal

Add an experimental topic evidence-pack gather pipeline that produces brief/digest/evidence outputs deterministically from the same source state, and can include archived materials when scope=all.

# Approach

1) Add topic gather/evidence-pack command(s) that build a workset of sources (linked workitems, ADRs, pinned docs, snippet captures). 2) Produce deterministic artifacts under the topic publish/ directory: manifest.json + brief/digest/evidence markdown. 3) Ensure stable ordering, stable identifiers, and avoid time-based nondeterminism (use build_id from content hashes). 4) Integrate scope flag (hot|cold|all) and default to scope=all for agent gather when experimental enabled.

# Acceptance Criteria

- Feature is disabled unless experimental config enabled. -  (or ) produces deterministic artifacts with stable ordering and build_id. - Evidence pack can include archived workitems/topics when scope=all. - Snippet evidence includes provenance (path + line range + revision label) and is reproducible.

# Risks / Dependencies

Evidence packs can grow; need retention/size limits. Determinism requires eliminating timestamps and enforcing stable sorting. References across archived materials must remain resolvable.

# Worklog

2026-01-19 13:26 [agent=opencode] [model=unknown] Created item