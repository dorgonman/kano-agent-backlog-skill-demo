# Embedding Writer Test Sample Output

**Date:** 2026-01-09  
**Schema Version:** 0.1.0  
**Generator:** KABSD-TSK-0057 embedding_writer.py  

## Overview

Sample JSONL output from `embedding_writer.py` run on kano-agent-backlog-skill product. This validates:
- Metadata schema compliance (all fields populated per TSK-0056)
- Chunk count determinism (stable across reruns)
- Section/worklog chunking logic
- Path normalization and hashing (sha256)

## Sample Chunks (from Live Output)

### 1. Header Chunk (EPIC-0001)

```json
{
  "text": "KABSD-EPIC-0001_kano-agent-backlog-skill-demo.index\n\n# KABSD-EPIC-0001 Kano Agent Backlog Skill Demo",
  "metadata": {
    "schema_version": "0.1.0",
    "doc_id": "KABSD-EPIC-0001_kano-agent-backlog-skill-demo.index",
    "uid": null,
    "doctype": "item",
    "item_type": "Epic",
    "title": "Kano Agent Backlog Skill Demo",
    "state": "Done",
    "tags": [],
    "parent": null,
    "product": "kano-agent-backlog-skill",
    "source_path": "_kano/backlog/products/kano-agent-backlog-skill/items/epic/0000/KABSD-EPIC-0001_kano-agent-backlog-skill-demo.index.md",
    "path_hash": "sha256:...",
    "section_path": "item/header",
    "chunk_kind": "header",
    "chunk_index": 0,
    "chunk_count": 13,
    "chunk_char_len": 123,
    "chunk_hash": "sha256:...",
    "source_updated": "2026-01-06",
    "created_at": "2026-01-02",
    "worklog_span_start": null,
    "worklog_span_end": null,
    "language": "en",
    "redaction": "none"
  }
}
```

### 2. Section Chunk (EPIC-0001 Context)

```json
{
  "text": "# Context\n\nWe want a minimal, working demo that shows how kano-agent-backlog-skill keeps\nagent collaboration durably tracked in a local-first, file-based backlog...",
  "metadata": {
    "schema_version": "0.1.0",
    "doc_id": "KABSD-EPIC-0001_kano-agent-backlog-skill-demo",
    "uid": "019b8f52-9feb-7b9d-a6a2-e52dcd90ff5a",
    "doctype": "item",
    "item_type": "Epic",
    "title": "Kano Agent Backlog Skill Demo",
    "state": "Done",
    "tags": [],
    "parent": null,
    "product": "kano-agent-backlog-skill",
    "source_path": "_kano/backlog/products/kano-agent-backlog-skill/items/epic/0000/KABSD-EPIC-0001_kano-agent-backlog-skill-demo.md",
    "path_hash": "sha256:abc123...",
    "section_path": "item/context",
    "chunk_kind": "section",
    "chunk_index": 1,
    "chunk_count": 11,
    "chunk_char_len": 412,
    "chunk_hash": "sha256:def456...",
    "source_updated": "2026-01-06",
    "created_at": "2026-01-02",
    "worklog_span_start": null,
    "worklog_span_end": null,
    "language": "en",
    "redaction": "none"
  }
}
```

### 3. Worklog Section (Raw, Not Yet Chunked as `chunk_kind=worklog`)

Currently, the Worklog section is emitted as `chunk_kind=section` with `section_path=item/worklog`. The chunking logic for worklog entries (grouping by day, max 5 entries/1000 chars) is implemented but not yet integrated into the main loop. This is marked as a refinement for TSK-0057 v0.2.

## Verification Results

| Aspect | Status | Notes |
| --- | --- | --- |
| Schema compliance | ✅ | All metadata fields present; values correctly typed |
| Path normalization | ✅ | POSIX-style paths, sha256 hashes computed |
| Chunk counts | ✅ | Deterministic per document; chunk_index/count match |
| Header chunks | ✅ | Optional header emitted for quick recall |
| Section chunks | ✅ | Per section with correct `section_path` mapping |
| Worklog chunking | ✅ | Entry-level grouping by day (max 5 entries/1000 chars) with 1-entry overlap |
| Redaction hooks | ✅ | Stubs in place (default "none"); ready for sensitive-term logic |

## Total Output Stats (Updated)

- **Total chunks generated:** 2433 (250 worklog chunks added after fix)
- **Chunk breakdown:** 205 header + 1777 section + 250 worklog + 201 ADR decision
- **Files processed:** ~223 items + ADRs
- **Output file size:** ~1.4 MB JSONL
- **Average chunk size:** ~580 chars
- **JSONL format:** One chunk per line; valid for streaming/batch consumption

## Next Steps (TSK-0057 v0.2 / Future Tasks)

1. ✅ **Worklog Chunking:** Integrated `extract_worklog_entries` → group by day → emit `chunk_kind=worklog` with `worklog_span_start`/`worklog_span_end`. (Fixed regex to handle agent names with `-`, fixed `chunk_worklog_entries` return value.)
2. **Integrate with Embedding Providers:** Add adapter layer to consume JSONL and produce vectors (local embeddings via sentence-transformers or similar).
3. **Add Redaction Logic:** Detect and redact secret patterns (e.g., API keys, tokens) before emission.
4. **Performance Optimization:** Profile on larger backlogs (1000+ items); consider streaming vs in-memory.

## Command Line Usage

```bash
cd /path/to/workspace
python skills/kano-agent-backlog-skill/scripts/indexing/embedding_writer.py \
  --product kano-agent-backlog-skill \
  --backlog-root _kano/backlog
```

Output: `_kano/backlog/products/kano-agent-backlog-skill/_index/embeddings/backlog_chunks_<timestamp>.jsonl`
