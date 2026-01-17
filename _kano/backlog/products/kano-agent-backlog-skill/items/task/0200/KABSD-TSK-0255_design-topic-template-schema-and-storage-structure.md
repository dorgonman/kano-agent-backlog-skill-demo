---
area: general
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0255
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: kiro
parent: KABSD-USR-0036
priority: P2
state: Done
tags: []
title: Design topic template schema and storage structure
type: Task
uid: 019bccaf-175c-73bf-b0b8-118474f5b8d4
updated: 2026-01-18
---

# Context

Need to define how topic templates will be structured, stored, and managed within the skill system. This includes schema definition, file organization, and integration with existing topic infrastructure.

# Goal

Design a comprehensive template system that supports predefined and custom templates with clear schema and storage organization.

# Approach

1. Define template schema (JSON/TOML) with metadata, structure, and content 2. Design storage location (skill directory vs per-product) 3. Plan integration with existing topic creation workflow 4. Design template validation and inheritance mechanisms 5. Document template format and customization guidelines

# Acceptance Criteria

Template schema defined with clear structure, Storage location decided and documented, Integration plan with existing topic CLI, Template validation mechanism designed, Documentation for template format created

# Risks / Dependencies

Over-engineering the schema - keep it simple and extensible. Storage location choice affects portability and customization.

# Worklog

2026-01-17 23:59 [agent=kiro] [model=unknown] Created item
2026-01-18 00:00 [agent=kiro] [model=unknown] Starting design of topic template system architecture
2026-01-18 00:10 [agent=kiro] [model=unknown] Topic template system design completed successfully. Created comprehensive template schema, 4 built-in templates (research, feature, bugfix, refactor), CLI integration with variable support, and validation system. Templates are working correctly with proper variable substitution and directory structure creation.
