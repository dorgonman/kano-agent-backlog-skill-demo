---
id: KABSD-TSK-0048
type: Task
title: "Add config keys for DB index backend selection"
state: Done
priority: P3
parent: KABSD-USR-0014
area: config
iteration: null
tags: ["config", "db", "index"]
created: 2026-01-05
updated: 2026-01-05
owner: codex
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

We need a stable config surface for enabling/disabling DB index and selecting backend.

# Goal

Add config keys and validation rules for DB index settings.

# Non-Goals

Do not implement the DB indexer itself in this task.


# Approach

- Extend `_kano/backlog/_config/config.json` schema (e.g. `index.enabled`, `index.backend`, `index.path`).
- Update `config_loader.validate_config()` accordingly.
- Document defaults and overrides.

# Alternatives

- Hardcode a single backend (not configurable).


# Acceptance Criteria

- `validate_config.py` passes for default config and for an enabled index config.
- Docs explain the meaning and safety (DB is rebuildable).

# Risks / Dependencies

- Config churn: keys may evolve as the indexer design solidifies.


# Worklog

2026-01-05 08:31 [agent=codex] Created from template.
2026-01-05 08:42 [agent=codex] State -> Ready. Ready gate validated for adding index config keys/validation.
2026-01-05 08:42 [agent=codex] State -> InProgress. Implementing index.* config defaults + validation (DB is optional, file-first default).
2026-01-05 08:45 [agent=codex] State -> Done. Added index.* defaults (disabled) to config, extended config validation, and documented file-first default in schema/process guidance.
