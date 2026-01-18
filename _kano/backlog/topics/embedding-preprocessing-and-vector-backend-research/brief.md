# Topic Brief: embedding-preprocessing-and-vector-backend-research

Generated: 2026-01-18T18:09:24.954114Z
Note: This file was manually edited after `topic distill`; re-running distill overwrites it.

## Facts

<!-- Verified facts with citations to materials/items/docs -->
- [x] Local-first embedding search architecture: canonical store is Markdown; derived search uses SQLite (metadata + FTS) plus an ANN sidecar for semantic retrieval. - [source](_kano/backlog/products/kano-agent-backlog-skill/decisions/ADR-0009_local-first-embedding-search-architecture.md)
- [x] Vector backend feasibility evidence (Windows-focused): `hnswlib` likely requires a compiler toolchain; `faiss-cpu` works via pre-built wheels; `sqlite-vec` exists but was evaluated as immature in the captured report. - [source](_kano/backlog/products/kano-agent-backlog-skill/artifacts/KABSD-TSK-0124/embedding_search_library_evaluation.md)
- [x] Embedding chunking + metadata schema draft exists (JSONL, schema version 0.1.0) for items and ADRs; includes `source_path`, `path_hash`, section/worklog chunking rules, and `chunk_hash` for incremental rebuild. - [source](_kano/backlog/products/kano-agent-backlog-skill/artifacts/KABSD-TSK-0056/embedding_chunking_metadata.md)
- [x] A deterministic chunking + token-budget fitting contract draft exists (normalization, boundary rules, overlap, stable chunk IDs, safety margin, trimming policy, and MVP validation cases). - [source](_kano/backlog/products/kano-agent-backlog-skill/items/task/0200/KABSD-TSK-0207_research-and-spec-chunking-token-budget-fitting-and-trimming-for-embeddings.md)
- [x] A pluggable vector backend adapter contract draft exists (prepare/upsert/delete/query/persist/load) and was marked implemented in the task worklog. - [source](_kano/backlog/products/kano-agent-backlog-skill/items/task/0200/KABSD-TSK-0208_reframe-vector-index-backend-research-as-pluggable-backend-kabsd-tsk-0124.md)
- [x] Tokenizer and embedding model family considerations (BPE/WordPiece/SentencePiece; OpenAI vs SBERT vs BGE/GTE; multilingual token inflation; determinism and telemetry) are summarized in topic synthesis notes. - [source](_kano/backlog/topics/embedding-preprocessing-and-vector-backend-research/synthesis/tokenizers-and-embeddings-key-takeaways.md)
- [x] Cross-lingual retrieval is required, so the default embedding policy must be multilingual-capable and benchmarks must include multilingual/cross-lingual cases. - [source](_kano/backlog/products/kano-agent-backlog-skill/decisions/ADR-0035_cross-lingual-retrieval-requirement-and-default-embedding-policy.md)
- [x] Index strategy baseline: per-model indexes by default (per `embedding_space_id`), with explicit config allowing safe switching/rollback; “shared index across different models” is not supported. - [source](_kano/backlog/products/kano-agent-backlog-skill/decisions/ADR-0036_index-strategy-shared-index-now-per-model-indexes-later-via-config.md)

## Unknowns / Risks

- [ ] Per-model indexes increase disk/rebuild cost during evaluation; benchmark/reporting must include `embedding_space_id` and support fast switching/rollback. - [source](_kano/backlog/products/kano-agent-backlog-skill/decisions/ADR-0036_index-strategy-shared-index-now-per-model-indexes-later-via-config.md)
- [ ] Token counting accuracy and truncation behavior are provider-dependent; telemetry must distinguish exact vs heuristic counts. - [source](_kano/backlog/products/kano-agent-backlog-skill/items/userstory/0000/KABSD-USR-0031_embedding-adapter-interface-with-token-counting-telemetry.md)
- [ ] HNSWlib is risky for Windows local-first setup; FAISS is viable but introduces heavier binary deps; sqlite-vec maturity needs re-checking. - [source](_kano/backlog/products/kano-agent-backlog-skill/artifacts/KABSD-TSK-0124/embedding_search_library_evaluation.md)

## Proposed Actions

- [ ] Complete and review ADR-0035 and ADR-0036 (promote from Proposed once reviewed), including explicit validation criteria for benchmarks. - KABSD-USR-0035
- [ ] Implement deterministic chunking + token-budget MVP per spec and add tests for short ASCII, long English, and CJK token inflation cases. - KABSD-USR-0029 / KABSD-TSK-0207
- [ ] Add embedding adapter interface + token counting/truncation telemetry and resolve via config. - KABSD-USR-0031
- [ ] Build a small, reproducible benchmark harness that includes cross-lingual retrieval cases (multilingual corpus, token stats, chunk stats, embed latency/dims, truncation rate). - KABSD-USR-0034
- [ ] Select and harden a default local-first vector backend implementation (with FTS5-only fallback) and verify rebuild semantics. - KABSD-USR-0030 / KABSD-TSK-0124 / KABSD-TSK-0208

## Decision Candidates

