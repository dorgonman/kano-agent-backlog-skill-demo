---
area: general
created: '2026-01-30'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0063
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: kiro
parent: KABSD-EPIC-0014
priority: P2
state: Done
tags: []
title: Simplify multi-product config with project-level .kano/config.toml
type: Feature
uid: 019c0c09-9f54-75a8-ace2-96e1b25daa56
updated: 2026-01-30
---

# Context

Current multi-product config requires each product to have its own _config/config.toml in _kano/backlog/products/<product>/_config/. This becomes unwieldy with many products and doesn't support flexible backlog root locations. User wants to manage multiple products from a single project-level config and point backlog roots to different locations.

# Goal

Enable project-level configuration via .kano/config.toml that can define multiple products and their backlog root locations, while maintaining backward compatibility with existing per-product configs.

# Approach

1. Add support for .kano/config.toml at project root 2. Support [products.<name>] sections for multi-product config 3. Add backlog_root field to specify custom locations 4. Update config resolution to check project-level first, then per-product 5. Modify CLI to accept --config-file parameter 6. Update init command to support both modes

# Acceptance Criteria

1. .kano/config.toml can define multiple products 2. Each product can specify custom backlog_root 3. Backward compatibility with existing per-product configs 4. CLI supports --config-file parameter 5. Config resolution follows precedence: CLI args > project config > product config > defaults 6. Documentation updated with new config patterns

# Risks / Dependencies

Breaking changes to config resolution logic. Need careful migration strategy for existing setups.

# Worklog

2026-01-30 07:14 [agent=kiro] Created item
2026-01-30 07:15 [agent=kiro] Created design document and example config. Ready to implement config resolution changes. [Ready gate validated]
2026-01-30 07:17 [agent=kiro] Completed design phase: Created config-simplification.md design doc, .kano/config.toml.example template, and config-poc.py proof of concept. Ready for implementation phase.
