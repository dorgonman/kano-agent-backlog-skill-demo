---
area: rag
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0244
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-USR-0032
priority: P1
state: Done
tags:
- tokenizer
- tiktoken
- openai
title: Implement tiktoken tokenizer adapter (optional dependency)
type: Task
uid: 019bcbf5-b9e5-74fc-b027-61c3682aa072
updated: '2026-01-26'
---

# Context

For OpenAI embedding models, tiktoken is the authoritative tokenizer for token counting. Heuristic counting is insufficient for accurate budget enforcement and cost estimation.

# Goal

Provide a tokenizer adapter that uses tiktoken to count tokens and resolve model max token windows for OpenAI embedding models.

# Approach

Add an optional tiktoken-based adapter that is only imported when available. Map known OpenAI embedding model names to encoding and window limits (with config overrides). Return TokenCount with is_exact=true and a stable tokenizer_id.

# Acceptance Criteria

- Adapter can be selected via config (tokenizer.adapter=tiktoken). - When tiktoken is installed, counts are returned deterministically and marked exact. - When tiktoken is missing, a clear error is raised or fallback behavior is explicit and tested.

# Risks / Dependencies

tiktoken availability varies by platform; keep it optional and do not break default installs.

# Worklog

2026-01-17 20:37 [agent=copilot] [model=unknown] Created item
2026-01-19 03:19 [agent=opencode] [model=unknown] Not started; tokenizer adapter already exists (kano_backlog_core.tokenizer.TiktokenAdapter). Evaluate whether this task is redundant or should be revised to cover HF adapter.
2026-01-26 09:34 [agent=opencode] State -> Done.
2026-01-26 09:34 [agent=opencode] [model=unknown] Implementation already exists: TiktokenAdapter fully implemented in src/kano_backlog_core/tokenizer.py (lines 352-486) with encoding resolution, token counting, and max_tokens support. Task is complete.