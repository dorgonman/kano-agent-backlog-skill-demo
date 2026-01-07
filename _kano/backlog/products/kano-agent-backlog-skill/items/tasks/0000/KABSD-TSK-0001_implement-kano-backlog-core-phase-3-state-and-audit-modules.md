---
id: KABSD-TSK-0001
uid: 019b9990-b71e-793a-b327-e3ef593f0f5d
type: Task
title: "Implement kano-backlog-core Phase 3: State and Audit modules"
state: Done
priority: P1
parent: KABSD-FTR-0019
area: general
iteration: null
tags: ["phase3"]
created: 2026-01-08
updated: 2026-01-08
owner: copilot
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
---

# Context

Phases 1 (Config+Canonical) and 2 (Derived+Refs) complete with 84% coverage. Phase 3 implements business logic for state management and audit trails:

**State module**: Enforces valid state transitions (New→Ready→InProgress→Done) and Ready gate validation for Task/Bug items. Ready gate ensures Context, Goal, Approach, Acceptance Criteria, and Risks sections are non-empty before work starts.

**Audit module**: Maintains append-only worklog entries and file operation logs. Every state transition generates a timestamped worklog entry with agent attribution. Supports parsing existing worklogs and formatting new entries.

These modules enable facade implementations to enforce workflow discipline and maintain decision trails.

# Goal

Implement State and Audit modules for kano-backlog-core that enable:
1. State transition validation and execution with Ready gate enforcement
2. Worklog management (append, parse, format)
3. File operation audit logging
4. >80% test coverage for both modules
5. Clear interfaces for CLI/Server facades

# Non-Goals

- Parent state auto-sync on child transitions (deferred to Phase 4 Service layer)
- Workset module (per-agent cache feature for Phase 4)
- Database-backed audit log queries (Phase 2.5+)

# Approach

**State Module** (state.py, 180 lines):
1. Define `StateTransition` enum with action→state mappings (start, done, ready, block, drop, propose, review)
2. Implement `StateMachine` class with `can_transition()` and `transition()` methods
3. Implement `ReadyValidator` for Task/Bug Ready gate checks (Context, Goal, Approach, Acceptance Criteria, Risks all non-empty)
4. Transition side effects: update item.state, append worklog entry, update item.updated timestamp
5. Use typed errors: `InvalidTransitionError`, `ReadyGateError`

**Audit Module** (audit.py, 150 lines):
1. Implement `WorklogEntry` Pydantic model with timestamp/agent/message fields
2. Parse worklog format: `2026-01-08 01:45 [agent=copilot] Message text`
3. Implement `AuditLog` class with static methods: `append_worklog()`, `log_file_operation()`, `parse_worklog()`
4. File operations logged to `_logs/agent_tools/tool_invocations.jsonl` (JSONL format)
5. Support in-place worklog appending to BacklogItem

**Testing**:
- Create `test_state.py` with 20+ tests (transitions, Ready gate, errors)
- Create `test_audit.py` with 15+ tests (worklog parsing/formatting, file logging)
- Use pytest fixtures with sample items
- Target >85% coverage

**Documentation**:
- Update README with StateMachine and AuditLog examples
- Document state transition actions and Ready gate requirements

# Alternatives

- Use external workflow engine (Temporal, Airflow) for state machine (adds dependency, overkill for simple transitions)
- Store audit logs in database instead of JSONL files (delays MVP, but more queryable)

# Acceptance Criteria

- [ ] State module: `StateMachine` with `can_transition()` and `transition()` methods working
- [ ] State module: `ReadyValidator` enforces non-empty Context, Goal, Approach, Acceptance Criteria, Risks
- [ ] State module: Invalid transitions raise `InvalidTransitionError`
- [ ] State module: Ready gate failures raise `ReadyGateError` with error list
- [ ] Audit module: `WorklogEntry` parses and formats worklog lines correctly
- [ ] Audit module: `AuditLog.append_worklog()` adds entries to BacklogItem.worklog
- [ ] Audit module: `log_file_operation()` writes JSONL to _logs/agent_tools/
- [ ] All tests passing (35+ tests across both modules)
- [ ] Coverage >85%
- [ ] README updated with StateMachine and AuditLog examples
- [ ] No breaking changes to Phases 1-2

# Risks / Dependencies

- State machine logic must match existing CLI script behavior (workitem_update_state.py)
- Worklog format parsing must handle variations (missing agent, multiline messages)
- JSONL audit log location hardcoded to `_logs/agent_tools/` (needs config for different deployments)
- Depends on Phases 1-2 completion (Config, Canonical, Models, Derived, Refs) - ✅ Complete
- Ready gate validation must be fast (avoid blocking interactive CLI workflows)

# Worklog

2026-01-08 01:45 [agent=copilot] Created from template.
2026-01-08 01:46 [agent=copilot] Started Phase 3: filled Context, Goal, Approach. Implementing State and Audit modules.
2026-01-08 02:00 [agent=copilot] Phase 3 complete: State and Audit modules, 80 tests, 86% coverage
