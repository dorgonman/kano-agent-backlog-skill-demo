---
id: KABSD-TSK-0041
type: Task
title: "Add lightweight config validation"
state: Done
priority: P2
parent: KABSD-FTR-0004
area: infra
iteration: null
tags: ["config", "validation"]
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

Config values are not validated, so incorrect types or unexpected values can silently break logging or process selection.

# Goal

Provide a lightweight validation script and helper that emits clear errors without adding heavy dependencies.

# Non-Goals

- Full JSON Schema enforcement.
- Auto-fixing invalid config values.

# Approach

- Add validate_config() helper in config_loader.py.
- Provide a CLI script to validate the config file on demand.

# Alternatives

Rely on runtime failures when config values are incorrect.

# Acceptance Criteria

- Validation reports type/allowed-value errors with clear messages.
- CLI exits non-zero on invalid config or missing file.

# Risks / Dependencies

- Keeping validation rules aligned with defaults requires discipline.

# Worklog

2026-01-05 01:25 [agent=codex] Created from template.
2026-01-05 01:43 [agent=codex] Added plan for lightweight config validation.
2026-01-05 01:44 [agent=codex] Added config validation helper and CLI script.
