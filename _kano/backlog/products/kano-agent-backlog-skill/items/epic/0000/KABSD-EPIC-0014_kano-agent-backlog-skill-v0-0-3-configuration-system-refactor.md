---
area: general
created: '2026-01-30'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-EPIC-0014
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
title: kano-agent-backlog-skill v0.0.3 - Configuration System Refactor
type: Epic
uid: 019c0c38-4d88-74e4-bcaa-bfe113fca270
updated: '2026-01-30'
---

# Context

The current configuration system requires each product to have its own config in separate directories, making multi-product management cumbersome. Users need a centralized way to manage multiple products from a single configuration file with flexible backlog root locations.

# Goal

Deliver v0.0.3 with a completely refactored configuration system that enables project-level multi-product management through .kano/backlog_config.toml files while maintaining full backward compatibility.

# Approach

1. Implement project-level config data structures 2. Update config resolution with proper precedence hierarchy 3. Integrate with CLI and maintain backward compatibility 4. Add migration tools and comprehensive documentation 5. Validate with real-world usage scenarios

# Acceptance Criteria

1. Single .kano/backlog_config.toml can manage multiple products 2. Flexible backlog root paths (relative/absolute) 3. Product-specific configuration overrides 4. Full backward compatibility maintained 5. CLI --config-file parameter support 6. Migration tools available 7. Comprehensive documentation 8. Real-world validation successful

# Risks / Dependencies

Breaking changes to existing setups, performance impact with large configs, complex migration scenarios for enterprise users

# Worklog

2026-01-30 08:05 [agent=kiro] Created item