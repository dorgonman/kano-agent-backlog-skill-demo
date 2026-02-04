# Embedding Search Benchmark (0.0.3)

This document summarizes the embedding search benchmark run for 0.0.3.

**Source report (sandbox topic publish)**
- `_kano/backlog_sandbox/_tmp_tests/guide_test_backlog/topics/embedding-search-benchmark-0-0-3/publish/benchmark_embedding_search.md`

## Profiles Compared

- noop: `skills/kano-agent-backlog-skill/profiles/embedding/local-noop.toml`
- gemini: `skills/kano-agent-backlog-skill/profiles/embedding/gemini-embedding-001.toml`
- sentence-transformers (MiniLM): `skills/kano-agent-backlog-skill/profiles/embedding/local-sentence-transformers-minilm.toml`

## Results (from report.md)

| Profile | Provider | Dim | Latency ms/item | Expected hits | Backend |
|---|---|---:|---:|---:|---|
| local-noop | noop | 1536 | 0.1729 | 0 / 7 | noop |
| gemini-embedding-001 | gemini | 3072 | 247.3259 | 7 / 7 | sqlite |
| sentence-transformers MiniLM | sentence-transformers | 384 | 1283.2557 | 7 / 7 | sqlite |

## Pros / Cons

### noop
**Pros**
- Fastest; useful for pipeline wiring and schema validation

**Cons**
- Not a real embedding; no meaningful retrieval (0 expected hits)

### gemini-embedding-001
**Pros**
- Correct expected hits on this benchmark
- Moderate latency per item for a hosted API

**Cons**
- Requires API key + billing; subject to rate limits
- Cost per request

### sentence-transformers MiniLM (local)
**Pros**
- Correct expected hits on this benchmark
- Fully local (no API cost)

**Cons**
- Higher per-item latency on this run
- Model download / local compute requirements

## Commands Executed

```bash
# noop
python skills/kano-agent-backlog-skill/scripts/kano-backlog benchmark run \
  --agent opencode \
  --profile "skills/kano-agent-backlog-skill/profiles/embedding/local-noop.toml" \
  --mode embed+vector \
  --out "_kano/backlog_sandbox/_tmp_tests/guide_test_backlog/topics/embedding-search-benchmark-0-0-3/publish/benchmark_runs"

# gemini (uses env/local.secrets.env)
python skills/kano-agent-backlog-skill/scripts/kano-backlog --env-file "env/local.secrets.env" benchmark run \
  --agent opencode \
  --profile "skills/kano-agent-backlog-skill/profiles/embedding/gemini-embedding-001.toml" \
  --mode embed+vector \
  --out "_kano/backlog_sandbox/_tmp_tests/guide_test_backlog/topics/embedding-search-benchmark-0-0-3/publish/benchmark_runs"

# sentence-transformers (MiniLM)
python skills/kano-agent-backlog-skill/scripts/kano-backlog benchmark run \
  --agent opencode \
  --profile "skills/kano-agent-backlog-skill/profiles/embedding/local-sentence-transformers-minilm.toml" \
  --mode embed+vector \
  --out "_kano/backlog_sandbox/_tmp_tests/guide_test_backlog/topics/embedding-search-benchmark-0-0-3/publish/benchmark_runs"
```
