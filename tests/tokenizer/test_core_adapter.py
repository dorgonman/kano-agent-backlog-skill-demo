from unittest.mock import MagicMock, patch
import pytest
from kano_backlog_core.tokenizer import (
    HeuristicTokenizer,
    TiktokenAdapter,
    resolve_tokenizer,
    TokenCount
)

def test_heuristic_tokenizer():
    adapter = HeuristicTokenizer(model_name="test-model")
    # "test" is 1 token (alpha)
    assert adapter.count_tokens("test").count > 0
    assert adapter.count_tokens("").count == 0
    
    assert adapter.max_tokens() > 0

def test_resolve_tokenizer_heuristic():
    adapter = resolve_tokenizer("heuristic", "model")
    assert isinstance(adapter, HeuristicTokenizer)

def test_resolve_tokenizer_tiktoken_mocked():
    # Helper to simulate tiktoken missing or present
    with patch.dict("sys.modules", {"tiktoken": MagicMock()}):
        # We need to ensure TiktokenAdapter can be instantiated
        # But TiktokenAdapter does import inside __init__
        pass

def test_tiktoken_adapter_mocked():
    mock_pkg = MagicMock()
    mock_encoding = MagicMock()
    mock_encoding.encode.return_value = [1, 2, 3]
    mock_pkg.encoding_for_model.return_value = mock_encoding
    
    with patch.dict("sys.modules", {"tiktoken": mock_pkg}):
        adapter = TiktokenAdapter(model_name="gpt-4")
        assert adapter.count_tokens("some text").count == 3
        mock_encoding.encode.assert_called_with("some text", disallowed_special=())

def test_resolve_tokenizer_tiktoken():
    with patch.dict("sys.modules", {"tiktoken": MagicMock()}):
        adapter = resolve_tokenizer("tiktoken", "gpt-4")
        assert isinstance(adapter, TiktokenAdapter)

def test_resolve_tokenizer_unknown():
    with pytest.raises(ValueError):
        resolve_tokenizer("unknown", "model")
