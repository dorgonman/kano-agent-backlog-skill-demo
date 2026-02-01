---
area: config
created: '2026-02-01'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0352
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: Done
tags:
- config
- profiles
title: Move config profiles next to .kano/backlog_config.toml
type: Task
uid: 019c19e9-38c3-7790-838b-1090c1b319a5
updated: 2026-02-01
---

# Context

Profiles currently live under _kano/backlog/_shared/profiles, but we want them next to project config (.kano/backlog_config.toml) so they are clearly project-scoped and not part of canonical backlog data.

# Goal

Move named profile TOML files to a project-level folder (.kano/backlog_config/) and allow organizing profiles via subfolders (e.g. embedding/local-noop).

# Approach

1) Change profile root resolution to use ctx.project_root/.kano/backlog_config. 2) Allow profile names to include safe relative paths (no traversal). 3) Update CLI list/show to recurse. 4) Move existing profiles to the new folder and update docs/help text. 5) Verify with config show and a benchmark run.

# Acceptance Criteria

- ConfigLoader resolves --profile from .kano/backlog_config/<name>.toml and supports nested paths.
-  lists profiles recursively.
- Existing profiles are migrated to the new folder.
- Docs and help text reference the new location.
- A benchmark run using a profile works end-to-end.

# Risks / Dependencies

Risk: breaking change for existing profile names/paths. Mitigation: pre-alpha; update all in-repo references and provide clear error message with available profiles.

# Worklog

2026-02-01 23:54 [agent=opencode] Created item
2026-02-01 23:55 [agent=opencode] Ready: profile relocation plan defined.
2026-02-01 23:55 [agent=opencode] Start: move profiles to .kano/backlog_config and update resolution + CLI. [Ready gate validated]
2026-02-01 23:58 [agent=opencode] [model=unknown] Moved config profiles to project scope under .kano/backlog_config/ (supports subfolders). Updated profile resolution, CLI list/show recursion, docs, and migrated existing profiles to embedding/* and logging/*; verified benchmark run with --profile embedding/local-noop.
2026-02-01 23:58 [agent=opencode] Done: profiles now live in .kano/backlog_config/ with folder-friendly names; old _kano/backlog/_shared/profiles removed.
