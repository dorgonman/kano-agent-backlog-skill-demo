---
id: KABSD-FTR-0061
uid: 019bfa9e-8caf-762b-a793-93f2f0fcd2f9
type: Feature
title: "Unified indexing architecture (kano_backlog_embedding module)"
state: Done
priority: P2
parent: null
area: embedding
iteration: "0.0.3"
tags: [refactor, architecture, embedding, indexing]
created: 2026-01-26
updated: 2026-01-27
owner: None
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
---

# Context

The current indexing and embedding implementation has significant code duplication between backlog corpus and repo corpus:

**Current State (as of 0.0.2):**
- `backlog_chunks_db.py` (600 lines) - Backlog FTS indexing
- `repo_chunks_db.py` (497 lines) - Repo FTS indexing  
- `repo_chunks_db_async.py` (420 lines) - Async repo indexing
- `backlog_vector_index.py` (434 lines) - Backlog vector indexing
- `repo_vector_index.py` (255 lines) - Repo vector indexing
- `backlog_vector_query.py` (210 lines) - Backlog vector search
- `repo_vector_query.py` (180 lines) - Repo vector search
- `benchmark_embeddings.py` (320 lines) - Benchmarking

**Issues:**
1. ~70-80% code duplication between backlog/repo implementations
2. Different interfaces for same conceptual operations
3. Hard to add new corpus types (e.g., web, external docs)
4. Embedding model management scattered across files
5. No unified abstraction for FTS + vector + hybrid search

Scale note:
- This must support very large monorepos (e.g., AAA game projects using Unreal Engine), where repo indexing can involve a huge number of files and large generated/vendor directories.

# Goal

Create a unified `kano_backlog_embedding` module that:
1. Consolidates all indexing/embedding logic into a clean architecture
2. Uses adapter pattern to support multiple corpus types (backlog, repo, future: web, external)
3. Provides consistent interface for FTS, vector, and hybrid search
4. Simplifies adding new embedding models and backends
5. Reduces code duplication by 60%+

# Non-Goals

- Backward compatibility with existing internal APIs (can break)
- Support for non-local embedding models (still local-first)
- Real-time index updates (batch-first approach)

# Approach

**Proposed Architecture:**

```
kano_backlog_embedding/
    __init__.py
    
    # Core abstractions
    corpus.py           # CorpusAdapter base class + registry
    document.py         # Document, Chunk data models
    embedder.py         # EmbeddingAdapter interface + implementations
    
    # FTS layer
    fts/
        __init__.py
        backend.py      # FTSBackend (SQLite FTS5)
        builder.py      # Unified FTS index builder
        query.py        # FTS query interface
    
    # Vector layer  
    vector/
        __init__.py
        backend.py      # VectorBackend (FAISS, SQLite, etc.)
        builder.py      # Unified vector index builder
        query.py        # Vector query interface
    
    # Hybrid search
    hybrid.py           # FTS candidates -> vector rerank
    
    # Corpus adapters
    adapters/
        __init__.py
        backlog.py      # BacklogCorpusAdapter
        repo.py         # RepoCorpusAdapter
        # Future: web.py, external.py
    
    # Utilities
    progress.py         # Progress tracking
    benchmark.py        # Benchmarking harness
```

**Key Abstractions:**

1. `CorpusAdapter` - defines how to enumerate and chunk documents from a source
2. `EmbeddingAdapter` - wraps different embedding models (sentence-transformers, etc.)
3. `FTSBackend` / `VectorBackend` - storage backends for search
4. `IndexBuilder` - orchestrates building with progress tracking

Implementation notes (for 0.0.3 design):
- Keep the current repo chunks parallel builder approach, but design a unified progress/cancellation surface for both FTS and vector builds.
- Add batch-oriented embedding/indexing as a first-class concept (vector build may need batching, multiprocessing, or backend-level batching; avoid assuming ThreadPoolExecutor helps for model inference).
- Large-repo hygiene must be part of the architecture: default exclude lists (build outputs, vendor, engine intermediates), configurable include globs, and optional hard limits (max file size, max files, max total bytes).
- Binary assets (e.g., Unreal `.uasset`) must be excluded from direct indexing/embedding; instead, support project-provided sidecar artifacts (text/JSON, and optionally images) as the index source.

