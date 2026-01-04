---
id: KABSD-TSK-0010
type: Task
title: "Generate tool wrappers from skill scripts"
state: Proposed
priority: P3
parent: KABSD-USR-0004
area: skill
iteration: null
tags: ["scripts", "tools"]
created: 2026-01-04
updated: 2026-01-04
owner: null
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

Tool wrappers in `_kano/backlog/tools` should be generated from the skill so
the demo can stay self-contained and reproducible.

# Goal

Create a script that generates wrapper scripts pointing to skill automation.

# Non-Goals

- Supporting non-Python wrapper generation.
- Overwriting existing wrappers without explicit confirmation.

# Approach

- Add `scripts/backlog/install_tools.py`.
- Emit Python wrapper scripts into `_kano/backlog/tools/`.
- Keep wrapper arguments consistent with skill scripts.
- Make the script safe to run multiple times.

# Alternatives

- Manual copy/paste of tools from the demo repo.

# Acceptance Criteria

- Script creates `_kano/backlog/tools/*.py` wrappers for backlog/fs scripts.
- Running the script twice does not corrupt or duplicate wrappers.
- Output paths are configurable via CLI flags.

# Risks / Dependencies

- Wrapper scripts may drift if skill entry points change.

# Worklog

2026-01-04 13:51 [agent=codex] Created task for generating tool wrappers.
2026-01-04 13:55 [agent=codex] Added scope and acceptance criteria for wrapper generation.
