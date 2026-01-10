---
id: KABSD-BUG-0002
uid: 019ba6e7-e67e-769b-b73e-512275920d05
type: Bug
title: "Add dependency links between FTR-0013 and FTR-0015"
state: Done
priority: P2
parent: KABSD-FTR-0015
area: general
iteration: null
tags: ["workset", "links", "metadata"]
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

In the Workset-related roadmap, `KABSD-FTR-0015` (Execution Layer) states a dependency in its Risks/Dependencies:

> "Depends on FTR-0013 for working index_db infrastructure"

However, the dependency is not represented in frontmatter links:

- `KABSD-FTR-0015` is missing `links.blocked_by`
- `KABSD-FTR-0013` is missing `links.blocks`

This causes:
1. incorrect dashboards/trees (Dataview and generated views)
2. missing dependency visibility during planning
3. inconsistent status summaries

# Goal

Make the dependency explicit by linking `KABSD-FTR-0013` and `KABSD-FTR-0015` in frontmatter.

# Non-Goals

- Do not change the directory layout or the Workset implementation.
- Do not redesign the dependency model (just use existing link fields).

# Approach

1. Update `KABSD-FTR-0015` frontmatter: set `links.blocked_by` to `["KABSD-FTR-0013"]`.
2. Update `KABSD-FTR-0013` frontmatter: set `links.blocks` to `["KABSD-FTR-0015"]`.
3. Update the `updated` timestamp.
4. Append a Worklog entry describing the change.

# Alternatives

1. **Rely on plain text only**: simple, but not machine-derivable.
2. **Use `relates` instead of `blocked_by`**: loses the directionality of the dependency.

# Acceptance Criteria

- [x] `KABSD-FTR-0015.links.blocked_by = ["KABSD-FTR-0013"]`
- [x] `KABSD-FTR-0013.links.blocks = ["KABSD-FTR-0015"]`
- [x] `updated` is refreshed to reflect the edit
- [x] Worklog is appended

# Risks / Dependencies

1. **Risk**: incorrect link types could pollute dashboards.
2. **Dependency**: requires both items to exist and be indexed.

# Worklog

2026-01-10 15:56 [agent=copilot] Created from template.
2026-01-10 16:00 [agent=copilot] Populated Ready gate content based on Workset review findings.
2026-01-10 16:28 [agent=copilot] Updated FTR-0013/FTR-0015 links metadata to reflect true dependency chain. Bug resolved.
