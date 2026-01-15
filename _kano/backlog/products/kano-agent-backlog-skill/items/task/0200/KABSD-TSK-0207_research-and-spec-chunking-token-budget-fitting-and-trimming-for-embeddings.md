---
area: general
created: '2026-01-15'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0207
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Proposed
tags:
- research
- embedding
- chunking
- token-budget
title: Research and spec chunking, token budget fitting, and trimming for embeddings
type: Task
uid: 019bc21c-6e9c-765a-877f-994bacdf5002
updated: '2026-01-15'
---

# Context

Requested item ID in brief: KABSD-TSK-XXXX_research-and-spec_chunking-token-budget-and-trimming-for-embedding. Current vector index research assumes chunks and token limits are already handled; without a deterministic preproce/skssing spec, downstream vector backends will index low-quality data. This task defines the canonical preprocessing layer before any embedding or index backend selection.

# Goal

Define a model-agnostic, deterministic preprocessing spec that covers canonical chunking, token budget fitting (split-first), last-resort elision, dual dense/sparse views, and a stable output contract for index backends.

# Approach

1) Draft canonical chunking rules (structure-first: headings/paragraphs/lists/code fences with special handling; length targets and overlaps). 2) Define token budget fitting with a TokenCounter adapter (tiktoken/HF/heuristic), count method metadata, and recursive split strategy; explicitly forbid default tail truncation. 3) Define elision rules for un-splittable blobs (minified/log/base64) with reversible placeholders and audit metadata. 4) Define dense vs sparse view transformations and allowable normalization. 5) Define output contract fields (chunk_id, chunk_hash, chunking_version, source_ref, dense_text, sparse_text, token_count, token_counter_id, token_count_method, metadata) and index rebuild triggers (model id / chunking_version / policy changes). 6) Include 2–3 worked examples (Markdown with code fence, log blob).

# Acceptance Criteria

- A spec document suitable for an ADR is produced, including 2–3 concrete examples (Markdown + code fence + log blob). - For identical input, canonical chunking yields stable chunk_id and chunk_hash on re-run. - Over-limit handling always splits before any truncation. - Elision is reversible/auditable with complete metadata and original text preserved. - Output contract explicitly lists required fields and rebuild triggers.

# Risks / Dependencies

Risk: tokenizer availability and cross-platform differences. Mitigation: allow exact and approximate counters with explicit metadata; design for deterministic fallback. Dependency: later embedding provider integration should follow this spec.

# Worklog

2026-01-15 22:43 [agent=copilot] [model=Claude-Haiku-4.5] Created item and populated Ready gate (Context, Goal, Approach, Acceptance Criteria, Risks)