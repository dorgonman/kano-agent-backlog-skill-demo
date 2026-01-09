# Embedding Chunking and Metadata Schema

**Version:** 0.1.0  
**Task:** KABSD-TSK-0056  
**Date:** 2026-01-09  
**Status:** Draft

## Scope and Principles
- Local-first, deterministic, provider-agnostic output (no server runtime; JSONL only).
- Canonical source is Markdown backlog items and ADRs with frontmatter.
- English-only expectation; redaction hooks apply before emission if sensitive terms are detected.
- Rebuildable: output is derivable solely from files; no external IDs.

## Inputs (Inclusion / Exclusion)
- Include: title, Context, Goal, Approach, Acceptance Criteria, Risks / Dependencies, Non-Goals, Decisions/Links, Worklog.
- Exclude: secrets, credentials, tokens; redact detected secrets instead of dropping the chunk.
- Frontmatter is used for metadata but not embedded as text (except optional header chunk for title/summary).

## Chunking Rules
1) **Normalize source**: POSIX-style `source_path` relative to repo root; compute `path_hash = sha256(source_path)` lowercased hex.
2) **Doc header chunk (optional)**: small chunk with title + one-line summary (from Context first sentence) to aid recall; `chunk_kind=header`, `section_path=item/header`.
3) **Section chunks**:
   - One chunk per top-level section. If a section exceeds **1200 chars**, split on paragraph boundaries aiming for **900-1100 chars** with **150-char overlap** between adjacent chunks to preserve continuity.
   - `section_path` format: `item/context`, `item/goal`, `item/approach`, `item/acceptance_criteria`, `item/risks`, `item/non_goals`, `item/decisions`, `item/links`, `item/other`.
   - Preserve heading text in the chunk body for clarity.
4) **Worklog chunks**:
   - Sort entries ascending by timestamp.
   - Group entries by calendar day, then limit each chunk to **max 5 entries or 1000 chars**, whichever comes first. If a day has more, start a new chunk with **1-entry overlap**.
   - `section_path=item/worklog`, `chunk_kind=worklog`, include `worklog_span_start`/`worklog_span_end` ISO timestamps for the chunk.
5) **ADR chunks**:
   - Apply the same size limits as sections; `section_path` prefixes `adr/` (e.g., `adr/decision`, `adr/context`, `adr/consequences`).
6) **Chunk counts**: `chunk_index` is zero-based per document; `chunk_count` is total chunks for that document.
7) **Hashing**: `chunk_hash = sha256(text)` for incremental rebuild/change detection.

## Metadata Schema
| Field | Type | Description |
| --- | --- | --- |
| schema_version | string | Embedding schema version (e.g., `0.1.0`). |
| doc_id | string | Work item ID or ADR ID (e.g., `KABSD-TSK-0056`, `ADR-0009`). |
| uid | string? | ULID/UUID from frontmatter if present. |
| doctype | string | `item` or `adr`. |
| item_type | string? | `Task`, `Feature`, `UserStory`, etc. (items only). |
| title | string | Document title. |
| state | string? | Current state if available. |
| tags | string[] | Tags from frontmatter (lowercase). |
| parent | string? | Parent work item ID (items only). |
| product | string | Product name resolved from path. |
| source_path | string | POSIX relative path to the source file. |
| path_hash | string | `sha256(source_path)` hex. |
| section_path | string | Logical section path (see rules). |
| chunk_kind | string | `header`, `section`, `worklog`, or `decision`. |
| chunk_index | int | Zero-based chunk position within the document. |
| chunk_count | int | Total chunks for the document. |
| chunk_char_len | int | Character length of the chunk text. |
| chunk_hash | string | `sha256(text)` hex. |
| source_updated | string? | ISO8601 `updated` from frontmatter if present. |
| created_at | string? | ISO8601 `created` from frontmatter if present. |
| worklog_span_start | string? | ISO8601 start timestamp for grouped worklog chunk. |
| worklog_span_end | string? | ISO8601 end timestamp for grouped worklog chunk. |
| language | string | Expected `en`. |
| redaction | string | `none` or short reason if redacted. |

## JSONL Examples
```jsonl
{"text": "Before embedding, we need a consistent chunking and metadata design so retrieval is predictable and rebuildable.", "metadata": {"schema_version": "0.1.0", "doc_id": "KABSD-TSK-0056", "uid": "019b8f52-9fc8-7c94-aa2d-806cacdd9086", "doctype": "item", "item_type": "Task", "title": "Define embedding chunking + metadata schema for backlog items", "state": "InProgress", "tags": ["embedding", "rag", "schema"], "parent": "KABSD-USR-0015", "product": "kano-agent-backlog-skill", "source_path": "_kano/backlog/products/kano-agent-backlog-skill/items/task/0000/KABSD-TSK-0056_define-embedding-chunking-metadata-schema-for-backlog-items.md", "path_hash": "sha256:7d1e2c50d80b4bb6b7f61a0e1f5f91fcb27e0b4e6c4f6e4504c1c8e3f4c3c9b2", "section_path": "item/context", "chunk_kind": "section", "chunk_index": 0, "chunk_count": 3, "chunk_char_len": 121, "chunk_hash": "sha256:8c9c8c4adf7c2629aa3c5bbcd6b0b8e166fdde20b972b58c46431ebf3b0f6b9c", "source_updated": "2026-01-09T18:05:00Z", "created_at": "2026-01-05T00:00:00Z", "language": "en", "redaction": "none"}}
{"text": "Decision: Keep embedding pipelines local-first with SQLite-backed metadata; defer server transports until cloud phase. Consequence: clients must rebuild embeddings from Git-tracked markdown to ensure auditability.", "metadata": {"schema_version": "0.1.0", "doc_id": "ADR-0009", "doctype": "adr", "title": "Local-first embedding search architecture", "state": "Accepted", "tags": ["embedding", "local-first"], "product": "kano-agent-backlog-skill", "source_path": "_kano/backlog/products/kano-agent-backlog-skill/decisions/ADR-0009_local-first-embedding-search-architecture.md", "path_hash": "sha256:5d54e3f2b7c60b2a58cda6a6b0f7b3e6a4b8c7d2f1d9c0e8f3a5b6c7d8e9f0a1", "section_path": "adr/decision", "chunk_kind": "decision", "chunk_index": 1, "chunk_count": 4, "chunk_char_len": 189, "chunk_hash": "sha256:1ae9f1b0d2c9e5f4a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9", "source_updated": "2026-01-07T00:00:00Z", "created_at": "2026-01-03T00:00:00Z", "language": "en", "redaction": "none"}}
```
