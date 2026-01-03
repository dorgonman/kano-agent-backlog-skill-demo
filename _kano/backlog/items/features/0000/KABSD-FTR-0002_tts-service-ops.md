---
id: KABSD-FTR-0002
type: Feature
title: "TTS service operations"
state: Proposed
priority: P1
parent: KABSD-EPIC-0001
area: speech
iteration: null
tags: ["tts", "speech"]
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

We need a stable way to stand up and test multiple TTS services for evaluation.

# Goal

Provide a minimal, repeatable TTS service flow with clear launch and test steps.

# Non-Goals

- Training or fine-tuning TTS models.
- Production hardening and scaling.

# Approach

Define the TTS service list, required configs, and a minimal test path.

# Links

- Epic: [[KABSD-EPIC-0001_quboto-mvp 1|KABSD-EPIC-0001 Quboto_MVP]]
- UserStory: [[KABSD-USR-0002_test-tts-flow|KABSD-USR-0002 Test TTS flow locally]]

# Alternatives

- Ad-hoc per-service setup without a shared checklist.

# Acceptance Criteria

- TTS services have a documented minimal setup and test flow.
- A single Task captures the initial service plan.

# Risks / Dependencies

- Service behavior may vary by model/provider, requiring iterative updates.

# Worklog

2026-01-02 11:58 [agent=codex] Created feature under KABSD-EPIC-0001 for TTS work items.

