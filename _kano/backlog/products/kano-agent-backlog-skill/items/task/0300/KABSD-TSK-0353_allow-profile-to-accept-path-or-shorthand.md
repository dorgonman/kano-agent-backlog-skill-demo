---
area: config
created: '2026-02-02'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0353
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
title: Allow --profile to accept path or shorthand
type: Task
uid: 019c1a2b-9669-74b3-9d8b-2b19df72f6c1
updated: 2026-02-02
---

# Context

Current --profile accepts only a profile ref that resolves under .kano/backlog_config/. Users expect --profile to accept either an absolute path or a repo-root relative path.

# Goal

Support dual-mode --profile: accept (1) absolute or repo-root relative .toml path, and (2) shorthand profile ref (with optional subfolders) for users familiar with docs.

# Approach

Update ConfigLoader.load_profile_overrides to detect path-mode (absolute path, repo-relative path, or values ending with .toml) vs shorthand-mode. Shorthand continues to resolve under .kano/backlog_config/<ref>.toml. Path-mode resolves relative paths against project_root, prevents traversal outside project_root, and loads the specified TOML file.

# Acceptance Criteria

- --profile accepts .kano/backlog_config/usage.toml (repo-relative) and resolves correctly.
- --profile accepts an absolute path to a .toml file.
- Existing shorthand refs (e.g. embedding/local-noop) continue to work.
- Help text/docs show both forms.
- pyright is clean for touched files.

# Risks / Dependencies

Risk: ambiguity for strings containing slashes. Mitigation: only treat values as path-mode when they look like paths (absolute, startswith '.', or endswith .toml); otherwise treat as shorthand.

# Worklog

2026-02-02 01:06 [agent=opencode] Created item
2026-02-02 01:07 [agent=opencode] Ready: dual-mode --profile plan defined.
2026-02-02 01:07 [agent=opencode] Start: implement path-mode profile resolution + update docs/help. [Ready gate validated]
2026-02-02 01:09 [agent=opencode] [model=unknown] Implemented dual-mode --profile: accepts path (.kano/backlog_config/...toml or absolute) or shorthand (embedding/local-noop). Updated CLI help and SKILL.md; verified benchmark run with path mode.
2026-02-02 01:09 [agent=opencode] Done: --profile supports path mode and shorthand; docs updated.
