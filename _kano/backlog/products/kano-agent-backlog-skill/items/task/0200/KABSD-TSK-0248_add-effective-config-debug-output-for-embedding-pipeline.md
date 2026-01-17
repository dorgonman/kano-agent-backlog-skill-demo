---
area: infra
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0248
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-USR-0033
priority: P1
state: Proposed
tags:
- config
- debug
- effective-config
title: Add effective-config debug output for embedding pipeline
type: Task
uid: 019bcbf6-74c8-7771-9c20-06be9d47d0b0
updated: '2026-01-17'
---

# Context

When multiple config layers apply (defaults, product, topic, workset), it is hard to know which settings are active during a benchmark run. This reduces reproducibility and makes it difficult to compare results.

# Goal

Provide a deterministic way to show the effective embedding pipeline config used for a run.

# Approach

Add a CLI or helper that prints the effective config for chunking/tokenizer/embedding/vector. Ensure it includes provenance (which layer set each key) if feasible, or at least a resolved snapshot for logging into benchmark reports.

# Acceptance Criteria

- There is a command or function that outputs the resolved config snapshot used by the pipeline. - Benchmark reports can include this snapshot verbatim. - Output is deterministic and stable for diffing.

# Risks / Dependencies

Full provenance tracking may be complex; start with snapshot output and add provenance later if needed.

# Worklog

2026-01-17 20:38 [agent=copilot] [model=unknown] Created item