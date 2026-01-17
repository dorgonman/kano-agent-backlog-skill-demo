import pytest
from kano_backlog_core.pipeline_config import PipelineConfig

def test_pipeline_config_defaults():
    config_dict = {}
    pc = PipelineConfig.from_dict(config_dict)
    
    assert pc.chunking.target_tokens == 256
    assert pc.tokenizer.adapter == "heuristic"
    assert pc.embedding.provider == "noop"
    assert pc.vector.backend == "noop"
    
    # constant max tokens check 
    # (chunking default is 512, model default is 8192 usually, so valid)
    pc.validate()

def test_pipeline_config_valid_override():
    config_dict = {
        "chunking": {"target_tokens": 100},
        "tokenizer": {"adapter": "heuristic", "model": "text-embedding-3-large"},
        "embedding": {"provider": "noop", "dimension": 128},
        "vector": {"backend": "noop", "metric": "l2"}
    }
    pc = PipelineConfig.from_dict(config_dict)
    assert pc.chunking.target_tokens == 100
    assert pc.tokenizer.model == "text-embedding-3-large"
    assert pc.embedding.dimension == 128
    assert pc.vector.metric == "l2"
    pc.validate()

def test_pipeline_config_invalid_tokenizer():
    config_dict = {
        "tokenizer": {"adapter": "unknown_adapter"}
    }
    pc = PipelineConfig.from_dict(config_dict)
    with pytest.raises(ValueError, match="Unknown tokenizer adapter"):
        pc.validate()

def test_pipeline_config_invalid_embedder():
    config_dict = {
        "embedding": {"provider": "unknown_provider"}
    }
    pc = PipelineConfig.from_dict(config_dict)
    with pytest.raises(ValueError, match="Unknown embedding provider"):
        pc.validate()
