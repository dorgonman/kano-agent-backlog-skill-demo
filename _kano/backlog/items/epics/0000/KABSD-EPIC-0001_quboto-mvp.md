---
id: KABSD-EPIC-0001
type: Epic
title: "Quboto_MVP"
state: Proposed
priority: P1
parent: null
area: project
iteration: null
tags: ["mvp"]
created: 2026-01-02
updated: 2026-01-02
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

We want a minimal, working baseline for Quboto that includes planning workflow
and reproducible setup.

# Goal

Define the MVP scope and track features needed to reach it.

# Non-Goals

- Full production hardening.
- External PM system integration.

# Approach

Create and link Features and UserStories under this Epic.

# Links

- Feature: [[KABSD-FTR-0001_local-backlog-system|KABSD-FTR-0001 Local-first backlog system]]
- Feature: [[KABSD-FTR-0002_tts-service-ops|KABSD-FTR-0002 TTS service operations]]
- Feature: [[KABSD-FTR-0003_stt-service-ops|KABSD-FTR-0003 STT service operations]]
- Feature: [[KABSD-FTR-0004_secret-provider-workflow|KABSD-FTR-0004 Secret provider workflow]]
- Feature: [[KABSD-FTR-0005_vllm-litellm-ops|KABSD-FTR-0005 vLLM + LiteLLM operations]]

# Alternatives

- Track in a single flat task list.

# Acceptance Criteria

- MVP scope is captured as Features and UserStories.
- Each downstream Task/Bug links back to this Epic.

# Risks / Dependencies

- Scope creep without Ready gate enforcement.

# Worklog

2026-01-02 10:10 [agent=codex] Created epic from user request.
2026-01-02 11:20 [agent=codex] Established local-first backlog system with per-type folders and Obsidian MOC links (ADR-0001).
2026-01-02 11:55 [agent=codex] Added initial TTS, STT, secret provider, and vLLM/LiteLLM features per user request.

