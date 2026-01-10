---
id: KABSD-TSK-0160
uid: 019ba8b1-5a98-7f5f-bac9-a442a16205f1
type: Task
title: "Add kano item validate command for Ready gate"
state: Done
priority: P1
parent: KABSD-FTR-0028
area: tooling
iteration: null
tags: ["cli", "phase1"]
created: 2026-01-11
updated: 2026-01-11
owner: copilot
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: [ADR-0013]
---

# Context

The Ready gate requires Tasks/Bugs to have non-empty: Context, Goal, Approach, Acceptance Criteria, Risks/Dependencies. Currently `workitem_validate_ready.py` checks this. We need CLI access.

# Goal

Add `kano item validate` command that:
1. Checks if item meets Ready gate criteria
2. Reports missing/empty sections
3. Returns exit code 0 if valid, 1 if invalid

# Non-Goals

- Auto-fixing missing sections
- Custom validation rules

# Approach

1. Add `validate` subcommand to `src/kano_cli/commands/item.py`
2. Options:
   - `--item ID` (required)
   - `--product TEXT`
   - `--format {plain,json}`
3. Delegate to `workitem_validate_ready.py` logic initially

# Acceptance Criteria

- [ ] `kano item validate --item KABSD-TSK-0001` reports status
- [ ] Missing sections listed in output
- [ ] Exit code 0 when all required sections present
- [ ] Exit code 1 when sections missing
- [ ] JSON format includes structured validation result

# Risks / Dependencies

- Ready gate rules defined in SKILL.md / config

# Worklog

2026-01-11 00:16 [agent=copilot] Created from template.
2026-01-11 00:20 [agent=copilot] Populated task details.
2026-01-11 00:40 [agent=copilot] Command already implemented in src/kano_cli/commands/item.py as `validate()`. Checks Ready gate fields (context, goal, approach, acceptance_criteria, risks) and reports gaps. → Done
