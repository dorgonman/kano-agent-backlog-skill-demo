"""Tests for canonical store."""

import pytest
from pathlib import Path
from datetime import date
from kano_backlog_core.canonical import CanonicalStore
from kano_backlog_core.models import BacklogItem, ItemType, ItemState
from kano_backlog_core.errors import ItemNotFoundError, ParseError, ValidationError, WriteError


@pytest.fixture
def temp_product_root(tmp_path):
    """Create a temporary product root."""
    product_root = tmp_path / "products" / "test-product"
    product_root.mkdir(parents=True)
    return product_root


@pytest.fixture
def store(temp_product_root):
    """Create a CanonicalStore instance."""
    return CanonicalStore(temp_product_root)


def test_canonical_store_init(temp_product_root):
    """Test CanonicalStore initialization."""
    store = CanonicalStore(temp_product_root)
    assert store.product_root == temp_product_root
    assert store.items_root == temp_product_root / "items"


def test_create_item(store, temp_product_root):
    """Test creating a new item with auto-generated fields."""
    item = store.create(
        item_type=ItemType.TASK,
        title="Test Task",
        parent="KABSD-FTR-0001",
        priority="High",
        tags=["test"],
    )

    assert item.id.startswith("KABSD-TSK-")
    assert item.uid  # UUIDv7
    assert item.title == "Test Task"
    assert item.type == ItemType.TASK
    assert item.state == ItemState.NEW
    assert item.parent == "KABSD-FTR-0001"
    assert item.priority == "High"
    assert item.tags == ["test"]
    assert item.created == date.today().isoformat()
    assert item.file_path.name.startswith("KABSD-TSK-")
    assert "test-task" in item.file_path.name


def test_write_and_read_item(store, temp_product_root):
    """Test writing and reading an item."""
    # Create and write
    item = store.create(ItemType.BUG, "Fix crash", priority="Critical")
    item.context = "App crashes on startup"
    item.goal = "Fix the crash"
    item.worklog = ["2024-01-01 - Created item"]

    store.write(item)

    assert item.file_path.exists()

    # Read back
    read_item = store.read(item.file_path)
    assert read_item.id == item.id
    assert read_item.uid == item.uid
    assert read_item.title == "Fix crash"
    assert read_item.type == ItemType.BUG
    assert read_item.priority == "Critical"
    assert read_item.context == "App crashes on startup"
    assert read_item.goal == "Fix the crash"
    assert len(read_item.worklog) == 1


def test_read_nonexistent_item(store, temp_product_root):
    """Test reading a nonexistent item raises ItemNotFoundError."""
    with pytest.raises(ItemNotFoundError):
        store.read(temp_product_root / "items" / "tasks" / "0000" / "nonexistent.md")


def test_validate_schema_valid(store):
    """Test validate_schema returns empty list for valid item."""
    item = store.create(ItemType.FEATURE, "New Feature")
    errors = store.validate_schema(item)
    assert errors == []


def test_validate_schema_invalid(store):
    """Test validate_schema catches invalid data."""
    item = BacklogItem(
        id="INVALID-ID",
        uid="not-a-uuid",
        type=ItemType.TASK,
        title="",
        state=ItemState.NEW,
        created="2024-13-99",  # Invalid date
        updated="2024-01-01",
    )
    errors = store.validate_schema(item)
    assert len(errors) > 0
    assert any("Invalid id format" in e for e in errors)
    assert any("Invalid uid format" in e for e in errors)
    assert any("Invalid created date" in e for e in errors)


def test_list_items_by_type(store, temp_product_root):
    """Test listing items filtered by type."""
    # Create multiple items
    task1 = store.create(ItemType.TASK, "Task 1")
    task2 = store.create(ItemType.TASK, "Task 2")
    bug1 = store.create(ItemType.BUG, "Bug 1")

    store.write(task1)
    store.write(task2)
    store.write(bug1)

    # List tasks
    task_paths = store.list_items(ItemType.TASK)
    assert len(task_paths) == 2
    assert all("tasks" in str(p) for p in task_paths)

    # List bugs
    bug_paths = store.list_items(ItemType.BUG)
    assert len(bug_paths) == 1
    assert "bugs" in str(bug_paths[0])


def test_list_all_items(store, temp_product_root):
    """Test listing all items without filter."""
    task = store.create(ItemType.TASK, "Task")
    feature = store.create(ItemType.FEATURE, "Feature")

    store.write(task)
    store.write(feature)

    all_paths = store.list_items()
    assert len(all_paths) == 2


def test_slugify():
    """Test _slugify generates valid slugs."""
    assert CanonicalStore._slugify("Hello World") == "hello-world"
    assert CanonicalStore._slugify("Test: Special!") == "test-special"
    assert CanonicalStore._slugify("Multiple   Spaces") == "multiple-spaces"
    slug = CanonicalStore._slugify("A" * 100)
    assert len(slug) <= 50


def test_get_next_id_number(store, temp_product_root):
    """Test _get_next_id_number finds highest existing ID."""
    # First item
    assert store._get_next_id_number(ItemType.TASK) == 1

    # Create an item
    item = store.create(ItemType.TASK, "First task")
    store.write(item)

    # Next should be 2
    assert store._get_next_id_number(ItemType.TASK) == 2


def test_parse_body_sections(store):
    """Test _parse_body extracts sections correctly."""
    body = """# Context

This is context.

# Goal

This is the goal.

# Worklog

2024-01-01 - First entry
2024-01-02 - Second entry
"""
    sections = store._parse_body(body)
    assert sections["context"] == "This is context."
    assert sections["goal"] == "This is the goal."
    assert len(sections["worklog"]) == 2
    assert "2024-01-01" in sections["worklog"][0]


def test_write_updates_timestamp(store):
    """Test write() updates the updated field."""
    item = store.create(ItemType.TASK, "Test")
    item.updated = "2020-01-01"  # Old date

    store.write(item)

    # Should be updated to today
    read_item = store.read(item.file_path)
    assert read_item.updated == date.today().isoformat()


def test_write_invalid_item_raises_validation_error(store):
    """Test write() raises ValidationError for invalid items."""
    item = BacklogItem(
        id="BAD-FORMAT",
        uid="not-uuid",
        type=ItemType.TASK,
        title="Test",
        state=ItemState.NEW,
        created="2024-01-01",
        updated="2024-01-01",
        file_path=store.items_root / "tasks" / "0000" / "test.md",
    )

    with pytest.raises(ValidationError):
        store.write(item)
