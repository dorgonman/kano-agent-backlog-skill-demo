---
area: general
created: '2026-01-30'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KO-TSK-0003
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Proposed
tags: []
title: Test new project-level config system
type: Task
uid: 019c0c0c-7216-7600-b8a9-21b3123f770c
updated: '2026-01-30'
---

# Context

The kano-agent-backlog-skill is implementing a new project-level configuration system that allows managing multiple products from a single .kano/config.toml file. This needs to be tested with the kano-opencode-quickstart project.

# Goal

Validate the new project-level config system works correctly for managing the kano-opencode-quickstart backlog from the kano-agent-backlog-skill-demo project.

# Approach

1. Wait for KABSD-FTR-0063 implementation to complete 2. Create .kano/config.toml in kano-agent-backlog-skill-demo 3. Configure kano-opencode-quickstart as external product 4. Test CLI operations work correctly 5. Validate config resolution hierarchy

# Acceptance Criteria

1. Can manage kano-opencode-quickstart backlog from external project config 2. Config resolution works correctly 3. All CLI commands function properly 4. Backlog data remains intact during migration

# Risks / Dependencies

Risk of data loss during config migration. Need backup strategy.

# Worklog

2026-01-30 07:17 [agent=kiro] Created item