---
id: KABSD-FTR-0004
uid: 019b8f52-9fe3-7b51-87f9-4909db22938f
type: Feature
title: Backlog config system and process profiles
state: Done
priority: P2
parent: KABSD-EPIC-0002
area: infra
iteration: null
tags:
- config
- process
created: 2026-01-04
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

We need a configuration layer for the backlog system so logging verbosity,
process definitions, and test isolation can be controlled without code edits.

# Goal

Introduce a config root under `_kano/backlog/` that can select process profiles,
toggle logging verbosity/debug behavior, and define a sandbox path for tests.

# Non-Goals

- Building a full workflow engine or external PM integration.
- Forcing a single process model on all users.

# Approach

- Define a config folder under `_kano/backlog/` to store system settings.
- Add process profile definitions (Agile/Scrum/CMMI or Azure Boards defaults).
- Allow config to select a built-in process or a custom path.
- Introduce a sandbox path for tests to avoid contaminating real backlog data.

# Links

- UserStory: [[KABSD-USR-0006_create-backlog-config-root-under-kano-backlog|KABSD-USR-0006 Create backlog config root under _kano/backlog]]
- UserStory: [[KABSD-USR-0007_support-log-verbosity-and-debug-flags-in-config|KABSD-USR-0007 Support log verbosity and debug flags in config]]
- UserStory: [[KABSD-USR-0008_define-board-process-profiles-for-work-item-types-and-transitions|KABSD-USR-0008 Define board process profiles for work item types and transitions]]
- UserStory: [[KABSD-USR-0009_ship-built-in-process-definitions-and-select-via-config|KABSD-USR-0009 Ship built-in process definitions and select via config]]
- UserStory: [[KABSD-USR-0010_introduce-backlog-sandbox-path-for-tests|KABSD-USR-0010 Introduce backlog sandbox path for tests]]

# Alternatives

- Hardcode defaults in scripts and update them manually when needed.

# Acceptance Criteria

- Config root exists under `_kano/backlog/` with documented fields.
- Logging verbosity/debug settings are configurable.
- Process profiles can be selected via config (built-in or custom path).
- Tests can use a dedicated sandbox path outside the main backlog items.

# Risks / Dependencies

- Overly complex config can slow down onboarding if not documented clearly.

# Worklog

2026-01-04 18:18 [agent=codex] Created feature for backlog config system and process profiles.
2026-01-04 18:26 [agent=codex] Added feature scope and linked user stories for config, process, and sandbox needs.
2026-01-05 01:26 [agent=codex] Auto-sync from child KABSD-TSK-0038 -> Planned.
2026-01-05 01:39 [agent=codex] Auto-sync from child KABSD-TSK-0039 -> InProgress.
2026-01-06 08:34 [agent=codex-cli] Re-parented Feature from KABSD-EPIC-0001 to KABSD-EPIC-0002 for milestone 0.0.1.
2026-01-07 07:25 [agent=copilot] Config root, process profiles, logging verbosity, and sandbox support shipped for 0.0.1.
