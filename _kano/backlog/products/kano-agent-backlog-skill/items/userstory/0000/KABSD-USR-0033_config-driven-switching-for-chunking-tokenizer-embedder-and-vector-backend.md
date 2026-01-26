---
area: infra
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-USR-0033
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: KABSD-FTR-0042
priority: P0
state: Done
tags:
- config
- chunking
- tokenizer
- embedding
- vector
title: Config-driven switching for chunking, tokenizer, embedder, and vector backend
type: UserStory
uid: 019bcbf4-3775-7735-b414-41d699e327ba
updated: 2026-01-26
---

# Context

Evaluation requires rapidly switching implementations (different chunking settings, tokenizers, embedding providers, and vector backends). The repo already supports layered TOML config (defaults -> product -> topic/workset), but the embedding/vector pipeline selection is not standardized into a single schema.

# Goal

As a developer, I can switch chunking/tokenizer/embedder/vector implementations via TOML config without code changes, enabling repeatable benchmarking and experiments.

# Approach

Define a minimal config schema: [chunking] options, [tokenizer] adapter/model/max_tokens, [embedding] adapter/model/dims, [vector] backend/path/metric. Implement resolvers that produce concrete adapters/options. Ensure topic-level overrides can be used for experiments without touching product defaults.

# Acceptance Criteria

- A documented config schema exists and is validated in code. - A single command or code path can build an effective pipeline from config and run end-to-end on a small sample. - Topic config overrides can switch providers/settings without code edits.

# Risks / Dependencies

Config drift across layers can be confusing; provide a deterministic effective-config view or debug output. Some combinations (dims/metric/window) are incompatible; validate early with clear errors.

# Worklog

2026-01-17 20:35 [agent=copilot] [model=unknown] Created item
2026-01-26 09:35 [agent=opencode] [model=unknown] Config infrastructure review: tokenizer_config.py (TOML-based with validation), pipeline_config.py (integrates chunking/tokenizer/embedding/vector), and config.py (layered resolution) all exist. Checking acceptance criteria against implementation.
2026-01-26 09:35 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-01-26 10:06 [agent=opencode] [model=unknown] Acceptance criteria verified: (1) Config schema exists and validated (tokenizer_config.py + pipeline_config.py with comprehensive tests passing), (2) CLI command 'kano-backlog config pipeline' validates end-to-end pipeline from config, (3) Topic-level config overrides supported via layered resolution. All criteria met.