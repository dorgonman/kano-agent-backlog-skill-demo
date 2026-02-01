---
area: general
created: '2026-01-31'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0346
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: Done
tags: []
title: Remove deprecated shared.index configuration section
type: Task
uid: 019c1488-cdcc-7591-a9d1-c7f3ed11e09f
updated: 2026-01-31
---

# Context

The shared.index configuration section is completely unused. No code reads index.enabled, index.backend, or index.mode. This was part of early SQLite indexing that has been replaced by the vector/embedding system. Current config has [shared.index] enabled=true backend='sqlite' which serves no purpose.

# Goal

Remove the deprecated shared.index section from all configuration files to simplify config.

# Approach

1. Remove [shared.index] section from .kano/backlog_config.toml. 2. Remove index section from .kano/debug/backlog_config.toml. 3. Remove index from system defaults in config.py. 4. Test that all products load correctly.

# Acceptance Criteria

1. No index section in any config files. 2. All products load without errors. 3. All functionality works unchanged.

# Risks / Dependencies

None - section is completely unused.

# Worklog

2026-01-31 22:50 [agent=opencode] Created item
2026-01-31 22:50 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-01-31 22:50 [agent=opencode] Workset initialized: D:\_work\_Kano\kano-agent-backlog-skill-demo\_kano\backlog\.cache\worksets\items\KABSD-TSK-0346
2026-01-31 22:51 [agent=opencode] State -> Done.
