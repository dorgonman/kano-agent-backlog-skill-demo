---
id: KABSD-TSK-0147
uid: 019ba5f7-3cf5-74eb-90ad-e88f58350687
type: Task
title: "Persona-aware project summary generation in view_refresh_dashboards"
state: Done
priority: P2
parent: KABSD-FTR-0004
area: views
iteration: null
tags: ["views", "summary", "persona"]
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

Different humans (and agents acting on their behalf) need different “at a glance” summaries:
- Engineering: what is in progress, what is ready next, what is blocked.
- PM: what epics/features are active, what is trending, what is risky (high-level).
- QA: what needs verification/review, and what bugs are pending.

We already have `mode.persona` in config, but currently no scripts use it to tailor summaries or views.

# Goal

Add a deterministic (non-LLM) summary generator that:
- reads items from SQLite when available, falling back to file scan,
- produces a short Markdown summary tailored to `mode.persona`,
- is generated automatically by `view_refresh_dashboards.py`.

# Non-Goals

Do not change canonical backlog data to store persona-specific fields.
Do not add any server runtime.

# Approach

1) Add a new script `scripts/backlog/view_generate_summary.py`:
   - Inputs: `--backlog-root`, `--items-root`, optional `--persona`, optional `--source auto|files|sqlite`, optional product aggregation flags.
   - Output: Markdown with counts + curated lists, tuned by persona.
2) Update `scripts/backlog/view_refresh_dashboards.py` to:
   - read `mode.persona` from config,
   - generate `views/Summary_<persona>.md` (or a stable `views/Summary.md` with persona note),
   - keep existing dashboards unchanged.
3) Document the behavior in `SKILL.md` (persona affects summaries/views) and keep it optional.

# Alternatives

Rely on LLM-generated summaries (token-expensive, non-deterministic).

# Acceptance Criteria

Running `view_refresh_dashboards.py` generates a persona-aware summary file under `views/` without errors.
When SQLite index is enabled and present, the summary generator uses it; otherwise it scans files.

# Risks / Dependencies

Persona naming can drift. Keep a small builtin set (developer/pm/qa) and default to developer-style output.
# Worklog

2026-01-10 11:33 [agent=codex] Implement a deterministic summary generator that adapts output to mode.persona (developer/pm/qa) and runs during dashboard refresh.
2026-01-10 11:34 [agent=codex] Ready: specified persona summary generator scope and acceptance criteria.
2026-01-10 11:34 [agent=codex] Start: implement view_generate_summary.py and integrate into view_refresh_dashboards.
2026-01-10 11:39 [agent=codex] Done: added view_generate_summary.py and integrated it into view_refresh_dashboards (writes Summary_<persona>.md).
