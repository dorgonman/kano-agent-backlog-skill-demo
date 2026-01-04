---
id: KABSD-TSK-0024
type: Task
title: "Add config selector for process profile"
state: Proposed
priority: P3
parent: KABSD-USR-0009
area: process
iteration: null
tags: ["process", "config"]
created: 2026-01-04
updated: 2026-01-04
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

Once built-ins exist, config must be able to select which profile to use.

# Goal

Add a config field that selects a built-in process profile or custom path.

# Non-Goals

- Automatic migration of existing items to a new process.

# Approach

- Add `process_profile` fields to config (name/path).
- Document resolution order and defaults.

# Alternatives

- Hardcode a single process in scripts.

# Acceptance Criteria

- Config can point to a built-in profile or custom file.
- Selection rules are documented.

# Risks / Dependencies

- Misconfigured paths could break process-dependent tooling.

# Worklog

2026-01-04 18:23 [agent=codex] Created task to add config selector for process profile.
2026-01-04 18:40 [agent=codex] Added scope and acceptance criteria for profile selection.
