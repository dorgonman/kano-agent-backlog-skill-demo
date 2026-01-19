---
id: ADR-0035
uid: 019bd257-f1b9-7086-ac8f-efc7c88120c6
title: "Cross-lingual retrieval requirement and default embedding policy"
status: Accepted
date: 2026-01-19
related_items: ["KABSD-USR-0035"]
supersedes: null
superseded_by: null
---

# Decision

Cross-lingual retrieval is a requirement.

Default embedding policy must be multilingual-capable. Provider/model choices must be evaluated against a small multilingual benchmark corpus that includes CJK and mixed-language queries.

# Context

This repo's backlog contains mixed-language content (English + CJK). The semantic retrieval system is local-first and derived from canonical Markdown (see ADR-0009).

If we choose an embedder that is not multilingual-capable, cross-lingual queries will fail or regress unpredictably, and benchmark results will not reflect real usage.

# Options Considered

## Option A: English-only retrieval

Treat cross-lingual retrieval as out-of-scope. Only optimize for English content.

## Option B: Cross-lingual retrieval required (multilingual embedder policy) [chosen]

Require cross-lingual retrieval and evaluate embedders using multilingual cases.

# Pros / Cons

## Option A: English-only retrieval

Pros:
- Potentially smaller/faster embedding models.

Cons:
- Fails for mixed-language backlog content.
- Forces users to translate queries manually.
- Makes retrieval quality brittle as content language mix evolves.

## Option B: Cross-lingual retrieval required

Pros:
- Matches repository reality (mixed-language artifacts).
- Makes evaluation criteria explicit and repeatable.

Cons:
- May increase model footprint/cost.
- Requires benchmark coverage for multilingual/cross-lingual cases.

# Consequences

1) Benchmarks MUST include cross-lingual cases.
- The benchmark harness (USR-0034) must include multilingual docs and cross-lingual queries.

2) Telemetry MUST capture tokenizer behavior and truncation.
- Token inflation for CJK can reduce effective context windows.
- Telemetry must distinguish exact vs heuristic token counts (see tokenizer TokenCount).

3) Default embedder configuration is allowed to be "noop" for local tests.
- Real embedders remain optional dependencies.
- Decisions about a real default model should be benchmark-driven.

# Follow-ups

- Keep ADR-0036 aligned: per-model indexes are required for safe experimentation and rollback.
- Use `kano-backlog benchmark run` outputs under `_kano/backlog/products/<product>/artifacts/KABSD-TSK-0261/runs/` as the evidence trail for model selection.

