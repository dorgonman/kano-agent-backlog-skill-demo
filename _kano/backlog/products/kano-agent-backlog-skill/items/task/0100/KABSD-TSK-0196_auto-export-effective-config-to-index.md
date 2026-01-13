---
area: config
created: '2026-01-13'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0196
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Done
tags:
- config
- effective-config
title: Auto-export effective config to _index
type: Task
uid: 019bb684-647c-72f4-8305-2ebda2dd5ff0
updated: 2026-01-13
---

# Context

Effective config is currently only produced when running the config export command, so _kano/backlog/_index often lacks a machine-readable effective config artifact. This makes snapshots and tools expect a derived artifact that is usually missing.

# Goal

Automatically write the effective merged config (context plus config) to _kano/backlog/_index during common workflows so users can find it without manual steps.

# Approach

Add an ops-layer helper that writes a stable, per-product effective-config artifact (overwrite). Call it from CLI workflows (at minimum: view refresh; optionally: config init and config migrate-json --write).

# Acceptance Criteria

1) Running view refresh writes or updates an effective config file under _kano/backlog/_index. 2) The file includes both context and config keys. 3) View refresh does not fail if export fails (it should warn). 4) All tests pass.

# Risks / Dependencies

Risk: a stable filename may overwrite previous exports; mitigation: make it per-product and keep config export available for timestamped archives.

# Worklog

2026-01-13 16:41 [agent=copilot] Created item
2026-01-13 17:00 [agent=copilot] [model=gpt-5.2] Start: implement auto-export of effective config artifact during view refresh and config workflows.
2026-01-13 17:00 [agent=copilot] [model=gpt-5.2] Done: view refresh now writes a stable per-product effective config artifact to _kano/backlog/_index; config init and migrate-json --write also write/update the artifact. Tests passing.
