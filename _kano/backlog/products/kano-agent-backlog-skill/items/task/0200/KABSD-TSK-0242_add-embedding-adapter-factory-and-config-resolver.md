---
area: infra
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0242
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: KABSD-USR-0031
priority: P1
state: InProgress
tags:
- embedding
- config
- factory
title: Add embedding adapter factory and config resolver
type: Task
uid: 019bcbf5-44f9-725b-8b60-a858aa48e807
updated: 2026-01-19
---

# Context

We need a consistent way to select an embedding provider based on layered TOML config (defaults -> product -> topic/workset) without code changes.

# Goal

Resolve an embedding adapter instance from effective config and make it usable by pipelines and benchmarks.

# Approach

Define config keys under [embedding] (adapter, model, dims, max_tokens override) and implement a resolver/factory that returns a concrete adapter instance. Add validation that detects incompatible settings early (dims, max tokens, missing deps).

# Acceptance Criteria

- Factory can resolve at least noop and one real adapter (or stub) by name. - Config defaults are documented and topic overrides are supported. - Unit tests cover config parsing and unknown adapter errors.

# Risks / Dependencies

Config can become a dumping ground; keep the schema minimal and versioned. Optional provider deps require lazy import to avoid forcing installs.

# Worklog

2026-01-17 20:36 [agent=copilot] [model=unknown] Created item
2026-01-19 03:00 [agent=opencode] [model=unknown] Start: implement embedding adapter factory/config resolver.
