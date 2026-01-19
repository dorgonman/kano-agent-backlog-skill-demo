---
area: general
created: '2026-01-12'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0186
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
title: Clean up legacy project roots (_index, _logs, sandboxes) and align scripts
  to shared layout
type: Task
uid: 019baf60-e72a-75f7-b0de-682e43ef5b79
updated: 2026-01-12
---

# Worklog

2026-01-12 07:25 [agent=codex-cli] Created item
2026-01-12 07:25 [agent=codex-cli] Start: audit project-level roots (_index, _logs/agent_tools, sandboxes) and align scripts to shared/product layout per cross-product rules.
2026-01-12 07:32 [agent=codex-cli] Aligned shared/project paths: audit logs default to _kano/backlog/_shared/logs/agent_tools (with legacy fallback) and copied existing log there; ConfigLoader sandbox_root now resolves to _kano/backlog_sandbox/<name>; marked legacy _index/_logs/sandboxes folders with README to prevent new writes; updated tests and logging docs accordingly.
2026-01-12 07:32 [agent=codex-cli] Completed cleanup: updated defaults to shared log path with legacy fallback, fixed sandbox resolution to backlog_sandbox, documented legacy roots, and updated tests/docs.
