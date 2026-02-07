---
area: docs
created: '2026-02-07'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-BUG-0015
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: copilot
parent: KABSD-EPIC-0016
priority: P1
state: InProgress
tags:
- docs
- cli
title: 'Docs: README references non-existent ''kano-backlog item list'' command'
type: Bug
uid: 019c377c-c4d0-7680-83dd-c79654373c8d
updated: 2026-02-07
---

# Context

Repo README currently suggests using , but the CLI has no  subcommand (item supports read/check-ready/add-decision/create/set-ready/update-state/attach-artifact). This causes onboarding friction and undermines beta readiness.

# Goal

Update documentation to use correct commands for listing items (or add a supported list command if intended), so the README instructions work as written.

# Approach

1) Decide the intended UX: (A) add  command, or (B) update docs to point to an existing equivalent (e.g., snapshot views, dashboards, or another command). 2) Update README and any other docs referencing the non-existent command. 3) Add a small docs sanity check to release phase1/phase2 if feasible.

# Acceptance Criteria

- README commands work on a fresh checkout. - No docs reference  unless the command exists. - Release checks (phase1) include a docs/CLI sanity step or at least no longer mislead.

# Risks / Dependencies

Adding a new CLI command impacts stability surface; if we choose to add it, we must define output format and filters to avoid future breaking changes.

# Worklog

2026-02-07 17:44 [agent=copilot] Created item [Parent Ready gate validated]
2026-02-07 17:44 [agent=copilot] Updated Ready fields: Context, Goal, Approach, Acceptance Criteria, Risks
2026-02-07 17:47 [agent=copilot] State -> Planned.
2026-02-07 18:55 [agent=copilot] State -> Done.
2026-02-07 18:55 [agent=copilot] State -> InProgress. [Ready gate validated]
