---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0040
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: antigravity
parent: null
priority: P2
state: Done
tags: []
title: Topic Spec Support
type: Feature
uid: 019bc31b-ae12-7578-ae9d-e074ab9e2fe2
updated: 2026-01-16
---

# Context

Current Topic mechanism is good for context grouping but lacks rigor for feature definition. .kiro/specs/ provides a strong pattern (requirements/design/tasks) that should be adopted.

# Goal

Integrate Spec (Requirements/Design/Tasks) into Topic structure as a first-class citizen.

# Approach

1. Extend Topic structure to include spec/ folder. 2. Update Topic CLI to manage specs. 3. Update Distill to include spec linkage in brief.md.

# Acceptance Criteria

1. kano topic create supports scaffolding spec/. 2. Spec files follow strict templates. 3. brief.md links to spec documents.

# Risks / Dependencies

Complexity of managing more files.

# Worklog

2026-01-16 03:22 [agent=antigravity] [model=unknown] Created item
2026-01-16 03:47 [agent=antigravity] [model=unknown] State -> InProgress.
2026-01-16 07:05 [agent=antigravity] [model=unknown] State -> Done.
