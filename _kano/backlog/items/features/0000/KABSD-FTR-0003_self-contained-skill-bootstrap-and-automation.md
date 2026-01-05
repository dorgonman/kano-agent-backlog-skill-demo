---
id: KABSD-FTR-0003
type: Feature
title: "Self-contained skill bootstrap and automation"
state: InProgress
priority: P2
parent: KABSD-EPIC-0001
area: skill
iteration: null
tags: ["self-contained", "bootstrap", "scripts"]
created: 2026-01-04
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

The demo should prove the skill can stand on its own without manual copying of
backlog scaffolds or scripts from other repos.

# Goal

Ship a self-contained skill package with scripts that bootstrap the backlog
layout, install tool wrappers, and optionally seed demo views/items.

# Non-Goals

- Packaging as a pip/CLI installer or publishing to a registry.
- Auto-sync with external PM systems (Jira/Azure Boards).

# Approach

- Add bootstrap and tool-install scripts under `skills/.../scripts/backlog/`.
- Keep outputs under `_kano/backlog/` by default.
- Provide an optional seed script for demo views/items.
- Document the setup commands in the skill docs.

# Links

- Epic: [[KABSD-EPIC-0001_kano-agent-backlog-skill-demo|KABSD-EPIC-0001 Kano Agent Backlog Skill Demo]]
- UserStory: [[KABSD-USR-0004_bootstrap-backlog-scaffold-and-tools-from-the-skill|KABSD-USR-0004 Bootstrap backlog scaffold and tools from the skill]]
- UserStory: [[KABSD-USR-0005_seed-demo-data-and-views-from-the-skill|KABSD-USR-0005 Seed demo data and views from the skill]]

# Alternatives

- Keep manual setup steps in the README (too fragile for demo reuse).

# Acceptance Criteria

- Skill ships bootstrap/seed scripts and docs.
- Bootstrap script creates the standard `_kano/backlog/` structure and meta files.
- Tool wrappers can be generated from skill scripts without manual copying.
- Demo seed script produces sample views/items without manual edits.

# Risks / Dependencies

- Script drift if the demo structure diverges from the skill defaults.
- Seeding too much data could overwhelm a small demo.

# Worklog

2026-01-04 13:51 [agent=codex] Created feature for self-contained skill bootstrap and automation.
2026-01-04 13:55 [agent=codex] Added scope, approach, and linked user stories for self-contained automation.
2026-01-05 01:47 [agent=codex] Auto-sync from child KABSD-TSK-0012 -> Planned.
2026-01-05 01:47 [agent=codex] Auto-sync from child KABSD-TSK-0012 -> InProgress.
