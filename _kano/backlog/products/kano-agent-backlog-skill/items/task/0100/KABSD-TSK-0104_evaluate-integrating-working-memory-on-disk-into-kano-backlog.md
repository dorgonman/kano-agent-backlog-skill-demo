---
id: KABSD-TSK-0104
uid: 019b962e-c5f6-75cd-b509-5695dfe10991
type: Task
title: "Evaluate integrating working memory on disk into Kano Backlog"
state: Done
priority: P2
parent: null
area: research
iteration: null
tags: ["planning", "integration", "evaluation"]
created: 2026-01-07
updated: 2026-01-07
owner: antigravity
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

`planning-with-files` introduced a "working memory on disk" pattern:
- Each task uses three files: `task_plan.md` (checklist plan), `notes.md` (research notes), `deliverable.md` (final output)
- Purpose: prevent agent drift; maintain execution context across sessions

Kano backlog has implemented some capabilities (structured work items, ADRs, worklog), but we need to evaluate whether to integrate the benefits of "real-time execution-layer memory".

## References
- [planning-with-files SKILL.md](https://github.com/OthmanAdi/planning-with-files/blob/master/planning-with-files/SKILL.md)

# Goal

1. Compare the two systems and identify gaps
2. Evaluate integrating the best parts into Kano backlog (as optional features)
3. Output marketing differentiation copy: "Systematic multi-agent collaboration + decision retention"

# Non-Goals

- Breaking existing local-first principles
- Making cache the single source of truth
- Creating coupling dependencies with other skills

# Approach

1. **Comparison report**: Axis-by-axis comparison of planning-with-files vs Kano backlog
   - Scope and granularity
   - Data model
   - Drift prevention vs long-term integrity
   - Automation and guardrails
2. **Integration spec** (if recommended): Workset folder layout, templates, promotion rules
3. **Marketing differentiation**: Promotion copy (including safe version + needs-verification version)

# Alternatives

- No integration; treat planning-with-files only as external reference
- Full migration to Manus-style memory management (over-engineering risk)

# Acceptance Criteria

- [x] Comparison report clearly distinguishes "inferred" vs "confirmed"
- [x] Integration approach is minimal; does not break existing invariants
- [x] Marketing block includes both safe version and needs-verification version of Manus/Meta statements

# Risks / Dependencies

- Maintenance overhead: additional cache file layer requires upkeep
- Hidden truth risk: if workset becomes the actual working area but is not promoted back to canonical
- Need to verify external claims such as Manus/Meta acquisition amounts

# Worklog

2026-01-07 10:00 [agent=antigravity] Created from template.
2026-01-07 10:01 [agent=antigravity] Populated task scope, acceptance criteria, and deliverables based on user discussion with ChatGPT.
2026-01-07 14:10 [agent=antigravity] Completed evaluation. Report generated at [workset_evaluation_report.md](_kano/backlog/products/kano-agent-backlog-skill/artifacts/workset_evaluation_report.md). State changed to Done.
