---
area: general
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0043
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: kiro
parent: null
priority: P2
state: Done
tags: []
title: Topic Templates and Archetypes
type: Feature
uid: 019bcc9c-0c0e-7702-ab4d-cba6586a9b58
updated: 2026-01-18
---

# Context

Topics currently require manual setup with generic templates, leading to inconsistent structure and missing best practices

# Goal

Provide predefined topic templates for common workflows (research, feature development, bug investigation, refactoring)

# Approach

Create template system with pre-configured directory structure, spec files, and brief.md templates for different topic types

# Acceptance Criteria

CLI command to create topics from templates, 4+ predefined templates (research, feature, bugfix, refactor), customizable template system, template validation

# Risks / Dependencies

Risk of template proliferation - limit to essential patterns and allow custom templates

# Worklog

2026-01-17 23:38 [agent=amazonq] [model=unknown] Created item
2026-01-17 23:59 [agent=kiro] [model=unknown] Starting implementation of topic templates system - Phase 1 of topic system enhancements
2026-01-18 00:10 [agent=kiro] [model=unknown] Auto parent sync: child KABSD-USR-0036 -> Done; parent -> Done.
2026-01-18 00:10 [agent=kiro] [model=unknown] Topic Templates and Archetypes feature completed successfully. Implemented comprehensive template system with 4 built-in templates, variable substitution, CLI integration, and validation. System is ready for production use.
