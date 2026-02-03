---
area: config
created: '2026-02-03'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0356
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
title: Make shorthand profiles prefer .kano/backlog_config
type: Task
uid: 019c216f-c313-7054-a154-2d7a3900b196
updated: 2026-02-03
---

# Context

Users expect shorthand profiles to prefer project-local custom profiles under .kano/backlog_config. Current behavior prefers repo-root path if present, which can override user profiles.

# Goal

Make shorthand --profile resolution prefer .kano/backlog_config/<ref>.toml. Explicit paths should still be honored. Only if no project-local profile exists should fallback consider repo-root path candidates.

# Approach

Update ConfigLoader.load_profile_overrides: if profile argument looks like a path (absolute or endswith .toml or startswith .), resolve that directly. Otherwise treat as shorthand and check .kano/backlog_config first; if not found, then attempt repo-root relative path candidates (<repo>/<ref>.toml). Update tests and SKILL.md.

# Acceptance Criteria

-  resolves to .kano/backlog_config even if a repo-root file exists.
- Explicit path inputs still resolve to that path.
- Tests cover precedence.
- Docs describe precedence rule.

# Risks / Dependencies

Risk: change from prior path-first behavior; mitigated by preserving explicit path support and documenting precedence.

# Worklog

2026-02-03 10:58 [agent=opencode] Created item
2026-02-03 10:58 [agent=opencode] Ready: shorthand precedence rule defined.
2026-02-03 10:58 [agent=opencode] Start: adjust shorthand resolution precedence. [Ready gate validated]
2026-02-03 11:11 [agent=opencode] [model=unknown] Adjusted --profile precedence: explicit paths honored; shorthand prefers .kano/backlog_config, then repo-root fallback. Removed duplicate profile resolver and added flatten mapping + tests; updated CLI help and SKILL.md.
2026-02-03 11:11 [agent=opencode] Done: shorthand profiles prefer .kano/backlog_config with fallback to repo-root.
