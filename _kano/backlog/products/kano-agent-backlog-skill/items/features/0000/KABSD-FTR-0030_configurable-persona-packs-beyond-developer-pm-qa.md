---
id: KABSD-FTR-0030
uid: 019ba8f3-6119-7e80-aebd-9ed2b22b07c4
type: Feature
title: "Configurable persona packs (beyond developer/pm/qa)"
state: Proposed
priority: P2
parent: null
area: tooling
iteration: null
tags: ["persona", "config", "views"]
created: 2026-01-11
updated: 2026-01-11
owner: null
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

Today the skill supports exactly three personas (`developer`, `pm`, `qa`) and hard-codes this set in view generation:
- `mode.persona` is normalized to this set and otherwise falls back to `developer`.
- This blocks other industries (infra/ops, game dev, etc.) from using role-appropriate personas without upstream code changes.

Decision drivers:
- Keep outputs local-first and deterministic (no server runtime).
- Preserve backward compatibility for existing repos/configs.
- Avoid role explosion by making personas project-configurable instead of endlessly expanding built-ins.

Current implementation touchpoints:
- `skills/kano-agent-backlog-skill/scripts/backlog/view_refresh_dashboards.py` (persona normalization + `--all-personas`)
- `skills/kano-agent-backlog-skill/scripts/backlog/view_generate_summary.py` / `view_generate_report.py` (hard-coded persona set)

# Goal

Allow projects to define and select persona sets (and optionally persona “packs”) via config, while keeping `developer/pm/qa` as the default.

Desired outcomes:
1. Config can specify which personas are enabled for a project.
2. `kano view refresh` can generate persona outputs for the configured personas (not a fixed list).
3. Unknown/unsupported persona values fail loudly (or warn) instead of silently changing behavior.

# Non-Goals

- Do not add a large universal library of job titles.
- Do not change canonical backlog data schema to store persona-specific fields per item.
- Do not require LLM integration to make persona outputs useful.
- Do not implement any server runtime (local-first only).

# Approach

Phase 1 (minimum viable extensibility):
- Add config keys (names TBD), for example:
  - `personas.default`: string (fallback persona)
  - `personas.enabled`: list of strings (personas to generate)
- Update view generation scripts to use config-driven persona lists instead of hard-coded `{developer, pm, qa}`.
- Define strict behavior for invalid persona:
  - Option A: warn + fall back to `personas.default` (safe)
  - Option B: error (fail-fast)

Phase 2 (persona packs / definitions):
- Add optional `personas.packs` and `personas.definitions` so a project can select a “project type” baseline (e.g., `software-default`, `infra-ops`, `game-dev`) and override locally.
- Let `personas.definitions.<name>` provide deterministic focus hints for Summary/Report sections (still non-LLM).

Backwards compatibility:
- If `personas.*` is missing, behave exactly as today (default to `developer/pm/qa`).

# Alternatives

1. Hard-code more personas upstream (architect, neteng, game-designer, ...)
   - Pros: no new config surface area
   - Cons: unbounded growth, unclear semantics, still won’t fit every industry

2. Keep only `developer/pm/qa` and ask users to “map” mentally
   - Pros: simplest
   - Cons: loses clarity and reduces adoption outside software teams

3. Support only aliases (e.g., `architect -> developer`)
   - Pros: small change
   - Cons: still cannot tune emphasis per persona or generate the right set per project

# Acceptance Criteria

- [ ] A repo can configure enabled personas without code changes.
- [ ] `kano view refresh` generates `Summary_<persona>.md` and `Report_<persona>.md` for each enabled persona.
- [ ] Default behavior remains compatible with existing configs (no `personas.*` present).
- [ ] Invalid persona values produce a deterministic warning or error (documented).
- [ ] Documentation updates explain how to choose a pack / define personas.

# Risks / Dependencies

- Risk: Config schema grows and becomes confusing. Mitigation: keep Phase 1 minimal; make packs optional.
- Risk: Personas become “UI only” without meaningful content differences. Mitigation: definitions can tune deterministic sections.
- Dependency: Needs agreement on config schema + validation rules.

# Worklog

2026-01-11 01:28 [agent=codex-cli] Created from CLI.
2026-01-11 01:30 [agent=codex-cli] Captured decision context for persona extensibility (config-driven enabled persona sets + optional persona packs); defer implementation until scheduled.
