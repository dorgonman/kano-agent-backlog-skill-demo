---
id: KABSD-TSK-0054
type: Task
title: "Add sqlite index query CLI with presets and safe --sql"
state: Done
priority: P3
parent: KABSD-USR-0017
area: indexing
iteration: null
tags: ["sqlite", "index", "query", "cli"]
created: 2026-01-05
updated: 2026-01-06
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

USR-0017 needs a concrete CLI so agents can query the index consistently and safely.

# Goal

Implement a query CLI with useful presets and a safe `--sql` escape hatch (read-only).

# Non-Goals

# Approach

- Add `scripts/indexing/query_sqlite_index.py`.
- Inputs: `--backlog-root`, `--db-path` (optional), `--preset <name>` and/or `--sql <select>`.
- Guardrails: open DB read-only; only allow SELECT/with; output formats: markdown/json/table.
- Keep path restrictions + audit logging + `--agent` required.

# Alternatives

# Acceptance Criteria

- Presets cover at least: new, inprogress, done, recent-updated, by-tag, by-parent.
- `--sql` rejects non-read-only statements.
- Demo: can list New work items as Markdown links.

# Risks / Dependencies

- DB file may be missing or locked; CLI should show actionable errors.
- Allowing arbitrary SQL is risky; enforce SELECT-only and single-statement.
- Output format stability matters for copy/paste workflows.


# Worklog

2026-01-05 16:21 [agent=codex] Created from template.
2026-01-06 01:02 [agent=codex] State -> Ready. Ready gate completed (added Risks) for sqlite index query CLI.
2026-01-06 01:02 [agent=codex] State -> InProgress. Implementing query_sqlite_index.py (read-only, presets, safe --sql).
2026-01-06 01:04 [agent=codex] State -> Done. Added query_sqlite_index.py (read-only presets + safe --sql) and documented it in REFERENCE.md.
