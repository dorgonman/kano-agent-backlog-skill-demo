---
id: KABSD-TSK-0148
uid: 019ba642-89bf-7d7c-b302-61866f90cddb
type: Task
title: "Deterministic persona reports (developer/pm/qa) for project status"
state: Done
priority: P1
parent: KABSD-FTR-0004
area: views
iteration: null
tags: ["views", "persona", "report", "deterministic"]
created: 2026-01-10
updated: 2026-01-10
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

`Summary_<persona>.md` is currently list-oriented. For a demo, we want a more "project description" / status report style output that:
- can be generated repeatedly with the same invocation,
- changes only with the underlying backlog data,
- adapts content emphasis by `mode.persona` (developer/pm/qa),
- avoids LLM hallucinations by being derived from canonical data/index.

# Goal

Generate deterministic, persona-aware *narrative* status reports that:
- highlight what matters for each persona (engineering progress, PM risks, QA verification),
- include actionable sections (what to do next, what to verify),
- can be refreshed automatically with the existing dashboard refresh flow.

# Non-Goals

Do not replace custom, user-written questions or exploration; this is a default template.
Do not generate content via LLM; keep deterministic.

# Approach

1) Add `scripts/backlog/view_generate_report.py`:
   - Reads from SQLite when available, falls back to file scan.
   - Outputs `views/Report_<persona>.md`.
   - Includes sections tuned per persona:
     - developer: in-progress + ready-next + blockers + recent done
     - pm: active epics/features + new proposals + risks (blocked/stale/high-priority) + highlights
     - qa: review queue + bugs + recently done to verify + acceptance-criteria snippets (best-effort)
2) Integrate into `scripts/backlog/view_refresh_dashboards.py` so it always emits report + summary.
3) Update `SKILL.md` guidance: when user asks “project status”, generate/point to `Report_<persona>.md`.

# Alternatives

Keep list-only summaries. Rejected for demo: harder for humans to scan without writing prompts.

# Acceptance Criteria

Running `view_refresh_dashboards.py` produces `views/Report_developer.md`, `views/Report_pm.md`, or `views/Report_qa.md` based on config persona (and allows overriding).
Report generation is deterministic for the same backlog state.

# Risks / Dependencies

Section extraction (Acceptance Criteria) is best-effort; content may be missing on some items.
# Worklog

2026-01-10 12:55 [agent=codex] Add a built-in, deterministic status report template that adapts narrative focus by mode.persona, so users can ask for project status without crafting prompts.
2026-01-10 12:56 [agent=codex] Ready: clarified persona report requirements and acceptance criteria (deterministic, derived from data).
2026-01-10 12:56 [agent=codex] Start: implement deterministic view_generate_report.py and integrate into refresh.
2026-01-10 13:02 [agent=codex] Done: added view_generate_report.py and integrated it into view_refresh_dashboards (writes Report_<persona>.md) for deterministic persona-specific status reports.
