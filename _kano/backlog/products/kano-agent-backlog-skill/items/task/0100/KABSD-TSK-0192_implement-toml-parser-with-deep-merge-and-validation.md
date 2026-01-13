---
area: general
created: '2026-01-13'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0192
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
title: Implement TOML parser with deep-merge and validation
type: Task
uid: 019bb368-cefc-76c7-ae4c-6d937da64d16
updated: 2026-01-13
---

# Context

Schema v1.0 complete (synthesis/toml-config-schema-v1.md). Current config.py uses JSON with deep-merge; need TOML support with same merge semantics. Python 3.11+ has tomllib stdlib; <3.11 needs tomli package.

# Goal

Implement TOML loader alongside existing JSON loader with backward compat. Support 6-layer config resolution (global→repo→product→topic→workset→runtime) with recursive deep-merge matching current JSON behavior.

# Approach

1) Add tomli/tomllib conditional import 2) Create _read_toml_optional() parallel to _read_json_optional() 3) Update load_defaults/load_product_config/load_topic_overrides/load_workset_overrides to try .toml before .json 4) Keep existing _deep_merge() logic 5) Add deprecation warning when JSON loaded 6) Write tests for TOML loading and JSON→TOML precedence

# Acceptance Criteria

TOML files load correctly; TOML precedence over JSON at same layer; Deep merge works identically for TOML; Deprecation warning emitted for JSON; All existing tests pass; New tests cover TOML loading and mixed JSON/TOML scenarios

# Risks / Dependencies

Import compatibility for Python <3.11; Need to ensure TOML table semantics match JSON dict behavior in merge; Deprecation warnings might be noisy in logs

# Worklog

2026-01-13 02:12 [agent=copilot] Created item
2026-01-13 02:22 [agent=copilot-sonnet4] [model=unknown] State -> InProgress.
2026-01-13 02:34 [agent=copilot-sonnet4] [model=unknown] State -> Done.
