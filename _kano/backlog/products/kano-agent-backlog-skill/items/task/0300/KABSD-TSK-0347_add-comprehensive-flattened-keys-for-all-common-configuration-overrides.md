---
area: general
created: '2026-01-31'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0347
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
title: Add comprehensive flattened keys for all common configuration overrides
type: Task
uid: 019c148e-12d8-713f-aae5-0dff0ec4a16c
updated: 2026-01-31
---

# Context

Currently only 3 flattened keys are supported: vector_enabled, analysis_llm_enabled, cache_root. Many other common overrides still require verbose nested syntax. Users frequently need to override log settings, embedding config, chunking params, etc.

# Goal

Add comprehensive flattened keys for all commonly overridden configuration options to make product configs as simple as possible.

# Approach

1. Extend flattened_keys dict in project_config.py with all common overrides. 2. Add keys for: log (debug, verbosity), embedding (provider, model, dimension), vector (backend, metric), chunking (target_tokens, max_tokens), tokenizer (adapter, model). 3. Update .kano/debug/backlog_config.toml documentation with all supported keys. 4. Test all new keys work correctly.

# Acceptance Criteria

1. All common config options have flattened keys. 2. Documentation lists all supported flattened keys. 3. All products load correctly. 4. Test cases verify flattened keys convert properly.

# Risks / Dependencies

None - following same pattern as existing flattened keys.

# Worklog

2026-01-31 22:56 [agent=opencode] Created item
2026-01-31 22:56 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-01-31 22:56 [agent=opencode] Workset initialized: D:\_work\_Kano\kano-agent-backlog-skill-demo\_kano\backlog\.cache\worksets\items\KABSD-TSK-0347
2026-01-31 22:58 [agent=opencode] State -> Done.
