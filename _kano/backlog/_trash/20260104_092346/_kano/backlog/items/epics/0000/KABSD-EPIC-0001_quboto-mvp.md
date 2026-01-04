---
id: KABSD-EPIC-0001
type: Epic
title: "Legacy Epic (deprecated)"
state: Dropped
priority: P1
parent: null
area: demo
iteration: null
tags: ["legacy", "deprecated"]
created: 2026-01-02
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

Legacy copy kept because the original filename is locked on disk.
Use the new epic file instead:
`_kano/backlog/items/epics/0000/KABSD-EPIC-0001_kano-agent-backlog-skill-demo.md`.

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

2026-01-04 09:12 [agent=codex] Deprecated legacy epic file after creating demo-named copy.
