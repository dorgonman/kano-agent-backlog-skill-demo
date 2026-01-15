# Topic Notes: embedding-preprocessing-and-vector-backend-research

## Overview

Research and design notes for a local-first embedding pipeline (tokenization, deterministic chunking, model/provider adapters) and how those choices constrain a vector backend.

Key synthesis: `_kano/backlog/topics/embedding-preprocessing-and-vector-backend-research/synthesis/tokenizers-and-embeddings-key-takeaways.md`.

## Related Items

Seed items are tracked in `manifest.json`. Future workitems will likely split into:
- deterministic chunking spec + hashing/IDs
- embedding adapter + token counting observability
- vector backend evaluation (storage, indexing, search)

## Key Decisions

- Whether cross-lingual retrieval is required (drives multilingual model selection and index design).
- Whether the index is per-model (different chunk limits/dims) or model-agnostic (chunk to the smallest supported window).
- Local-first default provider policy (local embeddings first vs cloud-first with fallback).

## Open Questions

- Which embedding family is the default for local-first (MiniLM-class vs multilingual GTE/BGE-class)?
- What is the “versioned” deterministic chunking contract (rules, max size, overlap, normalization)?
- How will we represent token counting + truncation events for observability and routing?
