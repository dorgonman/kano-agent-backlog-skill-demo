---
area: research
created: '2026-01-17'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0250
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-USR-0034
priority: P1
state: Proposed
tags:
- benchmark
- corpus
- cjk
title: Define benchmark corpus and scripted query set (English + CJK)
type: Task
uid: 019bcbf6-e53b-7623-a185-ba4ab53b8fbc
updated: '2026-01-17'
---

# Context

A benchmark needs a small, deterministic corpus and query set to compare chunking/tokenizer/embedder variants. The topic identified CJK token inflation as a risk, so the corpus must include representative CJK content.

# Goal

Create a minimal benchmark corpus and a scripted query set that can be reused across runs and providers.

# Approach

Select a small set of documents (e.g., 5-10) covering: short English, long English, pure CJK, mixed English+CJK, and punctuation-heavy text. Define a set of queries and expected top-k doc/chunk candidates for qualitative checks. Store corpus under a test/fixtures or artifacts path and keep it stable.

# Acceptance Criteria

- Corpus and query set are defined and checked into the repo or stored as an artifact with a stable reference. - Each corpus entry has a stable source_id and language metadata. - Queries include at least one cross-language candidate to inform the ADR decision.

# Risks / Dependencies

Expected results may change across embedders; keep assertions qualitative (candidate sets) rather than strict rankings.

# Worklog

2026-01-17 20:38 [agent=copilot] [model=unknown] Created item