---
area: infrastructure
created: '2026-01-18'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0257
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0013
priority: P2
state: Ready
tags: []
title: Implement repo-shared active topic state (lock-free)
type: Task
uid: 019bce98-b850-74e4-9959-b1ec62f9f14c
updated: 2026-01-18
---

# Context

Today the active topic per agent is tracked via per-agent text files like _kano/backlog/.cache/worksets/active_topic.<agent>.txt. On a single machine with multiple agents working in the same repo, this is workable but not scalable: it is ad-hoc, hard to enumerate, and does not support richer topic metadata or future extension (e.g., cross-agent participants, status, file refs) without file explosion.

# Goal

Provide a simple, local-first, repo-shared state mechanism for multi-agent collaboration that (1) records each agent's active topic, (2) stores topic metadata in structured JSON, (3) stays readable for humans and agents, and (4) leaves room for future cross-machine synchronization as a spec-only extension.

# Approach

Implement a small state store under _kano/backlog/.cache/worksets/: a single index file state.json plus per-topic JSON documents under topics/<topic_id>.json. Use UUIDv7 for topic IDs. Use existing Kano agent IDs (e.g., codex, copilot, opencode) as stable keys in the index; optionally store a display label. Compute a repo identifier as sha256(normalized absolute repo root) to prevent accidental cross-repo reuse of state. Keep the design lock-free (accept minimal lost-update risk) and without automatic GC. Provide a compatibility layer that can read existing active_topic.<agent>.txt and migrate/write-through into state.json.

# Acceptance Criteria

1) New state format exists at _kano/backlog/.cache/worksets/state.json with version=1, repo metadata, and an agents map where each agent has an active_topic_id (nullable) and updated_at. 2) Topic documents exist at _kano/backlog/.cache/worksets/topics/<topic_id>.json and can be created/updated/deleted/listed deterministically. 3) Topic CLI operations that read/write active topic (topic switch/show) use the new store and do not crash if legacy active_topic.<agent>.txt exists (migration path works). 4) No background lock/lease or auto-GC is introduced; manual cleanup command is allowed. 5) The implementation is local-first only (no server runtime).

# Risks / Dependencies

Lock-free writes can lose the last writer in rare concurrent updates; mitigate by keeping writes small and by optionally doing atomic replace writes. Path normalization differences on Windows (case/UNC) could affect repo_id; implement deterministic normalization.

# Worklog

2026-01-18 08:54 [agent=codex] [model=unknown] Created item
2026-01-18 08:54 [agent=codex] [model=unknown] Ready: implement repo-shared active topic state store (state.json + topics/*.json) with legacy active_topic.* migration.
2026-01-18 09:17 [agent=codex] [model=unknown] Ready: implement repo-shared active topic state store (state.json + topics/*.json) with legacy active_topic.* migration.
