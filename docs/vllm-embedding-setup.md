# Using vLLM for Self-Hosted Embeddings

This guide shows how to use vLLM or other OpenAI-compatible embedding services with kano-agent-backlog-skill.

## Why Self-Hosted Embeddings?

**Benefits:**
- ✅ **No API costs** - Run locally or on your own infrastructure
- ✅ **Privacy** - Your code never leaves your network
- ✅ **Multilingual** - Use Chinese/Japanese/Korean models (bge, m3e, etc)
- ✅ **Performance** - No network latency for local deployments
- ✅ **Control** - Choose model size vs quality tradeoff

**Use Cases:**
- AAA game studios with proprietary codebases
- Companies with data privacy requirements
- Chinese/multilingual codebases
- High-volume indexing (millions of chunks)

## Supported Services

Any service with OpenAI-compatible API:
- **vLLM** - High-performance inference server
- **Ollama** - Easy local deployment
- **LocalAI** - OpenAI drop-in replacement
- **Text Embeddings Inference** - Hugging Face's solution

## Quick Start with vLLM

### 1. Install vLLM

```bash
pip install vllm
```

### 2. Start vLLM Server

**For English (BGE-base):**
```bash
python -m vllm.entrypoints.openai.api_server \
  --model BAAI/bge-base-en-v1.5 \
  --port 8000
```

**For Chinese (BGE-large-zh):**
```bash
python -m vllm.entrypoints.openai.api_server \
  --model BAAI/bge-large-zh-v1.5 \
  --port 8000
```

**For Multilingual (BGE-M3):**
```bash
python -m vllm.entrypoints.openai.api_server \
  --model BAAI/bge-m3 \
  --port 8000
```

### 3. Update Config

Edit `_kano/backlog/products/<product>/_config/config.toml`:

```toml
[embedding]
provider = "openai"
model = "BAAI/bge-large-zh-v1.5"
dimension = 1024
base_url = "http://localhost:8000/v1"
api_key = "dummy-key"  # vLLM doesn't validate, but required by OpenAI SDK

[vector]
backend = "sqlite"
path = ".cache/vector"
collection = "backlog"
metric = "cosine"

[vector.options]
storage_format = "binary"
```

### 4. Build Vector Index

```bash
# For backlog corpus
kano-backlog embedding build --product <product>

# For repo corpus
kano-backlog chunks build-repo-vectors --storage-format binary
```

### 5. Verify

```bash
# Check metadata file
cat .cache/vectors/repo_chunks.*.meta.json

# Should show:
# "emb": "openai:BAAI/bge-large-zh-v1.5:d1024"
# "base_url": "http://localhost:8000/v1"
```

## Popular Embedding Models

### English Models

| Model | Dimension | Size | MTEB Score | Use Case |
|-------|-----------|------|------------|----------|
| bge-small-en-v1.5 | 384 | 133 MB | 62.17 | Fast, small projects |
| bge-base-en-v1.5 | 768 | 438 MB | 63.55 | Balanced |
| bge-large-en-v1.5 | 1024 | 1.34 GB | 64.23 | Best quality |

### Chinese Models

| Model | Dimension | Size | C-MTEB Score | Use Case |
|-------|-----------|------|--------------|----------|
| bge-small-zh-v1.5 | 512 | 102 MB | 57.82 | Fast, small projects |
| bge-base-zh-v1.5 | 768 | 409 MB | 63.13 | Balanced |
| bge-large-zh-v1.5 | 1024 | 1.30 GB | 64.53 | Best quality |
| m3e-base | 768 | 409 MB | 63.50 | Alternative |

### Multilingual Models

| Model | Dimension | Size | Languages | Use Case |
|-------|-----------|------|-----------|----------|
| bge-m3 | 1024 | 2.27 GB | 100+ | Mixed language codebases |
| multilingual-e5-large | 1024 | 2.24 GB | 100+ | Alternative |

## Configuration Examples

### Example 1: Local vLLM (English)

```toml
[embedding]
provider = "openai"
model = "BAAI/bge-base-en-v1.5"
dimension = 768
base_url = "http://localhost:8000/v1"
api_key = "dummy"
```

### Example 2: Remote vLLM (Chinese)

```toml
[embedding]
provider = "openai"
model = "BAAI/bge-large-zh-v1.5"
dimension = 1024
base_url = "http://gpu-server.internal:8000/v1"
api_key = "your-internal-api-key"
```

### Example 3: Ollama

```toml
[embedding]
provider = "openai"
model = "nomic-embed-text"
dimension = 768
base_url = "http://localhost:11434/v1"
api_key = "dummy"
```

### Example 4: Production OpenAI (fallback)

```toml
[embedding]
provider = "openai"
model = "text-embedding-3-small"
dimension = 1536
# No base_url = use official OpenAI API
# api_key from OPENAI_API_KEY env var
```

## Performance Comparison

**AAA Unreal Project (3M chunks):**

| Setup | Build Time | Storage | Query Time | Cost |
|-------|------------|---------|------------|------|
| OpenAI API | ~6 hours | 18 GB | ~16ms | $60 |
| vLLM (local GPU) | ~2 hours | 18 GB | ~16ms | $0 |
| vLLM (remote GPU) | ~3 hours | 18 GB | ~16ms | $0 |

**Notes:**
- Build time assumes 1 GPU (RTX 4090 or A100)
- Storage with binary format (74.5% savings)
- Query time is similar (local SQLite lookup)

## Troubleshooting

### vLLM server not starting

```bash
# Check GPU availability
nvidia-smi

# Try CPU-only mode (slower)
python -m vllm.entrypoints.openai.api_server \
  --model BAAI/bge-base-en-v1.5 \
  --port 8000 \
  --device cpu
```

### Connection refused

```bash
# Check if server is running
curl http://localhost:8000/v1/models

# Should return:
# {"object":"list","data":[{"id":"BAAI/bge-base-en-v1.5",...}]}
```

### Wrong dimension error

```bash
# Check model dimension
curl http://localhost:8000/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{"model":"BAAI/bge-base-en-v1.5","input":"test"}'

# Count the vector length in response
# Update config.toml dimension to match
```

### Metadata shows wrong embedding_space_id

```bash
# Delete old index
rm .cache/vectors/repo_chunks.*.sqlite3
rm .cache/vectors/repo_chunks.*.meta.json

# Rebuild with new config
kano-backlog chunks build-repo-vectors --storage-format binary --force
```

## Advanced: GPU Optimization

### Multi-GPU Setup

```bash
# Use tensor parallelism for large models
python -m vllm.entrypoints.openai.api_server \
  --model BAAI/bge-m3 \
  --port 8000 \
  --tensor-parallel-size 2  # Use 2 GPUs
```

### Batch Size Tuning

```bash
# Increase batch size for throughput
python -m vllm.entrypoints.openai.api_server \
  --model BAAI/bge-large-zh-v1.5 \
  --port 8000 \
  --max-num-batched-tokens 8192  # Default: 2048
```

### Quantization (Experimental)

```bash
# Use 8-bit quantization to save VRAM
python -m vllm.entrypoints.openai.api_server \
  --model BAAI/bge-large-zh-v1.5 \
  --port 8000 \
  --quantization awq  # or gptq
```

## References

- [vLLM Documentation](https://docs.vllm.ai/)
- [BGE Models](https://huggingface.co/BAAI)
- [MTEB Leaderboard](https://huggingface.co/spaces/mteb/leaderboard)
- [OpenAI Embeddings API](https://platform.openai.com/docs/api-reference/embeddings)
