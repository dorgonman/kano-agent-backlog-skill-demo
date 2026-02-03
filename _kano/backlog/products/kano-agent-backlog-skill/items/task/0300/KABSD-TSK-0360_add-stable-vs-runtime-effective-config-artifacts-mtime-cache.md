---
area: general
created: '2026-02-03'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0360
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: Done
tags: []
title: Add stable vs runtime effective config artifacts + mtime cache
type: Task
uid: 019c22b8-b08a-712c-9be2-188fe153448c
updated: '2026-02-03'
---

# Context

Need stable cached effective config (project/product) plus separate runtime override artifact; add mtime-based caching to avoid re-reading configs each call.

# Goal

Create stable effective config artifact under project_root/.kano/cache and a separate runtime override artifact; add metadata listing config sources; add mtime-based cache in loader.

# Approach

Extend ConfigLoader to compute config source list + mtime signature; add optional cache read/write under project_root/.kano/cache; write stable artifact (no topic/workset) and runtime artifact (with topic/workset/CLI overrides) with metadata + source list. Update view/config commands to write to new paths and document behavior.

# Acceptance Criteria

Stable artifact written to project_root/.kano/cache/effective_backlog_config.toml; runtime artifact written to project_root/.kano/cache/effective_current_cli_override_run_config.toml; metadata includes source file paths + mtimes; topic/workset only in runtime artifact; loader uses mtime-based cache; docs updated.

# Risks / Dependencies

Avoid stale cache; ensure cache invalidates on any source change; avoid secret leakage in artifacts.

# Worklog

2026-02-03 16:57 [agent=opencode] Created item
2026-02-03 17:52 [agent=opencode] Start implementing mtime cache + stable/runtime effective config artifacts [Ready gate validated]
2026-02-03 18:01 [agent=opencode] [model=unknown] Implemented mtime-based effective config cache with stable/runtime artifacts under project_root/.kano/cache; updated view/config hints and debug README; runtime artifact only for overrides; removed view-refresh debug export block.
2026-02-03 18:01 [agent=opencode] Completed config cache + artifacts implementation
2026-02-03 18:18 [agent=opencode] [model=unknown] Shortened runtime artifact filename to effective_runtime_backlog_config.toml and updated docs/notes.
2026-02-03 18:31 [agent=opencode] [model=unknown] Verified config cache artifacts: config show (default) and config show with profile succeeded; generated .kano/cache/effective_backlog_config.toml and .kano/cache/effective_runtime_backlog_config.toml. Fixed tomli_w serialization by stripping None in meta.