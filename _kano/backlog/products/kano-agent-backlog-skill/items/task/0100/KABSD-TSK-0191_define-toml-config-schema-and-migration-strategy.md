---
area: general
created: '2026-01-13'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0191
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0024
priority: P2
state: Done
tags: []
title: Define TOML config schema and migration strategy
type: Task
uid: 019bb367-1f84-7681-85be-af23e82027ed
updated: 2026-01-13
---

# Context

KABSD-FTR-0024 requires TOML-based config with global/repo/runtime layers and URI compilation. Current impl uses JSON with 4-layer merge (defaults→product→topic→workset). Need schema design before implementation.

# Goal

Define complete TOML schema structure covering all current JSON config fields plus new requirements (URI compilation targets, multi-repo registry). Design migration path from JSON to TOML.

# Approach

1) Map existing JSON structure to TOML sections 2) Add URI compilation fields (e.g., backend.type+backend.path → backend.uri) 3) Define global/repo/runtime precedence rules 4) Design backward-compat strategy (support both during transition) 5) Document schema with examples

# Acceptance Criteria

Schema doc covers all existing config fields; URI compilation rules defined; Migration strategy documented with rollback plan; Schema validated against current use cases

# Risks / Dependencies

Breaking changes if migration not carefully planned; Need to ensure deep-merge still works with TOML sections

# Worklog

2026-01-13 02:10 [agent=copilot] Created item
2026-01-13 02:14 [agent=copilot] [model=unknown] Starting schema definition work in topic config-refactor-toml-layers
2026-01-13 02:15 [agent=copilot] [model=unknown] Schema v1.0 complete: defined TOML structure, URI compilation rules, migration strategy; resolved all open questions; created examples in topic synthesis/
