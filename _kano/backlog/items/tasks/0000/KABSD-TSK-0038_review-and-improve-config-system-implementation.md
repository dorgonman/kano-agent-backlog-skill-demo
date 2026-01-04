---
id: KABSD-TSK-0038
type: Task
title: "Review and improve config system implementation"
state: Done
priority: P2
parent: KABSD-FTR-0004
area: infra
iteration: null
tags: ["config", "review", "improvement"]
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

Config system gaps were found (missing defaults, helper APIs, validation, and documentation). We need a small set of follow-up tasks to make config usage predictable without adding heavy dependencies.

# Goal

Define a clear implementation path for config improvements (excluding agent.name), and split work into actionable tasks under the config feature.

# Non-Goals

- Introducing agent.name in config.
- Adding a full JSON schema dependency or external validator.

# Approach

- Add helper accessors + default loading path for config.
- Document defaults and env override precedence.
- Add lightweight validation with clear error messages (optional, script-only).

# Alternatives

Continue with ad-hoc config access and scattered defaults (rejected: error-prone).

# Acceptance Criteria

- Follow-up tasks created and linked.
- Config helper and docs work can proceed without requiring agent.name.

# Risks / Dependencies

- Changing config behavior may affect existing scripts; keep defaults compatible.

# Findings

## 1. Missing agent.name Configuration Support

**Issue**: SKILL.md documents that agents should read identity from config.json -> agent.name, but the actual config.json file does not include an agent section, and no code exists to read it.

**Location**: skills/kano-agent-backlog-skill/SKILL.md lines 44-46, _kano/backlog/_config/config.json

**Recommendation**: Add agent.name field to config.json schema and implement helper function in config_loader.py.

## 2. Config Loading Returns Empty Dict on Missing File

**Issue**: load_config() returns {} when config file does not exist, leading to silent failures.

**Location**: skills/kano-agent-backlog-skill/scripts/common/config_loader.py lines 52-53

**Recommendation**: Consider returning default config dict or add get_config_with_defaults() function.

## 3. No Config Schema Validation

**Issue**: No validation that required config keys exist or that values have correct types.

**Location**: skills/kano-agent-backlog-skill/scripts/common/config_loader.py lines 46-60

**Recommendation**: Add optional schema validation with clear error messages.

## 4. Inconsistent Config Access Patterns

**Issue**: No standardized helper functions for accessing nested config values.

**Location**: skills/kano-agent-backlog-skill/scripts/logging/audit_runner.py lines 42-47

**Recommendation**: Add helper functions like get_config_value(config, path, default) for nested access.

## 5. No Default Values Documentation

**Issue**: Default values are scattered across code with no single source of truth.

**Recommendation**: Document default config structure in schema file or comments.

## 6-10. Additional Findings

See full details in task file. Includes: config path resolution, missing config usage, no template file, env var documentation, and config reload behavior.

# Worklog

2026-01-05 01:10 [agent=cursor] Created to review config system code and document findings.

# Links

- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0039_add-config-access-helpers-and-defaults-loader|KABSD-TSK-0039 Add config access helpers and defaults loader]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0040_document-config-defaults-and-env-override-rules|KABSD-TSK-0040 Document config defaults and env override rules]]
- Task: [[_kano/backlog/items/tasks/0000/KABSD-TSK-0041_add-lightweight-config-validation|KABSD-TSK-0041 Add lightweight config validation]]
2026-01-05 01:26 [agent=codex] Split config improvements into follow-up tasks (0039-0041); agent.name excluded.
2026-01-05 01:26 [agent=codex] State -> Ready.
2026-01-05 01:27 [agent=codex] Review complete; follow-up tasks 0039-0041 created (agent.name excluded).
