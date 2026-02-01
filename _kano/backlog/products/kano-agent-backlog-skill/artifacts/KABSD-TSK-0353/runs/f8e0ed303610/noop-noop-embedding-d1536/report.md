# Benchmark Report

- Product: kano-agent-backlog-skill
- Agent: opencode
- Corpus fingerprint: f8e0ed303610f6193d22ab21bf4cd72c342221e4cda4154f996365544056a42f

## Pipeline

{"chunking":{"max_tokens":2048,"overlap_tokens":32,"target_tokens":512,"version":"chunk-v1"},"embedding":{"dimension":1536,"model":"noop-embedding","provider":"noop"},"tokenizer":{"adapter":"heuristic","max_tokens":8192,"model":"text-embedding-3-small"},"vector":{"backend":"sqlite","collection":"backlog","metric":"cosine"}}

## Document Metrics

- cjk doc-cjk: chunks=1 trimmed=0 tokens=33 inflation=1.0
- code doc-code: chunks=1 trimmed=0 tokens=349 inflation=1.0
- en doc-en-long: chunks=1 trimmed=0 tokens=552 inflation=1.0
- en doc-en-short: chunks=1 trimmed=0 tokens=14 inflation=1.0
- mixed doc-mixed: chunks=1 trimmed=0 tokens=110 inflation=1.0
- mixed doc-punct: chunks=1 trimmed=0 tokens=26 inflation=1.0

## Embedding

{"dimension":1536,"items":6,"latency_ms_per_item":0.1768,"model":"noop-embedding","provider":"noop","ran":true}

## Vector

Not run

