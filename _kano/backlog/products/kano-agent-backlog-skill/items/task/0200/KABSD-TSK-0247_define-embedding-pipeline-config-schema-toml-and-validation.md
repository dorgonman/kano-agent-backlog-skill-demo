---
area: infra
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0247
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-USR-0033
priority: P0
state: Proposed
tags:
- config
- schema
- validation
title: Define embedding pipeline config schema (TOML) and validation
type: Task
uid: 019bcbf6-4882-7699-84bd-3dbac6516bc8
updated: '2026-01-17'
---

# Context

Config layering already exists, but pipeline-specific keys for chunking/tokenizer/embedding/vector are not standardized. Without a schema, evaluations are error-prone and non-reproducible.

# Goal

Define a minimal, versionable config schema for the embedding pipeline and validate it at load time.

# Approach

Specify sections: chunking (target_tokens, max_tokens, overlap_tokens, version), tokenizer (adapter, model_name, max_tokens override), embedding (adapter, model_name, dims), vector (backend, metric, path). Implement validation with clear errors and a way to print the effective config used for a run.

# Acceptance Criteria

- Schema is documented in product config docs and enforced in code. - Invalid combinations fail fast with actionable error messages. - Topic config overrides can change pipeline components without editing product defaults.

# Risks / Dependencies

Overly rigid schema can slow experimentation; keep it minimal and allow provider-specific nested config under a reserved key (e.g., embedding.provider_options).

# Worklog

2026-01-17 20:37 [agent=copilot] [model=unknown] Created item