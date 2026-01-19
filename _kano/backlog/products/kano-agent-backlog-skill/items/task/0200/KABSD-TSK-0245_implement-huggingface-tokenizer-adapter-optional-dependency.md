---
area: rag
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0245
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-USR-0032
priority: P2
state: Proposed
tags:
- tokenizer
- huggingface
- local
title: Implement HuggingFace tokenizer adapter (optional dependency)
type: Task
uid: 019bcbf5-e80d-721b-ba2f-f3956f57e628
updated: '2026-01-17'
---

# Context

Local-first embedding options (sentence-transformers, BGE/GTE families) use HuggingFace tokenizers. Accurate token counting and window enforcement requires using the same tokenizer as the model.

# Goal

Provide a tokenizer adapter backed by HuggingFace tokenizers that can count tokens and report max token windows for local models.

# Approach

Add an optional adapter that loads a tokenizer by model name/path and counts tokens deterministically. Expose max_tokens via config override (since model config may not expose it consistently). Ensure adapter returns TokenCount with is_exact=true when using HF tokenization.

# Acceptance Criteria

- Adapter can be selected via config (tokenizer.adapter=huggingface). - Token counting is deterministic for a given tokenizer/model. - Tests either run with the dependency installed or skip gracefully with a clear reason.

# Risks / Dependencies

HuggingFace tokenizers may download files; ensure local cache behavior is documented and avoid network in default test runs.

# Worklog

2026-01-17 20:37 [agent=copilot] [model=unknown] Created item