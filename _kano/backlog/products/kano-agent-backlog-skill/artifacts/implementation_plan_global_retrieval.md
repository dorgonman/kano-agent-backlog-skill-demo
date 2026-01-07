# Implementation Plan: Global Retrieval System (Hybrid Search)

## Context
As the Kano platform grows into a multi-product monorepo, agents and users need a unified way to retrieve relevant context across WorkItems, ADRs, Worklogs, and Documentation. 

The current indexing is limited to WorkItems and does not support semantic (embedding) or full-text search (FTS).

## Proposed Architecture
- **Canonical Store**: Markdown Files (WorkItems, ADRs, Logs, Docs).
- **Derived Metadata Store**: SQLite (Document Registry, Chunks, Relationship Mapping).
- **Full-Text Search**: SQLite FTS5 (BM25 ranking).
- **Vector Store**: ANN Sidecar (HNSWlib or FAISS) for high-dimensional embeddings.

## Data Model (SQLite)

### `documents`
| Column | Type | Description |
| :--- | :--- | :--- |
| `doc_id` | INTEGER (PK) | Internal document surrogate key. |
| `uid` | TEXT | Canonical UID (from frontmatter if exists). |
| `doctype` | TEXT | enum: `workitem`, `adr`, `worklog`, `workset`, `skill`, `attachment`. |
| `product` | TEXT | Product identifier. |
| `path` | TEXT | Relative path to source file. |
| `title` | TEXT | Extracted title. |
| `updated_at` | TEXT | ISO timestamp. |
| `content_hash`| TEXT | SHA256 of full file content. |
| `visibility` | TEXT | enum: `canonical`, `local_cache`, `private`. |

### `chunks`
| Column | Type | Description |
| :--- | :--- | :--- |
| `chunk_id` | INTEGER (PK) | Global chunk identifier. |
| `doc_id` | INTEGER | FK to `documents`. |
| `chunk_index` | INTEGER | Index within document. |
| `text` | TEXT | Chunk text content. |
| `text_hash` | TEXT | Hash of chunk text. |
| `token_count` | INTEGER | Estimated or actual token count. |
| `section` | TEXT | Markdown heading path (e.g., `# Context > # Goal`). |
| `weight_hint` | REAL | Weight multiplier for ranking (Decision/Title > Log). |

### `chunks_fts` (FTS5 Virtual Table)
| Column | Type | Description |
| :--- | :--- | :--- |
| `chunk_id` | INTEGER | Global chunk identifier. |
| `text` | TEXT | Text for indexing. |

## Implementation Roadmap

### Phase 1: Schema & Ingestion (Sprint 1)
- [ ] Create SQLite migration for `documents`, `chunks`, and `fts` tables.
- [ ] Implement `scripts/indexing/ingest.py` (`kano ingest`):
    - [ ] Discover files by product.
    - [ ] Parse by DocType (extracting sections).
    - [ ] Incremental update check (hash-based).
    - [ ] Populate `documents` and `chunks`.
    - [ ] Refresh `chunks_fts`.

### Phase 2: Embedding & ANN (Sprint 1-2)
- [ ] Define sidecar storage layout in `_kano/backlog/_index/`.
- [ ] Implement `scripts/indexing/embed.py` (`kano embed`):
    - [ ] Detect changed chunks (missing from ANN or text_hash mismatch).
    - [ ] Batch call Embedding API (Gemini/OpenAI/Ollama).
    - [ ] Update HNSWlib/FAISS index.
    - [ ] Manage `chunk_id -> vector_id` mapping.

### Phase 3: Hybrid Search (Sprint 2)
- [ ] Implement `scripts/indexing/search.py` (`kano search`):
    - [ ] Keyword search (FTS5 BM25).
    - [ ] Semantic search (ANN).
    - [ ] Metadata filtering (product, status, doctype).
    - [ ] Hybrid ranking (Reciprocal Rank Fusion or Weighted Sum).

## User Interface (CLI)
- `kano ingest --product ALL`
- `kano embed --product ALL --provider gemini`
- `kano search --q "renumber collision" --hybrid`

## Progress Tracking
- [ ] ADR-0009 Updated with detailed design.
- [ ] USR-0015 (Embeddings) updated to Phase 2.
- [ ] TSK-0092 (Global Embedding DB) split into implementation tasks.
