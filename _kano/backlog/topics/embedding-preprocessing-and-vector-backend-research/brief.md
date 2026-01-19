# Stable Brief: embedding-preprocessing-and-vector-backend-research

This file is the stable brief. It must not be overwritten by automated distill steps.

## Purpose
- Provide long-lived summary and decisions.

## Stable Summary
- This topic consolidates research and decisions around embedding preprocessing, chunking, token budgets, and vector backend options for a local-first backlog system.
- Current milestone focus: the 0.0.2 indexing + resolver milestone, plus embedding providers, tokenizers, and benchmark harness work.
- Implementation is guided by ADR-0009 (local-first embedding search architecture) and ongoing research tasks around chunking and backend selection.

## Key Decisions
- Local-first embedding search architecture documented in ADR-0009.
- Vector backend research re-framed as a pluggable backend (see KABSD-TSK-0208).
- Embedding adapter interface includes token-counting telemetry (KABSD-USR-0031).

## Open Questions / Risks
- Finalize chunking/token-budget fitting policy for embeddings (KABSD-TSK-0207).
- Benchmark results may change backend selection; keep pluggable design flexible (KABSD-FTR-0042).
- Ensure tokenizer selection aligns with embedding provider constraints and multilingual needs (KABSD-USR-0034).

## References
- Generated snapshot: `_kano/backlog/topics/embedding-preprocessing-and-vector-backend-research/brief.generated.md`
