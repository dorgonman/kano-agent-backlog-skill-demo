from __future__ import annotations

"""Vector adapter tests.

Note: This file name is intentionally unique to avoid pytest import collisions
with other test modules named 'test_adapter.py' in submodules.
"""

from kano_backlog_core.vector.adapter import VectorBackendAdapter
from kano_backlog_core.vector.factory import get_backend
from kano_backlog_core.vector.types import VectorChunk


def test_vector_factory_returns_noop() -> None:
    backend = get_backend({})
    assert backend is not None
    assert isinstance(backend, VectorBackendAdapter)

    backend.upsert(VectorChunk(chunk_id="test", text="foo"))
    results = backend.query([1.0, 2.0])
    assert results == []


def test_vector_factory_raises_unknown() -> None:
    try:
        get_backend({"backend": "invalid_one"})
        assert False, "Should have raised ValueError"
    except ValueError:
        pass


def test_vector_chunk_dataclass() -> None:
    c = VectorChunk(chunk_id="123", text="abc", metadata={"a": 1})
    assert c.chunk_id == "123"
    assert c.metadata["a"] == 1
    assert c.vector is None

