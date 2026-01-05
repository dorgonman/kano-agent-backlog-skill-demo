---
id: KABSD-TSK-0053
type: Task
title: "Support sandbox backlog-root mode in SQLite indexer config resolution"
state: Done
priority: P4
parent: KABSD-USR-0012
area: storage
iteration: null
tags: ["sqlite", "index", "sandbox", "config"]
created: 2026-01-05
updated: 2026-01-05
owner: codex
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

Users may run the backlog in sandbox mode (e.g. `_kano/backlog_sandbox`) for tests or isolated experiments.
The SQLite indexer should resolve its config relative to the chosen `--backlog-root` by default, instead of always defaulting to `_kano/backlog/_config/config.json`.

# Goal

When `--config` is not provided, load config from `<backlog-root>/_config/config.json` if present; otherwise fall back to defaults. Keep explicit `--config` and `KANO_BACKLOG_CONFIG_PATH` overrides working.

# Non-Goals

- Enable indexing by default.
- Add new config keys beyond the resolution behavior.

# Approach

- Reorder indexer initialization: resolve/validate `--backlog-root` first, then compute default config path from it.
- Precedence: `--config` > `KANO_BACKLOG_CONFIG_PATH` > `<backlog-root>/_config/config.json` (if exists) > defaults.
- Add a short note to the script help/REFERENCE about sandbox usage.

# Alternatives

- Require users to always pass `--config` (more error-prone).

# Acceptance Criteria

- Running with `--backlog-root _kano/backlog_sandbox` and no `--config` loads sandbox-local config when present.
- Default behavior for `_kano/backlog` remains unchanged.
- `validate_config.py` still passes for default config.

# Risks / Dependencies

- Multiple config locations can be confusing; keep precedence explicit in docs.

# Worklog

2026-01-05 14:27 [agent=codex] Created from template.
2026-01-05 14:28 [agent=codex] State -> Ready. Ready gate validated for sandbox-mode config resolution.
2026-01-05 14:28 [agent=codex] State -> InProgress. Adjusting build_sqlite_index to resolve config relative to backlog-root for sandbox mode.
2026-01-05 14:28 [agent=codex] State -> Done. build_sqlite_index now resolves default config relative to backlog-root for sandbox mode, while preserving --config and KANO_BACKLOG_CONFIG_PATH overrides.
