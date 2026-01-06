---
id: KABSD-TSK-0008
uid: 019b8f52-9f61-784f-b2b7-6dd42aefa6d5
type: Task
title: Implement log rotation and retention
state: Done
priority: P2
parent: KABSD-USR-0003
area: infra
iteration: null
tags:
- logging
- rotation
created: 2026-01-04
updated: '2026-01-06'
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

Audit logs can grow quickly without rotation. We need a bounded retention policy.

# Goal

Implement rotation and retention logic for the audit log files.

# Non-Goals

- External archiving or remote log shipping.

# Approach

- Rotate logs by size or count.
- Keep the last N files or days.
- Document the defaults and how to override them.
- Default log root is `_kano/backlog/_logs/agent_tools/`.

# Links

- UserStory: [[KABSD-USR-0003_log-storage-rotation-and-retention-policy|KABSD-USR-0003 Log storage, rotation, and retention policy]]

# Alternatives

- Unlimited log growth.

# Acceptance Criteria

- Rotation triggers by size/count thresholds.
- Old log files are pruned according to retention.
- Defaults are documented.

# Risks / Dependencies

- Aggressive rotation may hide needed audit history.
# Worklog

2026-01-04 10:42 [agent=codex] Created task for log rotation and retention.
2026-01-04 10:46 [agent=codex] Added scope, approach, and user story link.
2026-01-04 10:49 [agent=codex] Added default log path to rotation scope.
2026-01-04 10:46 [agent=codex] Drafted task scope and links.
2026-01-04 11:14 [agent=codex] Started implementing log rotation and retention logic.
2026-01-04 11:21 [agent=codex] Implemented size-based rotation and retention in audit_logger.py.
2026-01-04 11:17 [agent=codex] Completed rotation/retention logic in audit_logger.
