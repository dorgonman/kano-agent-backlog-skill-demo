# Benchmark Report

- Product: kano-agent-backlog-skill
- Agent: opencode
- Corpus fingerprint: f8e0ed303610f6193d22ab21bf4cd72c342221e4cda4154f996365544056a42f

## Pipeline

{"chunking":{"max_tokens":2048,"overlap_tokens":32,"target_tokens":512,"version":"chunk-v1"},"embedding":{"dimension":384,"model":"sentence-transformers/all-MiniLM-L6-v2","provider":"sentence-transformers"},"tokenizer":{"adapter":"huggingface","max_tokens":512,"model":"bert-base-uncased"},"vector":{"backend":"sqlite","collection":"backlog","metric":"cosine"}}

## Document Metrics

- cjk doc-cjk: chunks=1 trimmed=0 tokens=41 inflation=1.2424
- code doc-code: chunks=1 trimmed=0 tokens=341 inflation=0.9771
- en doc-en-long: chunks=1 trimmed=0 tokens=362 inflation=0.6558
- en doc-en-short: chunks=1 trimmed=0 tokens=12 inflation=0.8571
- mixed doc-mixed: chunks=1 trimmed=0 tokens=91 inflation=0.8273
- mixed doc-punct: chunks=1 trimmed=0 tokens=30 inflation=1.1538

## Embedding

{"dimension":384,"items":6,"latency_ms_per_item":718.6506,"model":"sentence-transformers/all-MiniLM-L6-v2","provider":"sentence-transformers","ran":true}

## Vector

{"backend":"sqlite","indexed_chunks":6,"metric":"cosine","queries":7,"queries_with_expected_hit":7,"ran":true}

