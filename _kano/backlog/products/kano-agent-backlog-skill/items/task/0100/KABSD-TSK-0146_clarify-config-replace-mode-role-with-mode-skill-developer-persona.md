---
id: KABSD-TSK-0146
uid: 019ba5ee-11b6-78c4-af9c-b8904861795b
type: Task
title: "Clarify config: replace mode.role with mode.skill_developer + persona"
state: Done
priority: P1
parent: KABSD-FTR-0004
area: config
iteration: null
tags: ["config", "bootstrap", "persona"]
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

We currently use `mode.role` in config to distinguish "user" vs "developer". This is ambiguous:
- People using the skill can still be developers (and PM/QA/etc may participate).
- What we need to capture is (1) whether this repo is actively developing the skill, and (2) human persona preferences that may influence summaries/views.

# Goal

Replace `mode.role` with clearer fields:
- `mode.skill_developer`: boolean (are we developing the skill itself in this repo?)
- `mode.persona`: optional string (human-facing preference, e.g. developer/pm/qa; not a trust root)

# Non-Goals

Do not change backlog data model semantics beyond config naming.

# Approach

Update:
- `skills/kano-agent-backlog-skill/scripts/common/config_loader.py` defaults + validation
- product config files to new keys
- `skills/kano-agent-backlog-skill/SKILL.md` bootstrap section wording
- top-level `README.md` to recommend the user-facing prereq installer (not dev-only naming)

# Alternatives

Keep `mode.role` and document it better. Rejected: the name itself invites confusion.

# Acceptance Criteria

All references to `mode.role` are removed and replaced with `mode.skill_developer` and `mode.persona`.

# Risks / Dependencies

None.

# Worklog

2026-01-10 11:23 [agent=codex] Plan: avoid ambiguous role naming; add explicit skill_developer flag and optional persona for summary preferences.
2026-01-10 11:24 [agent=codex] Ready: clarified schema change and acceptance criteria for config mode fields.
2026-01-10 11:24 [agent=codex] Start: updating config defaults/validation and documentation for skill_developer + persona.
2026-01-10 11:25 [agent=codex] Done: renamed config mode fields to mode.skill_developer + mode.persona and updated SKILL.md/README.md/AGENTS.md.
