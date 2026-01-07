"""Tests for config module."""

import pytest
from pathlib import Path
from kano_backlog_core.config import ConfigLoader, BacklogContext
from kano_backlog_core.errors import ConfigError


def test_backlog_context_model():
    """Test BacklogContext Pydantic model."""
    ctx = BacklogContext(
        platform_root=Path("/workspace"),
        backlog_root=Path("/workspace/_kano/backlog"),
        product_root=Path("/workspace/_kano/backlog/products/test-product"),
        product_name="test-product",
    )
    assert ctx.platform_root == Path("/workspace")
    assert ctx.product_name == "test-product"


def test_config_loader_find_platform_root(tmp_path):
    """Test _find_platform_root walks up directory tree."""
    # Create structure: tmp/_kano/backlog/products/test/deep/path
    backlog_root = tmp_path / "_kano" / "backlog"
    backlog_root.mkdir(parents=True)
    deep_path = backlog_root / "products" / "test" / "deep" / "path"
    deep_path.mkdir(parents=True)

    # Should find backlog_root
    found = ConfigLoader._find_platform_root(deep_path)
    assert found == backlog_root


def test_config_loader_find_platform_root_not_found(tmp_path):
    """Test _find_platform_root returns None when not found."""
    found = ConfigLoader._find_platform_root(tmp_path)
    assert found is None


def test_config_loader_infer_product(tmp_path):
    """Test _infer_product extracts product name from path."""
    backlog_root = tmp_path / "_kano" / "backlog"
    products_root = backlog_root / "products"
    product_root = products_root / "my-product"
    product_root.mkdir(parents=True)

    product_name = ConfigLoader._infer_product(product_root, backlog_root)
    assert product_name == "my-product"


def test_config_loader_from_path(tmp_path):
    """Test from_path resolves context correctly."""
    backlog_root = tmp_path / "_kano" / "backlog"
    product_root = backlog_root / "products" / "test-product"
    items_dir = product_root / "items" / "tasks" / "0000"
    items_dir.mkdir(parents=True)

    ctx = ConfigLoader.from_path(items_dir)
    assert ctx.backlog_root == backlog_root
    assert ctx.platform_root == tmp_path
    assert ctx.product_name == "test-product"
    assert ctx.product_root == product_root


def test_config_loader_load_defaults(tmp_path):
    """Test load_defaults parses JSON."""
    backlog_root = tmp_path / "_kano" / "backlog"
    shared_dir = backlog_root / "_shared"
    shared_dir.mkdir(parents=True)
    defaults_json = shared_dir / "defaults.json"
    defaults_json.write_text('{"priority": "Medium", "owner": "team"}')

    defaults = ConfigLoader.load_defaults(backlog_root)
    assert defaults["priority"] == "Medium"
    assert defaults["owner"] == "team"


def test_config_loader_load_defaults_not_found(tmp_path):
    """Test load_defaults returns empty dict when file missing."""
    backlog_root = tmp_path / "_kano" / "backlog"
    backlog_root.mkdir(parents=True)
    defaults = ConfigLoader.load_defaults(backlog_root)
    assert defaults == {}
