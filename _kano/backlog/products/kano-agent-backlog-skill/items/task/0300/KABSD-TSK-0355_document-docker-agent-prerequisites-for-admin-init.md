---
area: docs
created: '2026-02-02'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0355
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: Done
tags:
- docker
- agents
- init
title: Document Docker/agent prerequisites for admin init
type: Task
uid: 019c1ef0-af8e-7797-bd06-bdb0e87ecab6
updated: 2026-02-02
---

# Context

Docker/OpenClaw container lacks pip/build tools; admin init fails due to missing Python deps. We need explicit guidance for agents in Docker-like environments.

# Goal

Document clear Docker/container prerequisites and agent-friendly steps to run admin init (including when pip is unavailable).

# Approach

Add a Docker/Container guidance block in SKILL.md near Prerequisite install and Backlog initialization, including required deps, recommended container base, and agent prompts. Update AGENTS/CLAUDE templates to include the same short guidance.

# Acceptance Criteria

- SKILL.md documents container prerequisites and a minimal working flow.
- Guidance includes both CLI commands and a suggested agent prompt.
- Templates for AGENTS/CLAUDE mention the container prerequisites succinctly.
- No secrets or system-level package commands are required unless clearly labeled as image-build steps.

# Risks / Dependencies

Risk: Guidance conflicts with security constraints; mitigate by avoiding secret handling and recommending prebuilt image/build-time installs.

# Worklog

2026-02-02 23:20 [agent=opencode] Created item
2026-02-02 23:21 [agent=opencode] Ready: doc update scope and acceptance criteria defined.
2026-02-02 23:21 [agent=opencode] Start: add Docker/agent prerequisites to SKILL.md and templates. [Ready gate validated]
2026-02-02 23:22 [agent=opencode] [model=unknown] Added container/Docker guidance for agents in SKILL.md and templates: require Python+pip, recommend venv install, and fallback to running admin init outside container if pip is unavailable.
2026-02-02 23:22 [agent=opencode] Done: documented Docker/container prerequisites for admin init and agent usage.
