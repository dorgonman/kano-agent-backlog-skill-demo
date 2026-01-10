---
id: KABSD-TSK-0157
uid: 019ba8b1-0454-7488-8bc9-bc63eb640dbc
type: Task
title: "Add kano doctor command for prereqs and init checks"
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

Currently, agents must run separate checks: Python prereqs (`python -c "import pydantic, ..."`) and backlog initialization (`_config/config.json` exists). There's no unified command to verify the environment is ready for backlog operations.

# Goal

Add `kano doctor` command that:
1. Checks Python prerequisites are installed
2. Checks backlog is initialized for the target product
3. Reports status in human-readable and JSON format
4. Returns non-zero exit code if any check fails

# Non-Goals

- Auto-fixing issues (that's `kano init`)
- Checking network connectivity or external services

# Approach

1. Create `src/kano_cli/commands/doctor.py`
2. Implement prereqs check (import test)
3. Implement init check (config.json exists)
4. Add `--format {plain,json}` option
5. Register in `cli.py`

# Acceptance Criteria

- [x] `kano doctor` runs without error when prereqs installed and backlog initialized
- [x] `kano doctor` returns exit code 1 when prereqs missing
- [x] `kano doctor` returns exit code 1 when backlog not initialized
- [x] `kano doctor --format json` outputs structured result

# Risks / Dependencies

None

# Worklog

2026-01-11 00:15 [agent=copilot] Created from template.
2026-01-11 00:20 [agent=copilot] Populated task details.
2026-01-11 00:35 [agent=copilot] Created src/kano_cli/commands/doctor.py with CheckResult/DoctorResult dataclasses, prereqs/init/cli checks, plain and JSON output formats. Registered in cli.py. All acceptance criteria met. → Done
