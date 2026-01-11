---
id: KABSD-TSK-0168
uid: c9g4d3e2-6f0b-5c4g-0d3f-9e8g7b6f5e4d
type: Task
title: "Phase 3.5-3.6: CLI Migration and Lock Down"
state: InProgress
priority: P1
parent: KABSD-FTR-0028
area: kano-agent-backlog-skill
iteration: active
tags: [refactor, ops-layer, cli, deprecation]
created: 2025-01-11
updated: 2025-01-11
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: [KABSD-ADR-0013, KABSD-ADR-0014]
  blocks: []
  blocked_by: [KABSD-TSK-0167]
decisions: [KABSD-ADR-0013]
---

# Context

Phases 3.2-3.4 have successfully implemented direct ops layer implementations for:
- create_item: Full template rendering and file creation
- update_state: Frontmatter parsing and worklog management
- validate_ready: Section validation for Ready gate

The CLI layer (src/kano_cli/commands/) still delegates to old scripts in some cases. Phase 3.5 will migrate CLI to use direct ops implementations. Phase 3.6 will lock down old scripts to prevent future maintenance burden.

# Goal

Phase 3.5: Update CLI commands to use ops layer directly
- Remove subprocess calls for workitem operations
- Import and use create_item, update_state, validate_ready from ops
- Keep CLI focused on presentation, not logic

Phase 3.6: Lock down old scripts
- Add deprecation guards preventing script execution
- Block creation of new scripts in scripts/backlog/
- Document migration path for future users

# Approach

Phase 3.5 Tasks:
1. Migrate `kano item create` to use ops.create_item
2. Migrate `kano item update-state` to use ops.update_state (already done)
3. Migrate `kano item validate` to use ops.validate_ready
4. Remove subprocess delegation from remaining commands
5. Test all migrations

Phase 3.6 Tasks:
1. Add deprecation guard to old scripts
2. Create _DEPRECATED marker file in scripts/backlog/
3. Add README explaining migration path
4. Document in SKILL.md

# Acceptance Criteria

Phase 3.5:
- [ ] All create_item calls use ops layer
- [ ] All update_state calls use ops layer  
- [ ] All validate_ready calls use ops layer
- [ ] No subprocess calls for workitem operations remain
- [ ] Tests pass for all CLI commands

Phase 3.6:
- [ ] Old scripts fail with clear deprecation message
- [ ] Migration guide in place
- [ ] CI enforces no new scripts in scripts/backlog/

# Risks / Dependencies

- Breaking change: Old scripts become non-functional (by design)
- Depends on: Phases 3.2-3.4 (ops implementations)
- May need: Testing for all CLI paths

# Worklog

2025-01-11 [agent=assistant] Created this task document for final phases of refactoring. Phases 3.2-3.4 completed with direct ops implementations for create_item, update_state, and validate_ready.
