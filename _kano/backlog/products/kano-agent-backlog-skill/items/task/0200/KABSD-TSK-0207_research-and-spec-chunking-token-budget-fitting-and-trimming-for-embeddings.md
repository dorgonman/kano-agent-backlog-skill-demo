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
parent: KABSD-USR-0029
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
updated: 2026-01-16
---

# Context

We need a deterministic chunking and token-budget fitting contract for embeddings. The topic brief notes tokenizer variance, model max-token windows, and the need for stable chunk IDs for incremental indexing.

# Goal

Define an implementable spec for chunking, token-budget fitting, trimming, and tokenizer adapter behavior that can be implemented without ambiguity.

# Approach

Chunking contract:
- Normalization: apply Unicode NFC; normalize newlines to \n; trim trailing whitespace; preserve original text for display via offsets.
- Boundary rules: prefer paragraph boundaries; fall back to sentence boundaries; last resort: hard cut on token budget.
- Overlap: fixed overlap in tokens (e.g., 32) to preserve continuity; overlap applied after boundary selection.
- Chunk IDs: stable hash over (source_id, normalized_text_span, start_char, end_char, version).

Token budget policy:
- Token counting uses a tokenizer adapter; count includes a safety margin (e.g., 5 percent or 16 tokens, whichever is larger).
- If over budget, trim using tail-first for body text, preserve header metadata if present.
- If still over, fall back to hard cut at max_tokens - safety_margin.

Tokenizer adapter:
- Interface provides count(text, model) and max_tokens(model).
- Adapter is selected via config; default is model-agnostic fallback with conservative max_tokens.

MVP validation:
- Case A: short ASCII paragraph under budget -> single chunk, no trim.
- Case B: long English text -> multiple chunks with overlap and stable IDs.
- Case C: CJK text -> token inflation handled, trimming respects safety margin.

# Acceptance Criteria

- Contract specifies normalization, boundary rules, overlap behavior, chunk ID inputs, and deterministic ordering.
- Token budget rules specify counting, safety margin, trimming order, and hard-cut fallback.
- Tokenizer adapter interface and config selection described.
- MVP checklist includes the three cases above with expected outcomes.

# Risks / Dependencies

- Tokenizer mismatch across models can undercount tokens.
- CJK token inflation can reduce effective context.
- Over-trimming can drop salient context.
- Per-model max windows may force smallest-window bias unless per-model indexes are used.

# Worklog

2026-01-15 22:43 [agent=copilot] [model=Claude-Haiku-4.5] Created item and populated Ready gate (Context, Goal, Approach, Acceptance Criteria, Risks)
2026-01-16 00:00 [agent=copilot] [model=GPT-5.2] Corrected model attribution (previous entry was inaccurate)
2026-01-16 07:23 [agent=codex] [model=unknown] Implementation plan to make the spec implementable: (1) finalize deterministic chunking contract (inputs, chunk_id/chunk_hash rules, versioning, rebuild triggers) and align with TSK-0056 metadata schema + 2-3 worked examples; (2) migrate repo-level chunking package into skill architecture: core models/config -> src/kano_backlog_core, pipeline/use-cases -> src/kano_backlog_ops, tokenizer adapters -> src/kano_backlog_adapters; (3) expose CLI entrypoints via src/kano_backlog_cli/commands and scripts/kano-backlog; (4) port property-based tests under skills/kano-agent-backlog-skill/tests and verify deterministic outputs; (5) update README/REFERENCE with CLI usage and config. Scope remains local-first only; no server runtime.
2026-01-16 22:33 [agent=codex] [model=unknown] Pulled topic context from 'embedding-preprocessing-and-vector-backend-research' (brief + synthesis). Proceeding to document chunking/token-budget contract, trimming policy, and MVP validation steps in this task.
2026-01-16 22:38 [agent=codex] [model=unknown] Expanded Ready-gate sections with implementable chunking/token-budget contract and MVP validation checklist from topic synthesis.
2026-01-16 22:59 [agent=codex] [model=gpt-5.2-codex] Opened implementation task KABSD-TSK-0233 for chunking MVP per this spec.
2026-01-16 23:02 [agent=codex] [model=gpt-5.2-codex] Created user story KABSD-USR-0029 to group chunking/token-budget MVP tasks.
2026-01-16 23:08 [agent=codex] [model=gpt-5.2-codex] Parent updated: null -> KABSD-USR-0029.
