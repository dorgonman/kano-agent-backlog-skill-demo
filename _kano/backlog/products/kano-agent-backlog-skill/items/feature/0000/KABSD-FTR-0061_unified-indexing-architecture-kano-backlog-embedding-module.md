---
id: KABSD-FTR-0061
uid: 019bfa9e-8caf-762b-a793-93f2f0fcd2f9
type: Feature
title: "Unified indexing architecture (kano_backlog_embedding module)"
state: Proposed
priority: P2
parent: null
area: embedding
iteration: "0.0.3"
tags: [refactor, architecture, embedding, indexing]
created: 2026-01-26
updated: 2026-01-26
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
- [ ] Documentation updated in SKILL.md

# Risks / Dependencies

- **Migration effort**: Need to update all import paths and CLI commands
- **Testing**: Need comprehensive test coverage before migration
- **Performance**: Must not regress from current async implementation
- **Deadline**: Target 0.0.3, may slip if scope creeps

# Worklog

2026-01-26 22:04 [agent=opencode] Created item - extracted requirements from async optimization discussion
