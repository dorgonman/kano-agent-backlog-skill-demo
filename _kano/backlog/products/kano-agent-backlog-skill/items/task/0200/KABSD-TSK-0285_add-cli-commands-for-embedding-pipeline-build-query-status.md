---
area: general
created: '2026-01-22'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0285
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Done
tags: []
title: Add CLI commands for embedding pipeline (build/query/status)
type: Task
uid: 019be460-cee9-7710-b162-34d21749d071
updated: 2026-01-23
---

# Context

With the E2E pipeline logic available in ops layer (TSK-0284), we need CLI commands to expose this functionality to users and agents. The 'kano-backlog embedding' command group will handle index building, querying, and inspection.

# Goal

Implement 'kano-backlog embedding' command group with subcommands: build (index file/text), query (search), and status (inspect DB).

# Approach

1. Create kano_backlog_cli/commands/embedding.py using Typer. 2. Implement 'build' command: accept file path or text, load config, call ops.index_document. 3. Implement 'query' command: accept query string and k, embed query, search backend, print results table. 4. Implement 'status' command: inspect SQLite DB metadata (dims, count). 5. Register command group in main cli.py. 6. Verify with NoOp defaults.

# Acceptance Criteria

'kano embedding build <file>' works; 'kano embedding query <text>' returns results; 'kano embedding status' shows DB stats; help output is correct.

# Risks / Dependencies

Config resolution for CLI commands might need care to pick up local config.toml.

# Worklog

2026-01-22 14:25 [agent=antigravity] Created item
2026-01-23 01:40 [agent=kiro] State -> Done.
