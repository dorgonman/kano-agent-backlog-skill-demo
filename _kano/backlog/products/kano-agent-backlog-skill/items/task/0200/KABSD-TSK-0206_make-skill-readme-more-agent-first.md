---
area: general
created: '2026-01-15'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0206
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: copilot
parent: null
priority: P2
state: Done
tags: []
title: Make skill README more agent-first
type: Task
uid: 019bbd7f-eaca-72fd-b2c7-a56fb8acd8e1
updated: 2026-01-15
---

# Context

The skill README is currently accurate but reads like traditional documentation; it does not clearly show how an AI agent should be instructed to use the workflow (tickets-first, Ready gate, workset next loop, promotion) in a real repo.

# Goal

Rewrite the README opening and workflows so it is clearly agent-first: include a copy/paste prompt, an agent workflow loop, and examples that emphasize automation and deterministic artifacts.

# Approach

Add an 'Agent-first quickstart' section near the top: (1) copy/paste system prompt snippet referencing SKILL.md, (2) a minimal agent loop (pick item -> set-ready -> start -> workset next loop -> promote -> refresh views), (3) mention --format json for structured outputs. Keep the rest of the README focused on standalone installation and link to deeper docs.

# Acceptance Criteria

- README includes a copy/paste agent instruction snippet
- README includes an agent-centric workflow loop showing when to run workset next
- Content stays in English and remains correct for the kano-backlog CLI
- No major duplication with demo root README

# Risks / Dependencies

Over-promising capabilities; keep the snippet scoped to file-first workflow and CLI commands.

# Worklog

2026-01-15 01:13 [agent=copilot] Created item
2026-01-15 01:13 [agent=copilot] [model=gpt-5.2] Start updating skill README to be agent-first.
2026-01-15 01:14 [agent=copilot] [model=gpt-5.2] Start updating skill README to be agent-first.
2026-01-15 01:14 [agent=copilot] [model=gpt-5.2] Updated skill README with agent-first quickstart, copy/paste prompt, and workset-next execution loop.
