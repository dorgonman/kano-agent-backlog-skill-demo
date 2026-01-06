---
id: KABSD-TSK-0089
uid: 019b9451-4c47-7aae-b744-646f373a5d14
type: Task
title: "Design process migration plan and mapping for profile changes"
state: Proposed
priority: P2
parent: KABSD-FTR-0010
area: process
iteration: null
tags: ["process", "migration", "design"]
created: 2026-01-07
updated: 2026-01-07
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

We need a safe way to migrate backlog items when changing the active process profile
(e.g., Azure -> Jira). This can affect item types, folder layout, and potentially IDs.

# Goal

Design a report-first migration plan (no implicit changes) and define a mapping
format for explicit, auditable migrations between process profiles.

# Non-Goals

- No automatic ID renumbering by default.
- No heuristic or AI-based mapping suggestions.
- No silent moves/edits; every change must be explicit and logged.

# Approach

## A) Report-only mode (process_linter)

Add `process_linter --plan-migration` to generate a report without changing files.
Inputs:
- `--product` / `--sandbox`
- optional `--process-profile` / `--process-path` (target profile)
- optional `--mapping` file (explicit type mapping)

Outputs:
- Summary counts by current type and folder
- Missing/extra folders vs target profile
- Candidate mappings (from mapping file)
- Unmapped items and conflicts
- JSON + Markdown report under `_kano/backlog/_meta/migrations/`

## B) Apply mode (explicit migrator)

Add `process_migrator.py` (or `process_linter --apply-migrate`) with strict flags:
- Requires `--mapping` and `--confirm`
- Uses `scripts/fs/*` to move files (audit logged)
- Updates frontmatter fields based on mapping

### Mapping file (JSON)

```
{
  "from_profile": "builtin/azure-boards-agile",
  "to_profile": "builtin/jira-default",
  "type_map": {
    "UserStory": "Story",
    "Feature": "Epic"
  },
  "folder_map": {
    "userstories": "stories"
  },
  "id_strategy": "keep",   // keep | alias | regenerate
  "notes": "Explicitly reviewed by human before apply"
}
```

Behavior by `id_strategy`:
- `keep`: keep IDs and filenames; only update `type` + folder.
- `alias`: keep ID but add `aliases` or `legacy_type` to preserve old meaning.
- `regenerate`: generate new ID + rename file + update `aliases` to old ID (manual confirmation required).

## C) Safeguards

- Default is report-only; apply requires `--mapping` + `--confirm`.
- For `regenerate`, require `--allow-id-change`.
- Every operation logs to Worklog and audit logs.
- Never delete; move only (trash on failure).

# Alternatives

- Keep process_linter as folder-only, and do migration as a separate one-off script (risk: duplicated logic).
- Force manual migration only (slow and error-prone).

# Acceptance Criteria

- `process_linter --plan-migration` produces a report without touching files.
- A mapping format exists and is documented.
- Apply mode requires explicit mapping + confirmation.
- Migration updates are auditable and reversible.

# Risks / Dependencies

- ID/type mismatch if `keep` is used; must document as allowed legacy.
- Renaming IDs requires reference updates and may need resolver support.
- Mixed profiles in a repo may need per-product config isolation.

# Worklog

2026-01-07 01:18 [agent=codex] Create task to design migration planning (report-only) and explicit mapping for process profile changes.
2026-01-07 01:23 [agent=codex] Drafted report-only migration plan + explicit mapping schema; outlined apply safeguards and ID strategies.
