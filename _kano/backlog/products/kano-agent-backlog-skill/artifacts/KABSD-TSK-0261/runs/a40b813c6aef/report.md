# Benchmark Report

- Product: kano-agent-backlog-skill
- Agent: opencode
- Corpus fingerprint: a40b813c6aefda94d061d2099155e5eafa4a0002d7b40bad7ff668f9eac443f2

## Pipeline

{"chunking":{"max_tokens":512,"overlap_tokens":32,"target_tokens":256,"version":"chunk-v1"},"embedding":{"dimension":1536,"model":"noop-embedding","provider":"noop"},"tokenizer":{"adapter":"heuristic","max_tokens":8192,"model":"text-embedding-3-small"},"vector":{"backend":"sqlite","collection":"backlog","metric":"cosine"}}

## Document Metrics

- cjk doc-cjk: chunks=1 trimmed=0 tokens=39 inflation=1.0
- en doc-en-long: chunks=1 trimmed=0 tokens=63 inflation=1.0
- en doc-en-short: chunks=1 trimmed=0 tokens=9 inflation=1.0
- mixed doc-mixed: chunks=1 trimmed=0 tokens=24 inflation=1.0
- mixed doc-punct: chunks=1 trimmed=0 tokens=22 inflation=1.0

## Embedding

{"dimension":1536,"items":5,"latency_ms_per_item":0.1845,"model":"noop-embedding","provider":"noop","ran":true}

## Vector

{"backend":"sqlite","indexed_chunks":5,"metric":"cosine","queries":2,"queries_with_expected_hit":2,"ran":true}

