---
area: general
created: '2026-01-31'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0345
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
title: Remove deprecated vector.path from configuration
type: Task
uid: 019c1480-c10f-708c-8d14-d41ef28cb165
updated: 2026-01-31
---

# Context

The shared.vector.path configuration option is no longer used. All code now uses ConfigLoader.get_chunks_cache_root() which only reads cache.root, not vector.path. The path field is a leftover from the old design where each vector had its own path. Current config has path = '' which serves no purpose.

# Goal

Remove the deprecated vector.path field from all configuration files to simplify the config and avoid confusion.

# Approach

1. Remove path field from shared.vector section in .kano/backlog_config.toml. 2. Remove path field and related comments from .kano/debug/backlog_config.toml. 3. Update system defaults in config.py to remove vector.path. 4. Test that all products still load correctly. 5. Verify vector operations still work.

# Acceptance Criteria

1. No path field in shared.vector sections. 2. All products load without errors. 3. Vector operations work unchanged. 4. Documentation reflects removal.

# Risks / Dependencies

None - field is already unused in code.

# Worklog

2026-01-31 22:41 [agent=opencode] Created item
2026-01-31 22:42 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-01-31 22:42 [agent=opencode] Workset initialized: D:\_work\_Kano\kano-agent-backlog-skill-demo\_kano\backlog\.cache\worksets\items\KABSD-TSK-0345
2026-01-31 22:43 [agent=opencode] State -> Done.
