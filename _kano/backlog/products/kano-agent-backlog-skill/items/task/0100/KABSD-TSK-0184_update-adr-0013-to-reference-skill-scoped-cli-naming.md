---
area: docs
created: '2026-01-12'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0184
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0036
priority: P2
state: Done
tags:
- adr
- architecture
title: Update ADR-0013 to reference skill-scoped CLI naming
type: Task
uid: 019bae59-883e-7517-a168-5d47f931c52e
updated: 2026-01-12
---

# Context

ADR-0013 documents modular CLI design but doesn't reference the newer ADR-0015 skill-scoped naming convention. Need to add cross-reference.

# Goal

Update ADR-0013 to mention ADR-0015 and explain that kano-backlog follows skill-scoped naming while 'kano' is reserved for umbrella CLI.

# Approach

Add a new section or update Consequences in ADR-0013 to reference ADR-0015.

# Acceptance Criteria

ADR-0013 contains explicit reference to ADR-0015; explains skill-scoped naming strategy.

# Risks / Dependencies

None (documentation only).

# Worklog

2026-01-12 02:37 [agent=copilot] Created item
2026-01-12 07:00 [agent=copilot] Started: adding ADR-0015 reference to ADR-0013.
2026-01-12 07:00 [agent=copilot] Done: updated ADR-0013 Consequences (#2, #5) and Related sections to reference ADR-0015 skill-scoped naming convention.
