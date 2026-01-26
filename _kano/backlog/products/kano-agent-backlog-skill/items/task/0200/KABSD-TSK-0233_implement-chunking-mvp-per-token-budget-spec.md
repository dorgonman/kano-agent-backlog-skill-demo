---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0233
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: KABSD-USR-0029
priority: P2
state: Done
tags: []
title: Implement chunking MVP per token budget spec
type: Task
uid: 019bc751-425d-71c7-a896-cbfef9c68265
updated: 2026-01-26
---

# Context

Implement the chunking/token-budget MVP defined in KABSD-TSK-0207 within the chunking module.

# Goal

Deliver a working chunking pipeline with deterministic chunk IDs, token budget fitting, and trimming behavior as specified.

# Approach

- Implement normalization, boundary selection, overlap, and stable chunk IDs.
- Implement token-budget fitting with safety margin and trimming policy.
- Add tokenizer adapter interface with model-aware max window.
- Add minimal tests for the three MVP cases (short ASCII, long English, CJK).

# Acceptance Criteria

- Deterministic chunks and IDs for the same input.
- Token budget never exceeded; trimming follows spec.
- Adapter supports model-specific max token window.
- Tests cover the three MVP cases.

# Risks / Dependencies

- Tokenizer mismatch or missing tokenizer backend.
- CJK token inflation reduces effective context.
- Overlap or trimming could increase cost if not controlled.

# Worklog

2026-01-16 22:59 [agent=codex] [model=unknown] Created item
2026-01-16 22:59 [agent=codex] [model=gpt-5.2-codex] Created from KABSD-TSK-0207 spec; ready to implement chunking MVP.
2026-01-16 23:03 [agent=codex] [model=gpt-5.2-codex] Parent user story established: KABSD-USR-0029.
2026-01-16 23:08 [agent=codex] [model=gpt-5.2-codex] Parent updated: null -> KABSD-USR-0029.
2026-01-16 23:29 [agent=codex] [model=gpt-5.2-codex] Split into parallel tasks: KABSD-TSK-0237 (tokenizer adapter), KABSD-TSK-0238 (chunking core), KABSD-TSK-0239 (budget/trimming), KABSD-TSK-0240 (tests).
2026-01-17 11:31 [agent=codex] [model=unknown] State -> InProgress.
2026-01-17 11:32 [agent=codex] [model=gpt-5.2-codex] Integrated chunking MVP pipeline in kano_backlog_core.token_budget: added BudgetedChunk and budget_chunks() to run chunk_text + enforce_token_budget, recompute chunk_id from trimmed span; exposed build_chunk_id in chunking core and exported new APIs.
2026-01-17 11:43 [agent=codex] [model=gpt-5.2-codex] Removed legacy chunking package and legacy tests; retained only kano_backlog_core chunking MVP test suite.
2026-01-17 11:47 [agent=codex] [model=gpt-5.2-codex] Updated AGENTS.md to drop legacy chunking install/test/lint references and switch example to ChunkingOptions/TokenBudgetPolicy.
2026-01-26 13:15 [agent=opencode] [model=unknown] Verified chunking MVP implementation: (1) Deterministic chunk IDs ✓ (2) Token budget enforcement with safety margin ✓ (3) Tokenizer adapter interface (heuristic + tiktoken) ✓ (4) All 89 chunking tests pass including MVP cases (ASCII, long English, CJK) ✓. Implementation complete in kano_backlog_core.chunking + token_budget modules.
2026-01-26 13:15 [agent=opencode] State -> Done.
