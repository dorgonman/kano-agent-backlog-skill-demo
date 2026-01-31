---
area: configuration
created: '2026-01-31'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0334
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Done
tags:
- config
- migration
- cleanup
title: Migrate product-specific configs to project-level config
type: Task
uid: 019c11ec-5fdf-76f5-8420-dc8c250989a4
updated: 2026-01-31
---

# Context

We have two configuration systems: project-level (.kano/backlog_config.toml) and product-specific (_kano/backlog/products/<product>/_config/config.toml). Product configs contain redundant vector/cache/embedding settings that conflict with project-level shared config. This creates confusion and maintenance burden.

# Goal

Migrate to single source of truth for shared settings. Product configs should only contain product-specific overrides.

# Approach

1. Audit all product configs for redundant settings
2. Remove [vector], [cache], [embedding] sections from product configs
3. Keep only product-specific settings (name, prefix, mode, etc.)
4. Add comments explaining inheritance
5. Update documentation
6. Test configuration loading and vector operations

# Acceptance Criteria

- All product configs removed redundant [vector], [cache], [embedding] sections
- Product configs only contain product-specific overrides
- Comments explain inheritance from project-level config
- All products load config correctly (verified with 'kano-backlog config show')
- Vector operations work correctly (verified with 'kano-backlog embedding build')
- Documentation updated in .kano/debug/backlog_config.toml

# Risks / Dependencies

Breaking existing workflows if config loading logic has bugs. Mitigation: thorough testing before committing.

# Worklog

2026-01-31 10:40 [agent=opencode] Created item
2026-01-31 10:40 [agent=opencode] Configuration migration completed successfully. All product configs now inherit from project-level shared settings. Tests passed: config loading (3/3 products), vector operations (3449 vectors generated).
