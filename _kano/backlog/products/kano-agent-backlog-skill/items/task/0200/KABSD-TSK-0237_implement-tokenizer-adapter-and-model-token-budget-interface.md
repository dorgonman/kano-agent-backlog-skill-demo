---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0237
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: KABSD-USR-0029
priority: P2
state: InProgress
tags: []
title: Implement tokenizer adapter and model token budget interface
type: Task
uid: 019bc76b-38c9-7350-90da-f4f5dec60e8f
updated: '2026-01-17'
---

# Context

Provide a tokenizer adapter that can count tokens and report max token budget per model.

# Goal

Expose a stable interface used by chunking/token-budget logic.

# Approach

- Define adapter interface (count, max_tokens).
- Implement default fallback adapter and model-specific hooks.
- Add minimal unit tests.

# Acceptance Criteria

- Interface exists and returns deterministic counts.
- Supports model max token lookup with sensible defaults.
- Unit tests cover at least two model configurations.

# Risks / Dependencies

Tokenizer backend availability may vary; default must be conservative.

# Worklog

2026-01-16 23:27 [agent=codex] [model=unknown] Created item
2026-01-16 23:28 [agent=codex] [model=gpt-5.2-codex] Parent updated: null -> KABSD-USR-0029.
2026-01-17 09:51 [agent=codex] [model=unknown] State -> InProgress.
2026-01-17 11:08 [agent=codex] [model=gpt-5.2-codex] Implemented tokenizer adapter core in kano_backlog_core.tokenizer with heuristic adapter, TokenCount model, model max-token resolver, and adapter resolver; exported new API via kano_backlog_core.__init__.