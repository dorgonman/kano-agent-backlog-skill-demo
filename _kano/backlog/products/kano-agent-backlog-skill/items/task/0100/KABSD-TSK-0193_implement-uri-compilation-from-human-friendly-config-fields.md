---
area: general
created: '2026-01-13'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0193
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
title: Implement URI compilation from human-friendly config fields
type: Task
uid: 019bb368-d2d0-736d-b38c-4a0f2d43cdaf
updated: 2026-01-19
---

# Context

Schema v1.0 defines URI compilation for backends.* blocks (filesystem/jira/azure-devops/http/mcp). TSK-0192 added TOML loading + deep-merge; now we need to compile human-friendly backend parameters into canonical URIs for downstream use. Must remain local-first: compile strings only, do not contact networks, and do not implement any server runtime.

# Goal

Implement a pure URI compiler that takes backend config blocks and produces canonical backend URIs (and normalized fields) per schema, with validation and clear errors.

# Approach

1) Add core compiler function (e.g., compile_backend_uri(name, backend_dict)) in kano_backlog_core 2) Support backend types: filesystem, jira, azure-devops, http, mcp (string compilation only) 3) Validate required fields and reject secrets-in-config (require env: refs) 4) Add unit tests covering happy paths + invalid configs

# Acceptance Criteria

Given backend blocks, compiler returns expected URIs per schema; missing required fields raise ConfigError; secrets in config are rejected; no network calls are made; unit tests cover each backend type and error cases; existing config overlay tests still pass

# Risks / Dependencies

Ambiguity in URI formats (e.g., azure host/path encoding); future expansion (mcp) must stay spec-only and local-first


## Decisions

- Use env-var only auth (no secrets in config) and compile backend URIs from config fields. (source: _kano/backlog/topics/config-refactor-toml-layers/synthesis/toml-config-schema-v1.md)
# Worklog

2026-01-13 02:12 [agent=copilot] Created item
2026-01-13 08:02 [agent=copilot-sonnet4] [model=unknown] State -> InProgress.
2026-01-13 08:03 [agent=copilot-sonnet4] [model=unknown] State -> Done.
2026-01-19 12:15 [agent=copilot] [model=unknown] Decision write-back added: Use env-var only auth (no secrets in config) and compile backend URIs from config fields. (source: _kano/backlog/topics/config-refactor-toml-layers/synthesis/toml-config-schema-v1.md)
