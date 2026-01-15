# Topic Brief: embedding-preprocessing-and-vector-backend-research

Generated: 2026-01-15T14:42:05.217983Z

## Facts

<!-- Verified facts with citations to materials/items/docs -->
- [x] Tokenization choice materially impacts token counting/cost and max-context enforcement; token inflation differs by language. - Source: `synthesis/tokenizers-and-embeddings-key-takeaways.md`
- [x] Embedding models have hard max-token windows (commonly ~512 for BERT-derived encoders; ~8k for some newer multilingual encoders / OpenAI embeddings), so chunking is required for documents. - Source: `synthesis/tokenizers-and-embeddings-key-takeaways.md`
- [x] Deterministic, model-independent chunking + stable chunk IDs enable incremental indexing and reliable reconstruction. - Source: `synthesis/tokenizers-and-embeddings-key-takeaways.md`

## Unknowns / Risks

<!-- Open questions and potential blockers -->
- [ ] Do we require cross-lingual retrieval (single shared embedding space), or is same-language search sufficient?
- [ ] If we support multiple embedders with different max-token windows, do we chunk to the smallest window (model-agnostic index) or keep per-model indexes?
- [ ] Tokenization + chunking choices may bias against CJK content (cost and context utilization) if not measured and compensated.

## Proposed Actions

<!-- Concrete next steps, linked to workitems -->
- [ ] Define a deterministic chunking contract (normalization, rules, max size, overlap, chunk ID/hash). → new ticket needed
- [ ] Create an embedding adapter interface with per-provider token counting and truncation telemetry. → new ticket needed
- [ ] Run a small benchmark (local vs cloud, multilingual vs English-first) and document speed/quality/storage tradeoffs. → new ticket needed

## Decision Candidates

<!-- Tradeoffs requiring ADR -->
- [ ] Adopt a single multilingual embedder as the default vs a tiered policy (MiniLM default + multilingual fallback). → ADR draft needed
- [ ] Index strategy: single model-agnostic index vs per-model indexes (dimensionality + chunk window differences). → ADR draft needed

---
_This brief is auto-generated. Edit after distill to finalize._
