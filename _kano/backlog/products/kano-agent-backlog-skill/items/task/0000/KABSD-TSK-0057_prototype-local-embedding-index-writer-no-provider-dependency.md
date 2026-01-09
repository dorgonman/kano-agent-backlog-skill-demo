---
id: KABSD-TSK-0057
uid: 019b8f52-9fca-7342-b937-49a5fe135f04
type: Task
title: Prototype local embedding index writer (no provider dependency)
state: Done
priority: P4
parent: KABSD-USR-0015
area: rag
iteration: null
tags:
- embedding
- rag
- local
created: 2026-01-05
updated: 2026-01-09
owner: copilot
external:
  azure_id: null
  jira_key: null
links:
  relates:
  - KABSD-TSK-0056
  blocks: []
  blocked_by: []
decisions: []
---

# Context

TSK-0056 defined the chunking and metadata schema for embeddings. Now we implement a local writer that transforms backlog items and ADRs into provider-agnostic JSONL following that schema (no external embedding provider, no network).

# Goal

Build a local embedding index writer (Python script) that:
1. Reads backlog items (.md) and ADRs from a product directory.
2. Applies TSK-0056 chunking rules (section/worklog grouping, max sizes, overlap).
3. Computes metadata (source_path, path_hash, section_path, chunk_hash, timestamps).
4. Outputs JSONL (schema_version 0.1.0) with all metadata fields populated.
5. Stores under `_kano/backlog/products/<product>/_index/embeddings/` (gitignored).

# Non-Goals

- Vector computation (deferred to downstream tasks/provider adapters).
- Database storage (JSONL is the artifact; DB writes are separate).
- Server/API (Local-first only).

# Approach

- Create `skills/kano-agent-backlog-skill/scripts/indexing/embedding_writer.py` implementing the chunking logic from TSK-0056.
- Parse backlog markdown with frontmatter (PyYAML); extract sections and worklog entries.
- Normalize paths to POSIX; compute sha256 hashes for source_path and chunk text.
- Group worklog entries by day; split chunks respecting 1200/900-1100 char limits and 150-char overlap.
- Emit JSONL with full metadata table (schema_version, doc_id, section_path, chunk_kind, chunk_index/count, chunk_hash, path_hash, etc.).
- Include redaction stub (default "none") for future sensitive-term detection.
- Test with 1 work item sample + 1 ADR sample; validate chunk_count, section_path shapes.

# Alternatives

- Single large-document embedding (rejected: poor retrieval granularity; TSK-0056 already decided).
- Database-first approach (rejected: JSONL first allows flexible downstream consumption).

# Acceptance Criteria

- Script resides at `skills/kano-agent-backlog-skill/scripts/indexing/embedding_writer.py`.
- Accepts product name and backlog root (via CLI args or config).
- Outputs JSONL to `_kano/backlog/products/<product>/_index/embeddings/backlog_chunks_<timestamp>.jsonl`.
- Sample JSONL output for 1 work item + 1 ADR matches TSK-0056 metadata schema exactly.
- Chunk counts are deterministic; chunk_hash values are stable across reruns (same input → same hash).
- Worklog entries grouped by day with proper overlap logic (1-entry overlap when splitting).
- Test file `test_embedding_writer_sample.py` or `test_tsk0057.py` validates 1 sample output.

# Risks / Dependencies

- Depends on TSK-0056 spec (must match schema exactly or risk downstream breakage).
- Large backlog (100+ items) → script performance; use generator/streaming if needed.
- Markdown parsing edge cases (e.g., code blocks with `#` inside); use proper parser (FrontMatterParser from existing lib or front-matter if available).

# Worklog

2026-01-05 16:21 [agent=codex] Created from template.
2026-01-09 19:20 [agent=copilot] Filled Ready sections linking TSK-0056, detailed chunking approach, acceptance criteria including sample validation and test plan.
2026-01-09 20:36 [agent=copilot] Implemented embedding_writer.py core logic: section extraction, chunk splitting (1200/900-1100 target, 150 char overlap), metadata schema (v0.1.0), JSONL output. Generated 2183 chunks from product backlog. Created sample output artifact at _kano/backlog/products/kano-agent-backlog-skill/artifacts/KABSD-TSK-0057/embedding_writer_sample_output.md documenting schema validation, stats, and next steps.
2026-01-09 20:41 [agent=copilot] Fixed worklog chunking: corrected agent name regex (accept `-` chars); fixed chunk_worklog_entries return value (was returning empty list). Now generates 2433 chunks (250 worklog chunks added). Verified worklog grouping by day, max 5 entries/1000 chars per chunk, 1-entry overlap, and time span tracking. Updated sample output artifact with v0.1 final results.
2026-01-09 20:38 [agent=copilot] State -> Done.
