---
area: general
created: '2026-01-13'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0194
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
title: 'Add CLI commands: config show and config validate'
type: Task
uid: 019bb368-d5b8-754c-a0ed-2db82c029293
updated: 2026-01-19
---

# Context

After TOML loading (TSK-0192) and URI compilation (TSK-0193), users need CLI visibility and validation. Provide local-first commands to inspect the effective config across layers and validate config files without running any server.

# Goal

Add CLI commands to show effective config and validate layered config (TOML preferred, JSON supported with deprecation warning).

# Approach

1) Add a new Typer command group (e.g., ) under kano-backlog CLI 2) Implement  (prints effective merged config as JSON or TOML-like pretty output) 3) Implement  (parses each layer, compiles URIs, checks validation rules; nonzero exit code on error) 4) Add tests with Typer CliRunner

# Acceptance Criteria

 prints effective config;  returns exit code 0 on valid config and 1 on invalid config; errors are actionable; no network calls; tests added and pass

# Risks / Dependencies

Need to avoid leaking secrets; output format should be stable enough for scripting; ensure CLI respects product/topic/workset selection flags


## Decisions

- Show/validate CLI should respect layer precedence and TOML-over-JSON at the same layer with deprecation warnings. (source: _kano/backlog/topics/config-refactor-toml-layers/synthesis/toml-config-schema-v1.md)
# Worklog

2026-01-13 02:12 [agent=copilot] Created item
2026-01-13 08:33 [agent=copilot-sonnet4] [model=unknown] State -> InProgress.
2026-01-13 23:45 [agent=antigravity] State -> Done. Verified config show/validate commands exist in config_cmd.py.
2026-01-19 12:15 [agent=copilot] [model=unknown] Decision write-back added: Show/validate CLI should respect layer precedence and TOML-over-JSON at the same layer with deprecation warnings. (source: _kano/backlog/topics/config-refactor-toml-layers/synthesis/toml-config-schema-v1.md)
