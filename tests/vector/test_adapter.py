from kano_backlog_cli.vector.adapter import VectorBackendAdapter
from kano_backlog_cli.vector.factory import get_backend
from kano_backlog_cli.vector.types import VectorChunk


def test_factory_returns_noop():
    backend = get_backend({})
    assert backend is not None
    assert isinstance(backend, VectorBackendAdapter)
    # Check it handles calls gracefully
    backend.upsert(VectorChunk(chunk_id="test", text="foo"))
    results = backend.query([1.0, 2.0])
    assert results == []


def test_factory_raises_unknown():
    try:
        get_backend({"backend": "invalid_one"})
        assert False, "Should have raised ValueError"
    except ValueError:
        pass


def test_chunk_dataclass():
    c = VectorChunk(chunk_id="123", text="abc", metadata={"a": 1})
    assert c.chunk_id == "123"
    assert c.metadata["a"] == 1
    assert c.vector is None
