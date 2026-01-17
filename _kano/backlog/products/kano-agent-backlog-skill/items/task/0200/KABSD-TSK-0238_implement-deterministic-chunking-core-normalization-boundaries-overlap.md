---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0238
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: KABSD-USR-0029
priority: P2
state: InProgress
tags: []
title: Implement deterministic chunking core (normalization, boundaries, overlap)
type: Task
uid: 019bc76b-4ee7-763e-b4f0-bc888d1daf43
updated: '2026-01-17'
---

# Context

Implement deterministic chunking with normalization, boundary selection, and overlap per KABSD-TSK-0207.

# Goal

Produce stable chunk boundaries and IDs given the same input.

# Approach

- Normalize input (Unicode NFC, newline normalization, trim trailing whitespace).
- Apply boundary selection (paragraph -> sentence -> hard cut).
- Apply fixed overlap in tokens.
- Generate stable chunk IDs using source_id + span + version.

# Acceptance Criteria

- Same input yields identical chunk boundaries and IDs.
- Overlap applied correctly.
- Boundary selection falls back deterministically.

# Risks / Dependencies

Sentence boundary heuristics may be language-biased; keep deterministic behavior.

# Worklog

2026-01-16 23:27 [agent=codex] [model=unknown] Created item
2026-01-16 23:28 [agent=codex] [model=gpt-5.2-codex] Parent updated: null -> KABSD-USR-0029.
2026-01-16 23:54 [agent=codex] [model=unknown] State -> InProgress.
2026-01-17 08:08 [agent=codex] [model=gpt-5.2-codex] Implemented deterministic chunking core in kano_backlog_core.chunking (normalize_text, token_spans, chunk_text). Boundary selection is paragraph -> sentence -> hard cut; overlap applied in token spans with safeguards to ensure progress when chunk_len <= overlap.