---
id: KABSD-EPIC-0001
type: Epic
title: "Kano Agent Backlog Skill Demo"
state: Planned
priority: P1
parent: null
area: demo
iteration: null
tags: ["demo", "backlog", "skill"]
created: 2026-01-02
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

We want a minimal, working demo that shows how kano-agent-backlog-skill keeps
agent collaboration durable with local-first planning and decision trails.

# Goal

Define the demo scope and track the backlog items that support the workflow.

# Non-Goals

- Shipping a production product.
- External PM system integration.

# Approach

Create and link the demo Feature/UserStory/Tasks under this Epic.

# Links

- Feature: [[KABSD-FTR-0001_local-backlog-system|KABSD-FTR-0001 Local-first backlog system]]
- Feature: [[KABSD-FTR-0003_self-contained-skill-bootstrap-and-automation|KABSD-FTR-0003 Self-contained skill bootstrap and automation]]

# Alternatives

- Track in a single flat task list.

# Acceptance Criteria

- Demo scope is captured as Features/UserStories/Tasks.
- Links resolve within `_kano/backlog/items/**`.

# Risks / Dependencies

- Demo drift without regular pruning.
- Obsidian view syntax changes across versions.

# Worklog

2026-01-02 10:10 [agent=codex] Created epic from user request.
2026-01-02 11:20 [agent=codex] Established local-first backlog system with per-type folders and Obsidian MOC links (ADR-0001).
2026-01-02 11:55 [agent=codex] Added initial TTS, STT, secret provider, and vLLM/LiteLLM features per user request.
2026-01-04 00:40 [agent=codex] Rebuilt Epic content for the demo scope; removed legacy Quboto feature links.
2026-01-04 00:56 [agent=codex] Created demo-named epic file and deprecated the legacy filename.
2026-01-04 13:55 [agent=codex] Added feature for self-contained skill bootstrap and automation.

2026-01-05 01:25 [agent=codex] Auto-sync from child KABSD-TSK-0037 -> Planned.
