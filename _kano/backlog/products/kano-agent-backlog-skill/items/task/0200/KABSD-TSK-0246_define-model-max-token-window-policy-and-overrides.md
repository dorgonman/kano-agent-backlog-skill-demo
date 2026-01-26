---
area: infra
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0246
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-USR-0032
priority: P2
state: Done
tags:
- tokenizer
- max-tokens
- policy
title: Define model max-token window policy and overrides
type: Task
uid: 019bcbf6-13e1-711b-9f64-7cfeeab4e55e
updated: '2026-01-26'
---

# Context

Different embedding models have different max input windows (often ~512 for BERT-derived encoders, sometimes ~8k for newer encoders). To keep chunking model-independent and enforce budgets safely, we need a consistent source of truth for max token windows with overrides.

# Goal

Define and implement a consistent max-tokens resolution policy for models, including config overrides and defaults.

# Approach

Maintain a small mapping for known model families, support explicit overrides in config (tokenizer.max_tokens or embedding.max_tokens), and provide a default conservative fallback. Document how window limits are enforced and how safety margins interact with max_tokens.

# Acceptance Criteria

- A documented policy exists for resolving max tokens per model/provider. - Config overrides work and are validated. - Default behavior is conservative and does not exceed provider limits.

# Risks / Dependencies

Incorrect max token windows can cause provider errors or silent truncation; require telemetry that records max_tokens used and whether trimming occurred.

# Worklog

2026-01-17 20:37 [agent=copilot] [model=unknown] Created item
2026-01-26 09:34 [agent=opencode] State -> Done.
2026-01-26 09:34 [agent=opencode] [model=unknown] Implementation already exists: resolve_model_max_tokens() function with MODEL_MAX_TOKENS mapping (lines 488-498) supports overrides and defaults. Policy is implemented and working.