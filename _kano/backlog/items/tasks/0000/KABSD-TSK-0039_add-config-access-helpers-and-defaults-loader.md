---
id: KABSD-TSK-0039
type: Task
title: "Add config access helpers and defaults loader"
state: Done
priority: P2
parent: KABSD-FTR-0004
area: infra
iteration: null
tags: ["config", "helpers"]
created: 2026-01-05
updated: 2026-01-05
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

Config access is currently ad-hoc: callers read nested values manually and missing config files silently return `{}`. We need a consistent helper API and default merge behavior so scripts can rely on sane settings.

# Goal

Provide helper functions for nested config access and a defaults-aware loader without changing the existing `load_config()` semantics.

# Non-Goals

- Introducing agent.name in config.
- Adding heavy schema validation or external dependencies.

# Approach

- Add `default_config()` and `load_config_with_defaults()` in config_loader.py.
- Add `get_config_value(config, "a.b.c", default)` helper.
- Update audit_runner to use the defaults-aware loader + helper.

# Alternatives

Continue manual dict access in each script (rejected: inconsistent).

# Acceptance Criteria

- Defaults are centralized in config_loader.py and merged when config is missing.
- audit_runner uses the helper to read log settings.
- Existing `load_config()` behavior remains unchanged.

# Risks / Dependencies

- Callers expecting missing config to mean "unset" may need to opt out.

# Worklog

2026-01-05 01:25 [agent=codex] Created from template.
2026-01-05 01:39 [agent=codex] Starting config helper + defaults loader implementation.
2026-01-05 01:40 [agent=codex] Added plan for config helper + defaults loader work.
2026-01-05 01:40 [agent=codex] Added config defaults + helper accessors and updated audit_runner.