- [ ] Decide default local-first embedding model family (MiniLM-class vs multilingual GTE/BGE-class) and define a minimal evaluation rubric. - ADR draft needed (or record as benchmark-driven decision)
- [ ] Decide default vector backend library choice for local-first (FAISS vs sqlite-vec vs other) and required fallback behavior. - ADR draft needed (or update ADR-0009 with an addendum)

## Related Topics

- (none)

## Materials Index (Deterministic)

### Items
- KABSD-EPIC-0003: Milestone 0.0.2 (Indexing + Resolver) (Epic, InProgress) - `_kano/backlog/products/kano-agent-backlog-skill/items/epic/0000/KABSD-EPIC-0003_milestone-0-0-2-indexing-resolver.md` <!-- uid: 019bac4a-6857-7432-b43f-3082737ca786 -->
- KABSD-FTR-0042: Embedding providers, tokenizers, and benchmark harness (Feature, Proposed) - `_kano/backlog/products/kano-agent-backlog-skill/items/feature/0000/KABSD-FTR-0042_embedding-providers-tokenizers-and-benchmark-harness.md` <!-- uid: 019bcbef-dc2a-778e-8c87-d5619170230c -->
- KABSD-TSK-0056: Define embedding chunking + metadata schema for backlog items (Task, Done) - `_kano/backlog/products/kano-agent-backlog-skill/items/task/0000/KABSD-TSK-0056_define-embedding-chunking-metadata-schema-for-backlog-items.md` <!-- uid: 019b8f52-9fc8-7c94-aa2d-806cacdd9086 -->
- KABSD-TSK-0124: 'Research: Comparative Performance and Deployment of SQLite-Vec vs FAISS vs (Task, Done) - `_kano/backlog/products/kano-agent-backlog-skill/items/task/0100/KABSD-TSK-0124_research-embedding-search-options-performance-and-deployment.md` <!-- uid: 019bac4a-683c-76c3-adc9-bf67e569e226 -->
- KABSD-TSK-0207: Research and spec chunking, token budget fitting, and trimming for embeddings (Task, Proposed) - `_kano/backlog/products/kano-agent-backlog-skill/items/task/0200/KABSD-TSK-0207_research-and-spec-chunking-token-budget-fitting-and-trimming-for-embeddings.md` <!-- uid: 019bc21c-6e9c-765a-877f-994bacdf5002 -->
- KABSD-TSK-0208: Reframe vector index backend research as pluggable backend (KABSD-TSK-0124) (Task, Done) - `_kano/backlog/products/kano-agent-backlog-skill/items/task/0200/KABSD-TSK-0208_reframe-vector-index-backend-research-as-pluggable-backend-kabsd-tsk-0124.md` <!-- uid: 019bc21c-ec25-70e2-84ec-d0042844af4d -->
- KABSD-USR-0015: Generate embeddings for backlog items (derivative index) (UserStory, Done) - `_kano/backlog/products/kano-agent-backlog-skill/items/userstory/0000/KABSD-USR-0015_generate-embeddings-for-backlog-items-derivative-index.md` <!-- uid: 019b8f52-9f4a-754d-8d3a-81c5e41c131a -->
- KABSD-USR-0029: Chunking and token-budget embedding pipeline MVP (UserStory, InProgress) - `_kano/backlog/products/kano-agent-backlog-skill/items/userstory/0000/KABSD-USR-0029_chunking-and-token-budget-embedding-pipeline-mvp.md` <!-- uid: 019bc754-30c3-70fa-8740-c643948c9a9d -->
- KABSD-USR-0030: Pluggable vector backend MVP for embeddings (UserStory, Proposed) - `_kano/backlog/products/kano-agent-backlog-skill/items/userstory/0000/KABSD-USR-0030_pluggable-vector-backend-mvp-for-embeddings.md` <!-- uid: 019bc754-4618-71c1-9ff9-db63c0d47561 -->
- KABSD-USR-0031: Embedding adapter interface with token-counting telemetry (UserStory, Proposed) - `_kano/backlog/products/kano-agent-backlog-skill/items/userstory/0000/KABSD-USR-0031_embedding-adapter-interface-with-token-counting-telemetry.md` <!-- uid: 019bcbf0-58b4-7308-81e0-4aaed24cd43b -->
- KABSD-USR-0034: Benchmark harness for chunking and embedding options (multilingual, window (UserStory, Proposed) - `_kano/backlog/products/kano-agent-backlog-skill/items/userstory/0000/KABSD-USR-0034_benchmark-harness-for-chunking-and-embedding-options-multilingual-window-limits.md` <!-- uid: 019bcbf4-71e9-7150-9498-889e8a1af8e9 -->
- KABSD-USR-0035: Decide cross-lingual retrieval and index strategy via ADRs (UserStory, Proposed) - `_kano/backlog/products/kano-agent-backlog-skill/items/userstory/0000/KABSD-USR-0035_decide-cross-lingual-retrieval-and-index-strategy-via-adrs.md` <!-- uid: 019bcbf4-aed0-77ec-8d79-15407c5db49a -->

### Pinned Docs
- _kano/backlog/products/kano-agent-backlog-skill/decisions/ADR-0009_local-first-embedding-search-architecture.md
- _kano/backlog/topics/embedding-preprocessing-and-vector-backend-research/synthesis/tokenizers-and-embeddings-key-takeaways.md

### Snippet Refs
- (none)
