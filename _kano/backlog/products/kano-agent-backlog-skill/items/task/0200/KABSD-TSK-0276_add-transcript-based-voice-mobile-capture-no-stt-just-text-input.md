---
area: workflow
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0276
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0052
priority: P2
state: Proposed
tags:
- voice
- transcript
- mobile
title: Add transcript-based voice/mobile capture (no STT; just text input)
type: Task
uid: 019bde95-cfe8-7427-9eca-a2475f482995
updated: '2026-01-21'
---

# Context

'Voice mode' should be treated as a low-friction input channel, not as 'voice edits the repo'. MVP is transcript text (e.g., iOS dictation -> copy/paste) that goes through the same deterministic inbox capture pipeline.

# Goal

Enable capture of transcript text with channel=voice/mobile and optional kind/topic hints.

# Approach

Extend inbox add to accept text via stdin/file and optionally from clipboard (if feasible). Provide flags for channel and kind (idea/risk/decision/note). Do not implement STT providers or audio upload in the skill.

# Acceptance Criteria

- Transcript text can be ingested and stored as an inbox entry.
- CLI supports setting channel=voice or channel=mobile (or equivalent metadata).
- No audio processing is implemented.
- Same transcript input produces stable, deterministic output filenames/IDs.

# Risks / Dependencies

Risk: Scope creep into speech client/provider work. Mitigation: hard non-goal: no STT/audio.

# Worklog

2026-01-21 11:25 [agent=opencode] Created item