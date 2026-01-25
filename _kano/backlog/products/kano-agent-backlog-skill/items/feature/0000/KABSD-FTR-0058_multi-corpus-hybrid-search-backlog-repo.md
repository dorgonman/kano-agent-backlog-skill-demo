---
id: KABSD-FTR-0058
uid: 019bf587-47aa-73d1-8dee-6c795f4bcb74
type: Feature
title: "Multi-corpus hybrid search (backlog + repo)"
state: InProgress
priority: P1
parent: KABSD-EPIC-0004
area: infrastructure
iteration: backlog
tags: ['search', 'index', 'embedding', 'fts']
created: 2026-01-25
updated: 2026-01-25
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

Current search is limited to product items only. ADRs, topics, documentation, and source code are not indexed, forcing agents to fall back to slow grep or miss critical context entirely. This creates a gap between "what's in the backlog" and "what's in the repo", making it hard to answer questions like "where is this error message defined?" or "what ADRs relate to embedding search?"

We need a multi-corpus search system that indexes both backlog content (items, ADRs, topics) and repo content (docs, code) while keeping them logically separated for ranking and query scoping.

# Goal

Provide hybrid search (FTS5 + vector rerank) over two distinct corpuses:
1. **Backlog corpus**: items + ADRs + topics (semantic domain: planning, decisions, context)
2. **Repo corpus**: docs + code (semantic domain: implementation, reference, errors)

Each corpus has its own rebuildable SQLite DB (FTS5 + chunks) and separate embedding space to prevent cross-corpus ranking pollution. Support incremental builds with mtime-based freshness checks and --force rebuild escape hatch.

# Non-Goals

- Cross-corpus ranking in a single query (corpuses are queried separately)
- Real-time incremental updates (rebuild-based, not watch-based)
- Indexing binary files, secrets, or derived artifacts
- Strong content-hash-based freshness (too slow; use mtime heuristic)

# Approach

**Corpus Split**:
- Backlog corpus: scan `products/*/items/**`, `products/*/decisions/**`, `topics/**`
- Repo corpus: scan workspace with safe defaults (*.md, *.py, *.toml, *.json) and explicit excludes (.git, .cache, *.sqlite3, .env)

**Storage**:
- Each corpus gets its own SQLite DB: `products/<product>/.cache/chunks.sqlite3` (backlog), `<workspace>/.cache/repo_chunks.sqlite3` (repo)
- Reuse canonical schema (items, chunks, chunks_fts)
- Embedding vectors keyed by chunk_id with corpus-specific embedding_space_id

**Cache Freshness**:
- Use mtime-based heuristic for speed (check file mtime vs last index time)
- Provide --force rebuild as escape hatch when results look stale
- Decision recorded in KABSD-TSK-0297 worklog

**Implementation Tasks**:
1. KABSD-TSK-0297: Define corpus boundaries and cache policy
2. KABSD-TSK-0298: Implement backlog corpus chunks DB
3. KABSD-TSK-0299: Implement repo corpus chunks DB
4. KABSD-TSK-0300: Add repo corpus embedding build and hybrid search
5. KABSD-TSK-0301: Document usage and rebuild commands

# Alternatives

**Alternative 1: Single unified corpus**
- Pros: Simpler, one DB, cross-corpus ranking
- Cons: Backlog items would compete with code snippets in ranking; hard to scope queries; corpus churn affects everything

**Alternative 2: Strong content-hash-based freshness**
- Pros: Accurate freshness detection
- Cons: Too slow for large repos; adds complexity; mtime heuristic + --force is good enough

**Alternative 3: Watch-based incremental updates**
- Pros: Real-time freshness
- Cons: Complex, requires file watchers, harder to reason about; rebuild-based is simpler and more reliable

# Acceptance Criteria

- Backlog corpus can be built and queried (FTS + hybrid) with results from items, ADRs, and topics
- Repo corpus can be built and queried (FTS + hybrid) with results from docs and code
- Each corpus has its own SQLite DB and embedding space
- Incremental builds skip unchanged files (mtime check)
- --force rebuild works for both corpuses
- Include/exclude patterns prevent indexing secrets, binaries, and derived files
- Documentation describes both corpuses, build/query commands, and cache freshness policy
- Tests cover both corpus builders and hybrid search end-to-end

# Risks / Dependencies

**Risks**:
- mtime-based freshness can produce false fresh/false stale results (mitigate: --force rebuild + clear docs)
- Large repos increase build time (mitigate: conservative defaults, incremental builds)
- Accidental secret indexing (mitigate: strict exclude patterns, size limits)
- Corpus churn may require periodic force rebuild (mitigate: document rebuild workflow)

**Dependencies**:
- Canonical schema (ADR-0012) must support non-item entities
- Chunking and tokenizer infrastructure must be stable
- Embedding pipeline must support corpus-specific embedding_space_id

# Worklog

2026-01-25 22:20 [agent=opencode] Created item
2026-01-25 23:29 [agent=opencode] Auto parent sync: child KABSD-TSK-0298 -> InProgress; parent -> InProgress.

