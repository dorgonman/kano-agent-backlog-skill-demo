---
area: core
created: '2026-01-18'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-BUG-0007
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: null
priority: P1
state: Done
tags: []
title: 'Core: accept Planned as a valid ItemState'
type: Bug
uid: 019bce9a-783e-7268-af99-02135d7042ea
updated: 2026-01-18
---

# Context

Some existing backlog items (e.g., Features) use state=Planned, which is part of the documented state vocabulary (Proposed/Planned/Ready/InProgress/Blocked/Done/Dropped). The current kano_backlog_core.models.ItemState enum does not include Planned, causing CanonicalStore parsing to fail and blocking operations like 'workitem update-state' when parent syncing touches an item in Planned.

# Goal

Make Planned a first-class supported ItemState so canonical parsing succeeds and CLI/ops workflows (including update-state with parent sync) do not crash.

# Approach

Add ItemState.PLANNED = 'Planned' to kano_backlog_core.models. Update any state normalization/mapping (CLI update-state) and state ranking helpers to include Planned. Add a regression test that validates BacklogItem accepts 'Planned'.

# Acceptance Criteria

1) CanonicalStore can load items with state=Planned without parse errors. 2) 'kano-backlog workitem update-state <task> --state Ready' succeeds even when the parent Feature is in Planned. 3) Tests cover Planned parsing.

# Risks / Dependencies

Minimal: expanding an enum may affect any code that assumes a closed set; mitigate by keeping semantics consistent with existing views mapping (Planned groups with New).

# Worklog

2026-01-18 08:56 [agent=codex] [model=unknown] Created item
2026-01-18 08:56 [agent=codex] [model=unknown] Fix ItemState enum/mappings to include Planned and unblock update-state parent sync.
2026-01-18 09:17 [agent=codex] [model=unknown] Added Planned to ItemState enum and CLI mapping; parent sync no longer fails when parent is Planned.
