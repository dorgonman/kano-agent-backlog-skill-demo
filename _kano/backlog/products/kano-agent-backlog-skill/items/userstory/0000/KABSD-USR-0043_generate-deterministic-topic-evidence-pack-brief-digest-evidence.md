---
area: topic
created: '2026-01-19'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-USR-0043
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
- gather
- evidence-pack
- deterministic
- experimental
title: Generate deterministic topic evidence pack (brief/digest/evidence)
type: UserStory
uid: 019bd4b8-218c-7195-822b-2eb74356e7aa
updated: 2026-02-03
---

# Context

Topic currently helps focus, but deep decision work needs a deterministic evidence bundle. Evidence must include archived materials automatically for agents (scope=all).

# Goal

Provide a topic evidence pack pipeline that gathers materials across hot+cold and outputs deterministic brief/digest/evidence artifacts under the topic publish directory.

# Approach

1) Add / command with scope flag. 2) Determine inputs: linked workitems, keyword rules, optional id mentions, pinned docs, snippet refs. 3) Produce deterministic outputs: manifest.json + brief/digest/evidence markdown with stable ordering and build_id derived from content hashes (no timestamps). 4) Store raw collected artifacts under topic/evidence/ (or publish/evidence_pack/) with provenance metadata.

# Acceptance Criteria

- Running gather twice from the same source state produces identical outputs. - Pack includes archived workitems/topics when scope=all. - Snippet evidence includes provenance (path, line range, revision label) and is reproducible.

# Risks / Dependencies

Evidence packs can grow; enforce size limits and allow pruning policies.

# Worklog

2026-01-19 13:26 [agent=opencode] [model=unknown] Created item
2026-02-03 18:49 [agent=opencode] [model=openai/gpt-5.2] Parent updated: KABSD-FTR-0031 -> KABSD-EPIC-0010.
