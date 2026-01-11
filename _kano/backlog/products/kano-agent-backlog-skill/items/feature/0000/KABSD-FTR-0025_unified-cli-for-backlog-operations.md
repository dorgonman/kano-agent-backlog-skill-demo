---
id: KABSD-FTR-0025
uid: 019bac45-bf5e-7331-8762-674aae454b36
type: Feature
title: "Unified CLI for All Backlog Operations"
state: New
priority: P1
parent: KABSD-EPIC-0004
area: tooling
iteration: null
tags: ["cli", "automation", "skill-hardening"]
created: 2026-01-09
updated: 2026-01-09
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

Currently, agents invoke 40+ standalone Python scripts directly (e.g., `workitem_create.py`, `workitem_update_state.py`). Each script has its own argument parsing, error handling, and audit logging. This creates inconsistent UX and makes skill evolution harder.

The `kano_cli` package (now self-contained in `src/kano_cli/`) has the foundation but only implements 3 basic commands. We need to expand it to cover the high-frequency operations, unifying all backlog interactions through a single `kano` CLI entry point.

**Gap**: Agent documentation (SKILL.md, CLAUDE.md) still recommends raw scripts, creating cognitive overhead.

# Goal

Convert the 6 most-used backlog operations into unified CLI subcommands:
1. `kano item create` (replaces `workitem_create.py`)
2. `kano item update-state` (replaces `workitem_update_state.py`)
3. `kano item validate` (replaces `workitem_validate_ready.py`)
4. `kano item read` (✅ already exists)
5. `kano worklog append` (✅ already exists)
6. `kano view refresh` (replaces `view_refresh_dashboards.py`)

Then update SKILL.md, CLAUDE.md, and templates to guide agents through CLI instead of raw scripts.

**Success**: All agent backlog interactions default to `kano <cmd>` with consistent output, error handling, and audit trails.

# Non-Goals

- Eliminating standalone scripts entirely (keep them as thin wrappers for power users)
- Implementing rare/specialized commands (e.g., `workset_promote.py`, ADR tooling) yet
- Building a GUI or TUI

# Approach

## Phase 1: Expand CLI Package (Days 1-2)

1. **Add `item create` subcommand**
   - Wrap `workitem_create.py` logic
   - Arguments: `--type {epic,feature,userstory,task,bug}`, `--title`, `--parent`, `--priority`, `--tags`, `--product`
   - Output: Plain text or JSON (with item ID/UID)

2. **Add `item update-state` subcommand**
   - Wrap `workitem_update_state.py` logic
   - Arguments: `--item <id/uid>`, `--state`, `--action`, `--message`, `--product`, `--no-sync-parent`, `--force`
   - Side-effect: Auto-refresh dashboards (unless `--no-refresh`)

3. **Add `item validate` subcommand**
   - Wrap `workitem_validate_ready.py` logic
   - Arguments: `--item <id/uid>`, `--product`, `--format {plain,json}`

4. **Add `view refresh` subcommand**
   - Wrap `view_refresh_dashboards.py` logic
   - Arguments: `--backlog-root`, `--product`, `--agent`, `--config`
   - Output: Summary of refreshed views

5. **Enhance error handling & audit logging**
   - All commands log to `_kano/backlog/_logs/agent_tools/cli_invocations.jsonl`
   - Consistent exit codes and error messages

## Phase 2: Update Documentation (Day 3)

- Rewrite SKILL.md: Agent section → all `kano` commands
- Update CLAUDE.md quick reference
- Update README.md examples
- Update skill templates (AGENTS.block.md, CLAUDE.block.md)

## Phase 3: Smoke Test (Day 3-4)

- Create a task, update state, validate, refresh—all via CLI
- Verify audit logs are written
- Verify dashboards auto-refresh

# Acceptance Criteria

- [ ] `kano item create` works with minimal args (--type task --title "...")
- [ ] `kano item update-state` accepts id/uid and transitions state
- [ ] `kano item validate` reports Ready gate gaps (or passes)
- [ ] `kano view refresh` regenerates dashboards
- [ ] All commands log to audit trail (JSONL format)
- [ ] SKILL.md and CLAUDE.md updated to recommend CLI-first
- [ ] Smoke test scenario (create → update → validate → refresh) passes end-to-end

# Risks / Dependencies

- **Risk**: Wrapping scripts may hide edge cases → Mitigate: Keep scripts as fallback; run smoke tests against existing backlog
- **Dependency**: kano_backlog_core and kano_cli modules stable (✅ already self-contained)
- **Timeline**: Estimate 3-4 days if scripts are straightforward to wrap

---

# Worklog

- 2026-01-09 10:30 [agent=copilot] Ticket created. Starting Phase 1: CLI expansion.
