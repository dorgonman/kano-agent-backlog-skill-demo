---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0236
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: null
priority: P2
state: Done
tags: []
title: Add ticketing guidance to conventions via CLI
type: Task
uid: 019bc766-e4d2-7134-8a6a-cd82ce0f03dc
updated: 2026-01-16
---

# Context

Need to add ticketing guidance (Epic/Feature/UserStory/Task) to _meta/conventions.md, using CLI to preserve audit logs.

# Goal

Provide an admin CLI command to append ticketing guidance to conventions and apply it.

# Approach

- Implement an ops helper to append guidance if missing, with audit log.
- Add admin meta add-ticketing-guidance command.
- Apply to conventions.md and update worklog.

# Acceptance Criteria

- conventions.md contains ticketing guidance section.
- CLI command updates file and logs operation.

# Risks / Dependencies

- Duplicate insertion if not idempotent; guard with a marker.

# Worklog

2026-01-16 23:22 [agent=codex] [model=unknown] Created item
2026-01-16 23:23 [agent=codex] [model=gpt-5.2-codex] Implement admin meta command for conventions update.
2026-01-16 23:23 [agent=codex] [model=gpt-5.2-codex] Added admin meta add-ticketing-guidance command and applied it to conventions.md.
2026-01-16 23:24 [agent=codex] [model=gpt-5.2-codex] Ticketing guidance added to conventions via CLI.
