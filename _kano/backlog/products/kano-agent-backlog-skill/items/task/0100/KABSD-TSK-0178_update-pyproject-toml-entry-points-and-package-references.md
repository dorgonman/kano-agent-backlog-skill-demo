---
area: cli
created: '2026-01-12'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0178
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0034
priority: P2
state: Done
tags:
- refactor
title: Update pyproject.toml entry points and package references
type: Task
uid: 019bae59-043c-7182-9a84-dd43fbf57515
updated: 2026-01-12
---

# Context

pyproject.toml references kano_cli as package name and kano as console_scripts entrypoint; must update to skill-scoped names.

# Goal

Update pyproject.toml to use kano-backlog as entrypoint and kano_backlog_cli as package reference.

# Approach

Edit pyproject.toml: console_scripts kano-backlog = kano_backlog_cli.cli:main; update package name in tool.setuptools.packages.find; verify no other kano_cli references.

# Acceptance Criteria

pyproject.toml console_scripts defines kano-backlog; package references use kano_backlog_cli; pip install -e . produces kano-backlog command.

# Risks / Dependencies

Entrypoint name change breaks existing user scripts; mitigated by deprecated wrapper (TSK-0179).

# Worklog

2026-01-12 02:37 [agent=copilot] Created item
2026-01-12 03:24 [agent=copilot] Started: updating pyproject.toml for skill-scoped naming.
2026-01-12 03:24 [agent=copilot] Completed: updated pyproject.toml console_scripts from 'kano = kano_cli.cli:main' to 'kano-backlog = kano_backlog_cli.cli:main'.
