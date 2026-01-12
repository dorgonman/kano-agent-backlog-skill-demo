---
area: general
created: '2026-01-13'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0189
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0031
priority: P2
state: Done
tags: []
title: Ensure worklog entries record model (default unknown) and warn when missing
type: Task
uid: 019bb346-7d37-73a1-b511-31bd59632039
updated: 2026-01-13
---

# Context

Worklog entries currently support an optional [model=...] tag, but key write paths (state transition, update-state, worklog append) do not consistently populate it. Some agents cannot deterministically know their model, so we must avoid encouraging guessing.

# Goal

1) Ensure script-generated worklog entries always include a model tag; 2) Default to model=unknown when not provided; 3) Emit a warning when model is missing so users can fix their environment/config.

# Approach

- Add a single model-resolution helper that prefers explicit --model, then env vars (KANO_AGENT_MODEL/KANO_MODEL), else 'unknown'.
- Update kano-backlog CLI commands (worklog append, state transition, workitem update-state) to accept --model and warn when falling back to unknown.
- Update core/ops worklog write paths so state transitions and ops update-state include model tag consistently.

# Acceptance Criteria

- kano-backlog worklog append writes lines containing [model=...] (unknown if not supplied).
- kano-backlog state transition writes worklog lines containing [model=...].
- kano-backlog workitem update-state writes worklog lines containing [model=...].
- When --model is omitted and env vars are absent, the CLI prints a warning to stderr.
- Documentation notes: do not guess model; leave unknown if not deterministically known.

# Risks / Dependencies

- Risk: some existing callers rely on defaults; mitigation: keep --model optional and only warn.
- Risk: noisy worklog entries with unknown; mitigation: allow env var injection so agents can provide it when available.

# Worklog

2026-01-13 01:34 [agent=codex-cli] Created item
2026-01-13 01:42 [agent=codex-cli] Start: implement model recording (default unknown + warning) in worklog write paths.
2026-01-13 01:49 [agent=codex-cli] [model=unknown] Implemented model attribution on worklog write paths: added --model to state transition and workitem update-state, defaulted to model=unknown with warning when missing, and ensured worklog append always records a model tag. Updated SKILL.md guidance.
