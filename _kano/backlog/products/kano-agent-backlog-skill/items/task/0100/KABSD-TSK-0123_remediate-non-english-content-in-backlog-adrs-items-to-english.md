---
id: KABSD-TSK-0123
uid: 019b98c6-0ad8-7ecd-a990-a3bad500041a
type: Task
title: "Remediate non-English content in backlog (ADRs/items) to English"
state: Done
priority: P1
parent: KABSD-FTR-0022
area: general
iteration: null
tags: []
created: 2026-01-07
updated: 2026-01-07
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

Backlog artifacts must be in English for consistent collaboration and CI lints now enforce this. Several ADR appendices and tasks contain CJK text and need translation to meet guidelines and pass the linter.

# Goal

Translate remaining non-English content in the kano-agent-backlog-skill product backlog (ADRs and items) to clear English without altering intent or decisions.

# Non-Goals

- Redesigning decisions or changing technical conclusions.
- Editing code or non-backlog documentation.
- Building an automated translator.

# Approach

- Prioritize high-violation files flagged by the linter (ADR-0003 appendices; any tasks with CJK text).
- Rewrite headings, tables, and prose to English while preserving structure and meaning.
- Keep diffs minimal and avoid renaming files or IDs.
- Re-run the linter to confirm reductions; iterate until zero violations within scope.

# Alternatives

- Temporarily ignore files in the linter (not preferred; hides real problems).
- Keep bilingual text (rejected; policy requires English only).

# Acceptance Criteria

- ADR-0003 appendices have no CJK characters and read clearly in English.
- All edited items pass the language guard checker.
- No structural or semantic changes to decisions; only language.
- Linter run shows a reduced violation count vs baseline; ideally zero in edited files.

# Risks / Dependencies

- Nuance loss in translation; mitigate by careful phrasing and preserving technical details.
- Time required if many files contain CJK text; prioritize ADRs first.

# Worklog

2026-01-07 22:04 [agent=copilot] Created from template.
2026-01-07 22:05 [agent=copilot] Filled Ready sections with plan and criteria.
2026-01-07 22:05 [agent=copilot] State -> InProgress.
2026-01-07 23:06 [agent=copilot] Completed translation: ADR-0003 appendices (migration-plan, ulid-vs-uuidv7, collision-report, id-resolver), KABSD-TSK-0104, KABSD-TSK-0111. Linter confirms zero violations.
