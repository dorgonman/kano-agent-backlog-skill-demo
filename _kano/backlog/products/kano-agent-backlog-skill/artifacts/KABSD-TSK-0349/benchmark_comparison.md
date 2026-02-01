# KABSD-TSK-0349 Benchmark: OpenAI vs sentence-transformers

This benchmark uses the deterministic harness `kano-backlog benchmark run` with the fixed fixture corpus and query set:

- Corpus: `skills/kano-agent-backlog-skill/tests/fixtures/benchmark_corpus.json`
- Queries: `skills/kano-agent-backlog-skill/tests/fixtures/benchmark_queries.json`

The harness writes one run directory per:

- corpus fingerprint (first 12 chars)
- embedding id (provider + model + dimension)

## Runs

### Local: sentence-transformers (baseline)

- Profile: `embedding/local-sentence-transformers-minilm`
- Run directory:
  `_kano/backlog/products/kano-agent-backlog-skill/artifacts/KABSD-TSK-0349/runs/f8e0ed303610/sentence-transformers-sentence-transformers-all-MiniLM-L6-v2-d384/`
- Report (Markdown):
  `_kano/backlog/products/kano-agent-backlog-skill/artifacts/KABSD-TSK-0349/runs/f8e0ed303610/sentence-transformers-sentence-transformers-all-MiniLM-L6-v2-d384/report.md`

Key metrics (from `report.json`):

- embedding: provider=`sentence-transformers`, model=`sentence-transformers/all-MiniLM-L6-v2`, dim=384
- embedding: items=6, latency_ms_per_item=718.6506
- vector: backend=`sqlite`, metric=`cosine`, indexed_chunks=6
- vector: sanity queries=7, queries_with_expected_hit=7

Note: this is a cold run (includes model load). If we need warm numbers, rerun once and compare the second run.

### Paid: OpenAI (pending)

- Profile: `embedding/openai-text-embedding-3-small`
- Run directory:
  `_kano/backlog/products/kano-agent-backlog-skill/artifacts/KABSD-TSK-0349/runs/f8e0ed303610/openai-text-embedding-3-small-d1536/`
- Report (Markdown):
  `_kano/backlog/products/kano-agent-backlog-skill/artifacts/KABSD-TSK-0349/runs/f8e0ed303610/openai-text-embedding-3-small-d1536/report.md`

Key metrics (from `report.json`):

- embedding: provider=`openai`, model=`text-embedding-3-small`, dim=1536
- embedding: items=6, latency_ms_per_item=475.0397
- vector: backend=`sqlite`, metric=`cosine`, indexed_chunks=6
- vector: sanity queries=7, queries_with_expected_hit=6

## Repro steps

### 1) Local sentence-transformers

```bash
./.venv/Scripts/python skills/kano-agent-backlog-skill/scripts/kano-backlog benchmark run \
  --product kano-agent-backlog-skill \
  --agent opencode \
  --profile embedding/local-sentence-transformers-minilm \
  --mode embed+vector \
  --item-id KABSD-TSK-0349
```

### 2) OpenAI

Set the key (do not commit it):

PowerShell:

```powershell
$env:OPENAI_API_KEY = "..."
```

bash:

```bash
export OPENAI_API_KEY="..."
```

Run:

```bash
./.venv/Scripts/python skills/kano-agent-backlog-skill/scripts/kano-backlog benchmark run \
  --product kano-agent-backlog-skill \
  --agent opencode \
  --profile embedding/openai-text-embedding-3-small \
  --mode embed+vector \
  --item-id KABSD-TSK-0349
```

After both runs exist, update this file with the OpenAI run path and the same key metrics.
