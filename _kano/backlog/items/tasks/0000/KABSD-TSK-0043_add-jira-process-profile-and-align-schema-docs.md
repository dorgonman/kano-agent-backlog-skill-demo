---
id: KABSD-TSK-0043
type: Task
title: "Add Jira process profile and align schema docs"
state: Done
priority: P2
parent: KABSD-USR-0009
area: process
iteration: null
tags: ["process", "docs", "jira"]
created: 2026-01-05
updated: 2026-01-05
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

Schema docs currently duplicate item type/state definitions that should
live in process profiles. We also need a Jira-flavored built-in process
definition for teams using Jira terminology.

# Goal

Move item type/state semantics guidance to process docs, add a Jira built-in
profile, and update schema docs to point to the configured process.

# Non-Goals

- Implement workflow validation or enforcement logic.
- Mirror every Jira workflow variant (project-specific states).

# Approach

- Add `references/processes/jira-default.json` with common Jira issue types.
- Update `references/processes.md` with Jira built-in and state semantics.
- Update `references/schema.md` to defer item types/states to the active process.

# Alternatives

- Keep schema and process docs duplicated and manually sync them.

# Acceptance Criteria

- Jira built-in profile exists and is listed in `processes.md`.
- `schema.md` no longer enumerates item types/states; it links to process docs.
- Config-driven process selection is documented.

# Risks / Dependencies

- Teams may expect Jira-specific state names beyond the default list.

# Worklog

2026-01-05 02:11 [agent=codex] Created from template.
2026-01-05 02:11 [agent=codex] State -> Ready. Ready gate validated for Jira process/profile + schema doc updates.
2026-01-05 02:11 [agent=codex] State -> InProgress. Adding Jira built-in profile and moving schema guidance to process docs.
2026-01-05 02:12 [agent=codex] State -> Done. Added Jira built-in profile and moved state/type semantics to process docs; schema now defers to config-selected process.
