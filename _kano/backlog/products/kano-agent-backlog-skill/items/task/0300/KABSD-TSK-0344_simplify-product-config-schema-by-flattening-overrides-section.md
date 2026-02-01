---
area: general
created: '2026-01-31'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0344
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
title: Simplify product config schema by flattening overrides section
type: Task
uid: 019c146b-f186-7020-a860-5f336291a659
updated: 2026-01-31
---

# Context

Current .kano/backlog_config.toml uses nested overrides structure that is verbose and harder to read. Example: [products.kano-agent-backlog-skill.overrides.vector] enabled = true. This requires understanding TOML table nesting and makes simple boolean flags look complex.

# Goal

Flatten product-specific overrides into the product section directly using simple key names like vector_enabled, analysis_llm_enabled instead of nested overrides tables.

# Approach

1. Update ProductDefinition in project_config.py to support flattened keys alongside overrides dict for backward compatibility. 2. Update config loader to map flattened keys to nested structure during merge. 3. Update .kano/backlog_config.toml to use new simplified format. 4. Update .kano/debug/backlog_config.toml documentation. 5. Test that all products load correctly with new format.

# Acceptance Criteria

1. ProductDefinition accepts both vector_enabled and overrides.vector.enabled. 2. Config loader correctly merges flattened keys into effective config. 3. .kano/backlog_config.toml uses simplified format. 4. All existing functionality works unchanged. 5. Documentation reflects new format.

# Risks / Dependencies

Breaking change if not backward compatible. Need to decide on naming convention for nested keys (vector_enabled vs vector.enabled vs vectorEnabled).

# Worklog

2026-01-31 22:19 [agent=opencode] Created item
2026-01-31 22:19 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-01-31 22:19 [agent=opencode] Workset initialized: D:\_work\_Kano\kano-agent-backlog-skill-demo\_kano\backlog\.cache\worksets\items\KABSD-TSK-0344
2026-01-31 22:22 [agent=opencode] State -> Done.
