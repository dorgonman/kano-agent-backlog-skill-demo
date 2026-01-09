---
id: KABSD-FTR-0024
uid: 019ba071-1062-79ac-aacb-63abf3e61a73
type: Feature
title: "Global config layers and URI compilation"
state: Proposed
priority: P1
parent: KABSD-EPIC-0004
area: config
iteration: null
tags: ["config", "global", "uri", "registry"]
created: 2026-01-09
updated: 2026-01-09
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

- Multi-repo and multi-backend use cases need shared config without per-repo duplication.
- Humans want simple fields; the system needs normalized URIs internally.

# Goal

- Implement layered config (runtime > repo > global).
- Compile human-friendly fields into canonical URIs for internal use.

# Non-Goals

- No server/MCP or Jira/Azure sync implementation.
- No secrets vault; credentials remain in env vars.

# Approach

- Define TOML schema and precedence rules.
- Build parser/merger/compiler library used by CLI and scripts.
- Provide CLI: config show + config validate.
- Support optional multi-repo registry entries for cross-repo search.

# Alternatives

- Keep repo-only config (too repetitive).
- Use env-only configuration (opaque and harder to debug).

# Acceptance Criteria

- Global config defaults can be overridden per repo and at runtime.
- Local paths work with zero advanced config.
- Remote urls require explicit auth config (or explicit unsafe flag).
- config show prints compiled URIs for debugging.

# Risks / Dependencies

- Precedence bugs can cause hard-to-debug mismatches.
- Secrets must never be stored in repo files.

# Worklog

2026-01-09 09:48 [agent=codex] Created to plan global/repo/runtime config layers and URI compilation.
2026-01-09 09:49 [agent=codex] Drafted planning scope, config layers, and acceptance criteria.
