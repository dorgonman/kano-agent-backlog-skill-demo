from __future__ import annotations

import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
CORE_SRC = ROOT / "skills" / "kano-agent-backlog-skill" / "src"
sys.path.insert(0, str(CORE_SRC))

from kano_backlog_core.vector import get_backend  # noqa: E402
from kano_backlog_core.vector.types import VectorChunk  # noqa: E402


def test_sqlite_backend_persist_load_query_consistent(tmp_path: Path) -> None:
    base = tmp_path / "vector"

    cfg = {
        "backend": "sqlite",
        "path": str(base),
        "collection": "backlog",
        "embedding_space_id": "emb:noop:noop:d4|tok:heuristic:noop:max16|chunk:chunk-v1|metric:cosine",
    }

    backend = get_backend(cfg)
    backend.prepare(schema={}, dims=4, metric="cosine")

    backend.upsert(
        VectorChunk(
            chunk_id="c1",
            text="hello",
            metadata={"source_id": "S1"},
            vector=[1.0, 0.0, 0.0, 0.0],
        )
    )
    backend.upsert(
        VectorChunk(
            chunk_id="c2",
            text="world",
            metadata={"source_id": "S2"},
            vector=[0.0, 1.0, 0.0, 0.0],
        )
    )

    backend.persist()

    backend2 = get_backend(cfg)
    backend2.load()

    results = backend2.query([1.0, 0.0, 0.0, 0.0], k=2)
    assert [r.chunk_id for r in results] == ["c1", "c2"]
    assert results[0].metadata["source_id"] == "S1"


def test_sqlite_backend_dim_mismatch_raises(tmp_path: Path) -> None:
    base = tmp_path / "vector"

    cfg = {
        "backend": "sqlite",
        "path": str(base),
        "collection": "backlog",
        "embedding_space_id": "emb:noop:noop:d3|tok:heuristic:noop:max16|chunk:chunk-v1|metric:cosine",
    }

    backend = get_backend(cfg)
    backend.prepare(schema={}, dims=3, metric="cosine")

    with pytest.raises(ValueError):
        backend.upsert(
            VectorChunk(
                chunk_id="c1",
                text="bad",
                metadata={},
                vector=[1.0, 0.0, 0.0, 0.0],
            )
        )


def test_sqlite_backend_prepare_rejects_existing_dim_mismatch(tmp_path: Path) -> None:
    base = tmp_path / "vector"

    cfg = {
        "backend": "sqlite",
        "path": str(base),
        "collection": "backlog",
        "embedding_space_id": "emb:noop:noop:d4|tok:heuristic:noop:max16|chunk:chunk-v1|metric:cosine",
    }

    backend = get_backend(cfg)
    backend.prepare(schema={}, dims=4, metric="cosine")
    backend.persist()

    backend2 = get_backend(cfg)
    with pytest.raises(ValueError):
        backend2.prepare(schema={}, dims=3, metric="cosine")
