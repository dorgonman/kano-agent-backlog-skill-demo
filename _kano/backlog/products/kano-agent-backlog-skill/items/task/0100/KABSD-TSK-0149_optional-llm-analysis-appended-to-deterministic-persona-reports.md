---
id: KABSD-TSK-0149
uid: 019ba65a-e6b7-735d-b1a8-4f3384170076
type: Task
title: "Optional LLM analysis appended to deterministic persona reports"
state: Done
priority: P2
parent: KABSD-FTR-0004
area: views
iteration: null
tags: ["views", "persona", "llm", "analysis"]
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

We now generate deterministic persona reports (`Report_<persona>.md`) derived from canonical backlog data.
We want an optional "LLM analysis" section appended to the report:
- the analysis can vary by model capability (non-deterministic),
- but the input should be stable and auditable because it is derived from the same deterministic report.

# Goal

Add an optional pipeline step to:
1) generate the deterministic report, then
2) run an LLM over that report to produce a short analysis section (developer/pm/qa focus),
3) write the result as a derived artifact (not canonical).

# Non-Goals

Do not store LLM analysis as canonical data.
Do not pass secrets/tokens via CLI args; keep auth in env vars or external tooling.

# Approach

1) Add `scripts/backlog/view_generate_report_analysis.py`:
   - Input: report markdown path, persona, and an external LLM command (from config/env/arg).
   - Output: `views/_analysis/Report_<persona>_analysis.md` (derived).
   - If no LLM command is configured, generate a deterministic prompt file instead.
2) Update `view_refresh_dashboards.py` to optionally run this step when enabled.
3) Add gitignore rule for `views/_analysis/` (derived, non-deterministic output).
4) Document in `SKILL.md`:
   - deterministic report is SSOT for the analysis step,
   - never include secrets in logs/files.

# Alternatives

Only keep deterministic reports. Rejected: demo wants richer narrative that can improve with better models without changing the SSOT.

# Acceptance Criteria

With LLM integration disabled, refresh produces deterministic reports only.
With LLM integration enabled, refresh additionally produces `views/_analysis/Report_<persona>_analysis.md` for the configured persona and uses the deterministic report as the sole input.

# Risks / Dependencies

- Requires an external LLM runner (CLI) configured by the user/agent; the skill should not assume a specific provider.
- Non-deterministic outputs must be treated as derived artifacts (gitignored by default).
- Audit logging must not capture secrets; avoid passing API keys as CLI args.

# Worklog

2026-01-10 13:22 [agent=codex] Plan: generate deterministic report as SSOT, then optionally run an LLM over that report to append non-deterministic analysis while keeping the input stable.
2026-01-10 13:23 [agent=codex] Ready: fixed Risks/Dependencies section and prepared for implementation.
2026-01-10 13:23 [agent=codex] Start: implement optional LLM analysis pipeline over deterministic reports.
2026-01-10 13:26 [agent=codex] Done: added view_generate_report_analysis.py + config toggle analysis.llm.enabled; outputs go to views/_analysis and are gitignored.
2026-01-10 14:38 [agent=codex-cli] Changed analysis generation to template-first (no external LLM CLI required). view_generate_report_analysis now writes prompt + analysis template; refresh_dashboards can generate derived analysis artifacts.
2026-01-14 20:00 [agent=copilot] Note: KANO_LLM_COMMAND and view_generate_report_analysis.py were removed during CLI consolidation (commit f24d4c2). The analysis feature needs to be re-implemented in the new ops/CLI architecture with analysis.llm.enabled config support.
