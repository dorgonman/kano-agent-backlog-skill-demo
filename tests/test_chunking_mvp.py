"""
Deterministic MVP chunking tests (ASCII short, long English, CJK).

Feature: chunking-token-budget-embeddings, MVP acceptance cases
"""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CORE_SRC = ROOT / "skills" / "kano-agent-backlog-skill" / "src"
sys.path.insert(0, str(CORE_SRC))

from kano_backlog_core import (  # noqa: E402
    ChunkingOptions,
    HeuristicTokenizer,
    TokenBudgetPolicy,
    chunk_text,
    enforce_token_budget,
)


def test_ascii_short_single_chunk_no_trim() -> None:
    text = "Short ASCII paragraph."
    options = ChunkingOptions(target_tokens=50, max_tokens=80, overlap_tokens=10)
    chunks = chunk_text("doc-ascii", text, options)

    assert len(chunks) == 1
    assert chunks[0].text == text

    tokenizer = HeuristicTokenizer("text-embedding-3-small")
    result = enforce_token_budget(text, tokenizer, max_tokens=512)
    assert result.trimmed is False
    assert result.content == text

    chunks_again = chunk_text("doc-ascii", text, options)
    assert [c.chunk_id for c in chunks] == [c.chunk_id for c in chunks_again]


def test_long_english_multiple_chunks_deterministic_ids() -> None:
    sentence = "This is a long sentence intended for chunking."
    text = " ".join([sentence] * 40)
    options = ChunkingOptions(target_tokens=20, max_tokens=28, overlap_tokens=5)

    chunks = chunk_text("doc-english", text, options)
    assert len(chunks) > 1

    for i in range(1, len(chunks)):
        assert chunks[i].start_char < chunks[i - 1].end_char

    chunks_again = chunk_text("doc-english", text, options)
    assert [c.chunk_id for c in chunks] == [c.chunk_id for c in chunks_again]


def test_cjk_trimming_budget() -> None:
    text = "你好世界再來一句測試段落"
    tokenizer = HeuristicTokenizer("text-embedding-3-small")
    policy = TokenBudgetPolicy(safety_margin_ratio=0.1, safety_margin_min_tokens=1)

    result = enforce_token_budget(text, tokenizer, max_tokens=8, policy=policy)
    assert result.trimmed is True
    assert result.token_count.count <= result.target_budget
