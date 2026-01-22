---
area: general
created: '2026-01-22'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0287
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: kiro
parent: null
priority: P2
state: Done
tags: []
title: Document embedding pipeline config schema in references
type: Task
uid: 019be460-d711-709f-bd8c-38d4d25c26b2
updated: 2026-01-23
---

# Context

The pipeline configuration (PipelineConfig in pipeline_config.py) supports multiple sections (chunking, tokenizer, embedding, vector) but this schema is only defined in code. Users need reference documentation to configure TOML correctly.

# Goal

Create references/embedding_pipeline.md documenting the TOML configuration schema for the embedding pipeline.

# Approach

1. Create references/embedding_pipeline.md. 2. Document [chunking] section: target_tokens, max_tokens, overlap_tokens. 3. Document [tokenizer] section: adapter (heuristic/tiktoken), model. 4. Document [embedding] section: provider (noop/openai), model, dimension. 5. Document [vector] section: backend (noop/sqlite), path, collection. 6. Provide example TOML snippets for 'Testing/NoOp' and 'Production/OpenAI' profiles.

# Acceptance Criteria

Documentation file exists; covers all 4 config sections; examples are copy-pasteable and valid.

# Risks / Dependencies

None.

# Worklog

2026-01-22 14:25 [agent=antigravity] Created item
2026-01-23 01:42 [agent=kiro] State -> InProgress.
2026-01-23 01:43 [agent=kiro] State -> Done.
