"""Tests for Derived module (InMemoryDerivedStore)."""

import pytest
from pathlib import Path
from kano_backlog_core.canonical import CanonicalStore
from kano_backlog_core.derived import InMemoryDerivedStore, QueryFilter
from kano_backlog_core.models import ItemType, ItemState


@pytest.fixture
def temp_product_root(tmp_path):
    product_root = tmp_path / "products" / "test-product"
    product_root.mkdir(parents=True)
    return product_root


@pytest.fixture
def canonical(temp_product_root):
    return CanonicalStore(temp_product_root)


@pytest.fixture
def store(canonical):
    # Seed some items
    t1 = canonical.create(ItemType.TASK, "Write tests", priority="P1", tags=["test"], owner="alice")
    t1.state = ItemState.IN_PROGRESS
    t1.context = "We need tests"
    canonical.write(t1)

    t2 = canonical.create(ItemType.TASK, "Fix bug", priority="P0", tags=["bug"], owner="bob")
    t2.state = ItemState.DONE
    t2.goal = "resolve crash"
    canonical.write(t2)

    f1 = canonical.create(ItemType.FEATURE, "Search feature", priority="P2", tags=["feature"], owner="alice")
    f1.state = ItemState.READY
    f1.goal = "add search"
    canonical.write(f1)

    b1 = canonical.create(ItemType.BUG, "Startup crash", priority="P0", tags=["bug", "urgent"], owner="bob")
    b1.state = ItemState.NEW
    b1.context = "app crashes"
    canonical.write(b1)

    return InMemoryDerivedStore(canonical)


def test_list_items(store):
    items = store.list_items()
    assert len(items) == 4


def test_filters_by_type(store):
    tasks = store.list_items(QueryFilter(item_type=ItemType.TASK))
    assert all(i.type == ItemType.TASK for i in tasks)


def test_filters_by_state(store):
    ready_items = store.get_by_state(ItemState.READY)
    assert len(ready_items) == 1
    assert ready_items[0].title == "Search feature"


def test_get_by_id_and_uid(store):
    items = store.list_items()
    first = items[0]
    by_id = store.get_by_id(first.id)
    by_uid = store.get_by_uid(first.uid)
    assert by_id is not None and by_id.id == first.id
    assert by_uid is not None and by_uid.uid == first.uid


def test_search_title_context_goal(store):
    # title
    res = store.search("search feature")
    assert any(i.title == "Search feature" for i in res)
    # context
    res = store.search("crashes")
    assert any(i.title == "Startup crash" for i in res)
    # goal
    res = store.search("resolve crash")
    assert any(i.title == "Fix bug" for i in res)


def test_get_by_owner(store):
    alice_items = store.get_by_owner("alice")
    assert len(alice_items) >= 2


def test_get_children(store, canonical):
    parent = canonical.create(ItemType.FEATURE, "Parent feature")
    canonical.write(parent)

    child = canonical.create(ItemType.TASK, "Child task", parent=parent.id)
    canonical.write(child)

    store.refresh()
    children = store.get_children(parent.id)
    assert len(children) == 1
    assert children[0].parent == parent.id


def test_get_by_tags(store):
    urgent = store.get_by_tags(["urgent"])  
    assert any(i.title == "Startup crash" for i in urgent)


def test_stats(store):
    stats = store.stats()
    assert stats["total_items"] >= 4
    assert "by_state" in stats and "by_type" in stats and "by_owner" in stats
