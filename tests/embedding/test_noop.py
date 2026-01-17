from kano_backlog_core.embedding import (
    NoOpEmbeddingAdapter,
    resolve_embedder,
    EmbeddingResult,
    EmbeddingTelemetry,
    EmbeddingAdapter
)
import pytest

def test_noop_embedding_deterministic():
    adapter = NoOpEmbeddingAdapter(dimension=4)
    text = "hello world"
    results = adapter.embed_batch([text])
    
    assert len(results) == 1
    result = results[0]
    
    assert isinstance(result, EmbeddingResult)
    assert len(result.vector) == 4
    assert isinstance(result.telemetry, EmbeddingTelemetry)
    assert result.telemetry.provider_id == "noop"
    
    # Check determinism
    results2 = adapter.embed_batch([text])
    assert result.vector == results2[0].vector

def test_noop_batch():
    adapter = NoOpEmbeddingAdapter()
    texts = ["one", "two", "three"]
    results = adapter.embed_batch(texts)
    assert len(results) == 3
    assert results[0].vector != results[1].vector

def test_factory_resolve_noop():
    config = {
        "provider": "noop",
        "model": "test-model",
        "dimension": 10
    }
    adapter = resolve_embedder(config)
    assert isinstance(adapter, NoOpEmbeddingAdapter)
    assert adapter.model_name == "test-model"
    # Verify dimension passed through (impl detail check)
    assert adapter._dimension == 10

def test_factory_default():
    config = {}
    adapter = resolve_embedder(config)
    assert isinstance(adapter, NoOpEmbeddingAdapter)
    assert adapter.model_name == "noop-embedding"

def test_factory_unknown():
    with pytest.raises(ValueError):
        resolve_embedder({"provider": "unknown"})
