---
area: embedding
created: '2026-01-27'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0315
iteration: 0.0.2
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0061
priority: P2
state: Done
tags: []
title: Support vLLM and OpenAI-compatible embedding APIs
type: Task
uid: 019bfb8c-9c7c-77be-81fb-7b51ce811fd9
updated: '2026-01-27'
---

# Context

Current OpenAIEmbeddingAdapter only supports official OpenAI API. Users want to use self-hosted embedding services (vLLM, Ollama) for privacy, cost savings, and multilingual support.

# Goal

Support vLLM and other OpenAI-compatible embedding APIs via base_url parameter

# Approach

Add base_url and dimension parameters to OpenAIEmbeddingAdapter; Pass to OpenAI client constructor; Update factory to pass parameters from config

# Acceptance Criteria

base_url parameter works with vLLM; dimension parameter supports custom models; Config example in docs; vLLM setup guide created

# Risks / Dependencies

None - backward compatible (base_url optional)

# Worklog

2026-01-27 02:24 [agent=opencode] Created item [Parent Ready gate validated]
2026-01-27 02:26 [agent=opencode] State -> Done.
2026-01-27 02:26 [agent=opencode] State -> Done.
2026-01-27 02:26 [agent=opencode] [model=unknown] Added base_url and dimension parameters to OpenAIEmbeddingAdapter. Updated factory to pass parameters from config. Tested with vLLM configuration. Created comprehensive vLLM setup guide. Commit: feat(embedding): support vLLM and OpenAI-compatible APIs