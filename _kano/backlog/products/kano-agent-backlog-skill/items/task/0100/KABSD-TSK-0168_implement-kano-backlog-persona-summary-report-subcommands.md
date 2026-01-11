---
id: KABSD-TSK-0168
uid: 019bac45-bf58-719e-92d5-9535dacf735b
type: Task
title: "Implement kano backlog persona summary|report subcommands"
state: Proposed
priority: P3
parent: KABSD-FTR-0028
area: cli
iteration: active
tags: ['cli', 'persona', 'views']
created: 2026-01-11
updated: 2026-01-11
owner: None
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

Legacy `view_generate_summary.py` and `view_generate_report.py` produce persona-specific summaries/reports with hard-coded persona sets. To support configurable personas (FTR-0030) and align with the CLI-first approach, we need `kano backlog persona summary|report` subcommands.

# Goal

Implement CLI subcommands:
- `kano backlog persona summary`: Generate a concise summary view (item counts, priority breakdown) for a persona.
- `kano backlog persona report`: Generate a detailed report (item listings, worklog excerpts, ADR references) for a persona.

Both commands should:
- Accept `--product`, `--persona developer|pm|qa|<custom>`, `--format plain|markdown`, `--output views/<file>.md`.
- Delegate to ops-layer functions (`kano_backlog_ops.view.generate_persona_summary|report`).
- Support runtime persona configuration (read from product config or `--persona-config` JSON).

# Non-Goals

- LLM-generated analysis (handled by existing `analysis.llm` config, separate from deterministic outputs).
- Real-time persona switching (UI/web feature, out of scope for CLI MVP).
- Multi-persona batch generation (can be scripted via shell loop for now).

# Approach

1. Extract summary/report generation logic from legacy scripts into `kano_backlog_ops.view.generate_persona_summary()` and `generate_persona_report()`.
2. Add CLI commands in `src/kano_cli/commands/init.py` (backlog group) or new `persona.py` module.
3. Define persona filter rules (which item types, states, tags to include) in product config or a shared persona pack JSON.
4. Reuse existing view generation plumbing (frontmatter parsing, Markdown templating).
5. Return structured result objects with output paths and stats.
6. Update SKILL.md / README.md to document new commands and deprecate legacy scripts.

# Alternatives

- Keep legacy scripts and add persona config support there: Rejected because it doesn't consolidate under the CLI.
- Merge summary and report into a single command with `--detail-level`: Rejected for clarity; separate commands make intent explicit.

# Acceptance Criteria

- [ ] `kano backlog persona summary --product <name> --persona developer` generates a summary view.
- [ ] `kano backlog persona report --product <name> --persona pm` generates a detailed report.
- [ ] Both commands accept `--output` to specify file path.
- [ ] Output format (plain vs markdown) is configurable.
- [ ] Persona filters are read from product config or default to built-in personas.
- [ ] SKILL.md documents the new commands and marks legacy scripts deprecated.
- [ ] Generated views are deterministic (same input → same output for reproducibility).

# Risks / Dependencies

- Depends on persona configuration schema (FTR-0030 roadmap).
- Risk of breaking existing view refresh workflows if personas are renamed/removed.
- Need clear migration path for users relying on hard-coded persona scripts.

# Worklog

2026-01-11 14:48 [agent=copilot] Created item
