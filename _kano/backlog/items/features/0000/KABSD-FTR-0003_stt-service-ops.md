---
id: KABSD-FTR-0003
type: Feature
title: "STT service operations"
state: Proposed
priority: P1
parent: KABSD-EPIC-0001
area: speech
iteration: null
tags: ["stt", "speech"]
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

We need a stable way to stand up and test STT services for evaluation.

# Goal

Provide a minimal, repeatable STT service flow with clear launch and test steps.

# Non-Goals

- Training or fine-tuning STT models.
- Production hardening and scaling.

# Approach

Define the STT model list, required configs, and a minimal test path.

# Links

- Epic: [[KABSD-EPIC-0001_quboto-mvp 1|KABSD-EPIC-0001 Quboto_MVP]]
- UserStory: [[KABSD-USR-0003_test-stt-flow|KABSD-USR-0003 Test STT flow locally]]

# Alternatives

- Ad-hoc per-model setup without a shared checklist.

# Acceptance Criteria

- STT services have a documented minimal setup and test flow.
- A single Task captures the initial model plan.

# Risks / Dependencies

- Model performance may vary by hardware and audio pipeline.

# Worklog

2026-01-02 11:59 [agent=codex] Created feature under KABSD-EPIC-0001 for STT work items.