**Storage Optimization (Critical for AAA-scale repos):**
- **Binary vector storage** (0.0.2: implemented): Use `struct.pack` instead of JSON (saves 80% space: 836 MB → 160 MB for 26k chunks)
- **Quantization** (0.0.3): Float32 → Int8 quantization (saves additional 75%: 160 MB → 40 MB)
- **Compression** (0.0.3): zstd compression on binary vectors (saves 30-50%: 40 MB → 20-28 MB)
- **Selective indexing** (0.0.3): Only vector-index "important" files (source code, docs), use FTS-only for tests/generated code
- **Tiered storage** (0.0.3): Hot (recent queries) in memory, Warm (frequent) on SSD, Cold (rare) compressed on HDD

Scale target: AAA Unreal project (~255k files, ~3M chunks) should fit in <5 GB total (FTS + Vector combined).

Project extension point (sidecar contract):
- The unified indexing pipeline must allow a project to provide a deterministic "sidecar export" step that produces indexable artifacts for binary assets.
- Sidecar artifacts are the only inputs to FTS/vector for those assets (never embed raw binary).
- Proposed contract (sketch):
  - Input: project root + corpus config
  - Output: a sidecar directory tree (e.g., `.cache/index/sidecar/<corpus>/...`) containing JSON/text records and stable asset IDs
  - Requirements: deterministic, incremental-friendly, includes provenance (source path, tool/version, timestamp)
  - Config: project-defined include/exclude + binary extension list + sidecar roots

# Alternatives

1. **Keep current structure, just refactor duplicates** - Less intrusive but doesn't solve architectural issues
2. **External library (LangChain, LlamaIndex)** - Adds heavy dependencies, less control
3. **Database-first approach (pgvector, Chroma)** - Loses local-first simplicity

# Acceptance Criteria

- [ ] New `kano_backlog_embedding` module exists under `src/`
- [ ] Backlog corpus adapter passes existing tests
- [ ] Repo corpus adapter passes existing tests
- [ ] Hybrid search works with both corpora via unified interface
- [ ] Async index building works with unified builder
- [ ] CLI commands work with minimal changes
- [ ] Code reduction of 50%+ from current implementation
- [ ] Vector storage uses binary format by default (80% space savings vs JSON)
- [ ] Quantization support for int8 vectors (optional, 75% additional savings)
- [ ] AAA-scale repo (3M chunks) fits in <5 GB total storage
- [ ] Documentation updated in SKILL.md

# Risks / Dependencies

- **Migration effort**: Need to update all import paths and CLI commands
- **Testing**: Need comprehensive test coverage before migration
- **Performance**: Must not regress from current async implementation
- **Repo scale**: Unreal/AAA repos can exceed typical assumptions (file count, directory depth, binary assets); indexing must be configurable and resilient.
- **Deadline**: Target 0.0.3, may slip if scope creeps

# Worklog

2026-01-26 22:04 [agent=opencode] Created item - extracted requirements from async optimization discussion
2026-01-27 01:50 [agent=opencode] Added storage optimization requirements: binary format (0.0.2), quantization/compression/tiered storage (0.0.3). Target: AAA repos (<5 GB for 3M chunks).
2026-01-27 02:26 [agent=opencode] Auto parent sync: child KABSD-TSK-0315 -> Done; parent -> Done.
2026-01-27 02:26 [agent=opencode] Auto parent sync: child KABSD-TSK-0315 -> Done; parent -> Done.
2026-01-27 02:26 [agent=opencode] Auto parent sync: child KABSD-TSK-0314 -> Done; parent -> Done.
