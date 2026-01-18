---
id: ADR-0036
uid: 019bd257-f874-70c9-a47d-10a950c90a23
title: "Index strategy: shared index now, per-model indexes later via config"
status: Proposed
date: 2026-01-19
related_items: ["KABSD-USR-0035"]
supersedes: null
superseded_by: null
---

# Decision

# We will use per-model indexes (per embedding space) as the default.
#
# A single “shared index” across different embedding models is not supported because vectors
# from different models are not generally comparable (dimension and semantic space differ).
#
# We will keep an explicit configuration mechanism to switch index selection and to allow
# controlled “aliasing” (sharing) only when two model identifiers are proven to be the same
# embedding space (strict allowlist; no automatic inference).

# Context

We need a local-first semantic retrieval capability for backlog artifacts (items, ADRs, etc.).
Cross-lingual retrieval is required (see ADR-0035), which increases the likelihood that we
will evaluate and potentially switch between embedding models over time.

The index must remain:
- local-first (no server runtime required)
- rebuildable (derived from canonical Markdown)
- deterministic enough for incremental rebuilds (chunk IDs + content hashes)
- configurable (so we can swap providers/models/backends without rewriting code)

# Options Considered

## Option A: Single shared index across multiple embedding models

Store all vectors in one ANN index, regardless of which model produced them.

## Option B: Per-model indexes (per embedding space) [chosen]

Maintain separate ANN indexes keyed by an explicit “embedding space” identity.

## Option C: Shared index with automatic compatibility detection (future research)

Attempt to infer which models are “compatible enough” to share one index by running
statistical tests (e.g., neighborhood agreement on a validation corpus).

# Pros / Cons

## Option A: Single shared index across multiple embedding models

Pros:
- Minimal operational complexity (one index file)

Cons:
- Generally invalid: vectors from different embedding models are not comparable
  (dimensions can differ; even with same dimension the spaces are different).
- Produces misleading similarity scores and unstable retrieval quality.
- Makes troubleshooting and benchmarking ambiguous.

## Option B: Per-model indexes (per embedding space)

Pros:
- Correctness: avoids mixing incompatible vector spaces.
- Operational clarity: retrieval quality changes map to a single model+version.
- Enables safe experimentation: add a new index for a new model without corrupting the old one.
- Supports gradual rollout: switch default index via config, keep rollback path.

Cons:
- More disk usage and rebuild time when multiple models are evaluated.
- Requires a routing key (index selection) to be part of pipeline config and metadata.

## Option C: Shared index with automatic compatibility detection

Pros:
- Could reduce the number of indexes in some cases.

Cons:
- High risk of false positives (appears compatible on a small corpus but fails in practice).
- Adds complexity and “magic” behavior that is hard to reason about.
- Needs an evaluation harness and careful governance anyway.

# Consequences

## 1) Define a stable embedding space identity

Introduce an `embedding_space_id` used for:
- selecting the vector index (routing)
- storing metadata alongside chunks/vectors
- preventing accidental mixing

Definition (conceptual):
- `embedding_space_id = sha256(provider_id + model_name + model_revision + dims + preprocessing_version + vector_norm + prompt_style_id)`

Notes:
- “model_revision” should include an immutable identifier when possible (HF revision hash, provider version).
- preprocessing_version covers normalization/prefixing decisions that affect embeddings.
- prompt_style_id matters for instruct-style embedders (query vs document templates).

## 2) Index storage layout

Persist one index per `embedding_space_id` (or per “model key” that maps to it), for example:
- `.../vector_indexes/<embedding_space_id>/index.bin`
- `.../vector_indexes/<embedding_space_id>/mapping.sqlite` (if needed)

## 3) Config-driven routing and future “sharing” via allowlist aliasing

Configuration must allow:
- selecting the default embedder (and therefore default index)
- selecting a specific index key explicitly (for debugging/rollback)
- defining alias mappings only when two identifiers are truly the same embedding space

Policy:
- Do not auto-merge indexes.
- If aliasing is used, it must be explicit and reviewed (allowlist).

## 4) Benchmark implications

Benchmarks must report results per `embedding_space_id` so comparisons are reproducible.

# Follow-ups

- Update KABSD-USR-0035 to reference ADR-0036 as the index strategy baseline.
- Ensure KABSD-USR-0031 (telemetry) includes `embedding_space_id` and model revision in results.
- Ensure KABSD-USR-0034 (benchmark harness) compares multiple `embedding_space_id` runs.
- Optional (future): research Option C as a non-default experiment, producing an ADR addendum
  if the evidence supports safe aliasing beyond strict equality.
# Options Considered

# Pros / Cons

# Consequences

# Follow-ups
