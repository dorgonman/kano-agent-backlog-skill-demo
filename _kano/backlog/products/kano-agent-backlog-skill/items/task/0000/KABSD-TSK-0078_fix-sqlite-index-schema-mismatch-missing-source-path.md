---
id: KABSD-TSK-0078
uid: 019b9363-e634-723f-818e-9aa0f93f039e
type: Task
title: "Fix SQLite index schema mismatch (missing source_path)"
state: Done
priority: P2
parent: KABSD-FTR-0007
area: indexing
iteration: null
tags: ["sqlite", "index", "schema"]
created: 2026-01-06
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
Index build is failing because the SQLite schema is missing the `source_path` column (or diverged). This blocks dashboard refresh and any script depending on the derived index.

# Goal

Fix the SQLite schema mismatch so index build succeeds and dashboards refresh without errors.

# Non-Goals

- No server/back-end runtime changes (Local-first clause).
- No Postgres path in this ticket (stay on SQLite).

# Approach

1) Inspect `scripts/indexing/build_sqlite_index.py` schema DDL to ensure `source_path` is present and aligned with ingesters.
2) Add/adjust migration logic (apply_schema) to add missing column or recreate table safely.
3) Rebuild index and verify `view_generate`/`view_refresh_dashboards` works end-to-end.
4) Add a minimal test (or manual check) to prevent regressions.

# Alternatives

- Recreate database from scratch every time (slower; acceptable as fallback, but fix schema is better).
- Ignore `source_path` and rely on file name only (loses provenance, rejected).

# Acceptance Criteria

- Index rebuild completes without errors using `view_refresh_dashboards.py --source auto`.
- Schema contains `source_path` where expected; no missing-column errors in ingest.
- Dashboards regenerate successfully (New/Active/Done) using file or SQLite source.

# Risks / Dependencies

- Existing index file may need migration or full rebuild; ensure safe apply/recreate logic.
- Alignment with future embedding/derived indexes (keep `source_path` stable).

# Worklog

2026-01-06 20:59 [agent=codex] Created to address index build failure due to missing source_path column.
2026-01-09 11:45 [agent=copilot] Filled Ready sections; ready for state transition.
2026-01-09 15:31 [agent=copilot] State -> Ready.
2026-01-09 15:32 [agent=copilot] State -> Ready.
2026-01-09 17:31 [agent=copilot] State -> Ready.
2026-01-09 17:31 [agent=copilot] State -> InProgress.
2026-01-09 17:37 [agent=copilot] Migration guard added; index rebuild + dashboard refresh succeeded.
