---
area: architecture
created: '2026-01-12'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-EPIC-0009
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
- refactor
- cli
- breaking-change
title: 'CLI Namespace Refactoring: Skill-Scoped Naming Convention'
type: Epic
uid: 019bae58-8901-75cd-b2e3-51a7c4bb3354
updated: 2026-01-12
---

# Context

Current CLI uses 'kano' as executable name and 'kano_cli' as package name. This namespace collision will block future skill development (e.g., kano-commit-convention-skill) and prevents a clean umbrella CLI design. The command tree also lacks domain consistency (item vs workitem, backlog occupying root level).

# Goal

1) Reserve 'kano' namespace for future umbrella CLI. 2) Each skill CLI uses skill-scoped name (kano-backlog, kano-commit). 3) Command tree uses consistent domain terminology. 4) Python packages are skill-scoped (kano_backlog_cli, not kano_cli).

# Approach

Phase 1: Rename executable and packages. Phase 2: Restructure command tree. Phase 3: Document namespace convention via ADR. Maintain backward compat via deprecated wrapper during transition.

# Acceptance Criteria

- scripts/kano-backlog is the primary CLI entry point\n- src/kano_backlog_cli/ replaces src/kano_cli/\n- Command tree: admin, workitem, worklog, view, index, validate\n- ADR-0016 documents namespace convention\n- ADR-0013 updated to reference skill-scoped naming\n- Deprecated 'kano' wrapper emits migration warning

# Risks / Dependencies

- Breaking change for existing users/scripts\n- Submodule pointer update required\n- SKILL.md and all docs need update\n- Migration path must be clear

# Worklog

2026-01-12 02:36 [agent=copilot] Created item
2026-01-12 02:38 [agent=copilot] Epic planned with 3 Features and 9 Tasks for CLI namespace refactoring.
2026-01-12 07:01 [agent=copilot] Done: CLI namespace refactoring complete. All 3 features finished (FTR-0034: package rename, FTR-0035: command tree restructure, FTR-0036: documentation updates). Skill now uses skill-scoped naming (kano-backlog, kano_backlog_cli) with reserved 'kano' for future umbrella CLI.
