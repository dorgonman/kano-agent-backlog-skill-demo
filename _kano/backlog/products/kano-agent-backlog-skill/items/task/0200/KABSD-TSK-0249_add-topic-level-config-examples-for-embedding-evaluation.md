---
area: research
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0249
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-USR-0033
priority: P2
state: Proposed
tags:
- config
- topic
- examples
title: Add topic-level config examples for embedding evaluation
type: Task
uid: 019bcbf6-a657-76c3-86f2-7e7df17faf5c
updated: '2026-01-17'
---

# Context

We want to evaluate different embedders/tokenizers/vector backends without changing product defaults. Topic-level config is the right place for short-lived experiment knobs.

# Goal

Provide one or more topic config.toml examples that demonstrate switching pipeline components for evaluation runs.

# Approach

Add a config.toml under the embedding research topic with commented example profiles (e.g., heuristic+noop, tiktoken+openai, huggingface+local). Ensure examples match the schema from TSK-0247 and can be copied into worksets for single-item experiments.

# Acceptance Criteria

- Topic config examples exist and are aligned with the pipeline config schema. - Examples cover at least two alternative implementations and clearly state assumptions and required optional deps.

# Risks / Dependencies

Topic config may go stale; keep examples minimal and update alongside schema changes.

# Worklog

2026-01-17 20:38 [agent=copilot] [model=unknown] Created item