# Tokenizers & Embeddings: Key Takeaways (for Local-First RAG/Search)

Source: user-provided research notes (chat), 2026-01-15.

## Tokenizers (Chunking + Token Counting Implications)

### BPE (incl. byte-level BPE)
- Learns merges of frequent pairs → subword tokens; common words become single tokens, rare words split into many.
- Byte-level BPE starts from 256 byte symbols → avoids OOV (always encodable / reversible), but tokenization efficiency varies by language.
- Multilingual behavior can be uneven (e.g., CJK may produce more tokens than English for similar semantic content).

### WordPiece
- Similar to BPE but merge decisions are guided by likelihood/utility rather than pure frequency.
- Uses continuation markers (e.g., `##`) to express “this subword continues a word”.
- Still subword-count-based token accounting; unknown handling can degrade to chars or `[UNK]` depending on vocab coverage.

### SentencePiece (BPE or Unigram LM)
- Language-agnostic, no pre-tokenization required; represents whitespace explicitly (e.g., `▁` prefix).
- Deterministic inference is achievable (greedy/most-likely path) and robust for multilingual pipelines.
- Common choice for multilingual encoders (e.g., XLM-R family).

### TikToken (OpenAI’s byte-level BPE implementation)
- Matches OpenAI GPT-family vocabularies (e.g., `cl100k_base`) and is the authoritative way to estimate OpenAI API token usage.
- Cross-language token counts vary significantly; costs/limits are token-based, so tokenizer choice matters for budget planning.

## Embedding Model Families (Capabilities + Constraints)

### OpenAI Embeddings (e.g., `text-embedding-ada-002`)
- Cloud API; strong general-purpose embeddings (notably English); fixed output dimensionality (e.g., 1536 for ada-002).
- Hard input token limit (report cites 8191 tokens for ada-002); long documents require chunking.
- Privacy/offline constraints: requires network + external service.

### Sentence-Transformers / SBERT ecosystem
- Local-first friendly; broad model choice (speed/quality tradeoffs).
- Tokenizer depends on the base model (WordPiece/BPE/SentencePiece).
- Typical context windows are short (often ~512 tokens) → requires chunking for documents.
- Multilingual variants exist (e.g., multilingual MiniLM; LaBSE for strong cross-lingual alignment).

### BGE (BAAI) family (incl. BGE-M3)
- Emphasizes multilingual + multi-granularity; report claims support for longer contexts (up to ~8192 tokens for M3).
- Often 768-d output with optional dimensionality reduction (storage/cost tradeoff).
- Local deployment possible; strong candidate for cross-lingual retrieval.

### GTE (Alibaba) family (incl. multilingual GTE)
- Emphasizes multilingual retrieval and long-context encoders (report cites 8k+ via RoPE, etc.).
- Uses SentencePiece vocabulary (XLM-R style) and supports flexible output dimensions (e.g., 128–768).
- Local deployment possible; includes reranker variants in the ecosystem.

### MiniLM / small encoders
- Fast + cheap; good for “default local” embedding when content is short and mostly English.
- Limited context window; multilingual quality varies by model.

### LlamaIndex (framework)
- Not an embedding model; provides provider abstraction + chunking utilities + integration patterns.
- Useful as a reference for adapter design (split, embed, index) but adds dependency surface.

## Key Engineering Concerns (for This Topic)

### 1) Deterministic chunking + reconstruction
- Chunking must be stable across runs and independent of the embedding model so re-indexing is incremental.
- Recommended: rule-based chunking + canonical chunk IDs (e.g., content hash) + stable ordering metadata (doc_id + chunk_index).

### 2) Context length limits + trim strategy
- Model windows differ (≈512 vs ≈8k+). A robust pipeline should:
  - chunk first (preferred), then trim only as a last resort for outliers
  - record when/why truncation occurred (observability)
- If multiple embedding backends are supported, chunk size should not exceed the “smallest supported” model unless the index is per-model.

### 3) Token counting as observability (budget + routing)
- Provide `count_tokens(text, model)` per provider:
  - OpenAI: TikToken-based counts
  - HF/local: HuggingFace tokenizer counts
- Use counts for: cost estimation, max-window enforcement, and routing decisions (local vs cloud).

### 4) Multilingual retrieval strategy
- If cross-lingual search is a requirement, prefer multilingual encoders aligned in a shared semantic space (e.g., LaBSE / BGE-M3 / multilingual GTE).
- Maintain language metadata per chunk to enable filtering/diagnostics, even when using a single multilingual index.

### 5) Provider abstraction + fallback
- Define a stable embedding adapter interface:
  - providers: `openai`, `hf-local`, etc.
  - model specs: `max_tokens`, `dim`, `tokenizer`, `languages`, `cost`
- Add fallback policies (e.g., local-first; cloud fallback for long context / quality-critical runs) with explicit logging.

## Recommended Next Decisions / Experiments
- Decide whether cross-lingual retrieval is a “must” (drives model choice + index design).
- Benchmark a small set of candidate embedders locally (e.g., MiniLM vs multilingual GTE/BGE) on:
  - retrieval quality (manual spot checks), speed, memory, disk footprint (dimensionality)
  - token inflation by language for the chosen tokenizer
- Define a deterministic chunking spec (rules + IDs) and treat it as a versioned contract.

