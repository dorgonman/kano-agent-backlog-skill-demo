---
area: rag
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-USR-0032
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0042
priority: P1
state: Done
tags:
- tokenizer
- tiktoken
- huggingface
- telemetry
title: Tokenizer adapters for accurate token counting (OpenAI and local)
type: UserStory
uid: 019bcbf3-fc05-7137-a149-58e498656490
updated: '2026-01-26'
---

# Context

The current tokenizer implementation is heuristic and may undercount or overcount compared to real model tokenizers. To make chunking budgets, cost estimates, and truncation behavior credible, we need provider-specific token counting adapters.

# Goal

As a developer, I can select a tokenizer adapter (heuristic, OpenAI tiktoken, HuggingFace) that reports token counts and max token windows so budgets and telemetry reflect real models.

# Approach

Implement optional adapters: (1) OpenAI tiktoken-based adapter for OpenAI embedding models; (2) HuggingFace tokenizer-based adapter for local sentence-transformers style models; (3) keep heuristic as fallback. Expose adapter selection via config and return TokenCount with method, tokenizer_id, and is_exact flags.

# Acceptance Criteria

- Tokenizer adapters can be resolved by name via config. - TokenCount includes method/tokenizer_id/is_exact and is surfaced in trimming telemetry. - Tests cover at least one deterministic example per adapter (or skip gracefully when optional deps are not installed).

# Risks / Dependencies

Optional dependencies may not be available on all platforms; implement graceful fallback and clear error messages. Token window metadata differs per model and may require a curated table or per-tokenizer introspection.

# Worklog

2026-01-17 20:35 [agent=copilot] [model=unknown] Created item
2026-01-19 03:19 [agent=opencode] [model=unknown] Auto parent sync: child KABSD-TSK-0244 -> Blocked; parent -> InProgress.
2026-01-26 09:34 [agent=opencode] Auto parent sync: child KABSD-TSK-0245 -> Done; parent -> Done.
2026-01-26 09:34 [agent=opencode] Auto parent sync: child KABSD-TSK-0244 -> Done; parent -> Done.
2026-01-26 09:34 [agent=opencode] Auto parent sync: child KABSD-TSK-0246 -> Done; parent -> Done.
2026-01-26 09:34 [agent=opencode] [model=unknown] All child tasks complete: KABSD-TSK-0244 (tiktoken), KABSD-TSK-0245 (HuggingFace), KABSD-TSK-0246 (max-tokens policy) are implemented and working. TokenizerRegistry with fallback chain exists. User story acceptance criteria met.