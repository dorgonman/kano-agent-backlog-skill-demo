---
area: refactor
created: '2026-01-13'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0197
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
- cache
- index
- refactor
title: Flatten .cache and remove _index folder
type: Task
uid: 019bb69a-ba58-7129-a21f-58936632d546
updated: 2026-01-13
---

# Context

Currently derived artifacts are split between _index and .cache directories with unclear semantics. _index contains SQLite index plus effective config snapshots; .cache contains worksets. Many subdirectories under .cache and _index contain only a single file.

# Goal

Flatten all derived artifacts into .cache (except worksets which stays as-is). Remove _index folder entirely. Simplify effective_config filename to remove product suffix.

# Approach

1. Move _index/backlog.sqlite3 to .cache/index.sqlite3. 2. Change auto-export effective config from _index/effective_config-product.toml to .cache/effective_config.toml (no product suffix). 3. Remove timestamped default for manual config export (require --out). 4. Update all path references in index.py, config_cmd.py, view.py, init.py. 5. Update tests. 6. Add migration note in CHANGELOG.

# Acceptance Criteria

1. .cache contains index.sqlite3 and effective_config.toml (flat). 2. _index folder no longer exists or referenced. 3. config export requires --out flag. 4. All tests pass. 5. Existing backlogs can migrate smoothly.

# Risks / Dependencies

Risk: breaking existing tooling that reads from _index; mitigation: add migration script and document in CHANGELOG.

# Worklog

2026-01-13 17:05 [agent=copilot] Created item
2026-01-13 17:06 [agent=copilot] [model=unknown] Start: flatten .cache and remove _index
2026-01-13 17:10 [agent=copilot] [model=claude-sonnet-4.5] Done: Flattened .cache structure. SQLite index now at .cache/index.sqlite3, effective_config at .cache/effective_config.toml (no product suffix). Removed _index folder. config export now requires --out flag. All tests passing.
