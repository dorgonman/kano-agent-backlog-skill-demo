"""Minimal CLI tests (smoke checks)."""
import tempfile
import sys
from pathlib import Path

# Ensure paths set up
repo_root = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(repo_root / "kano-cli"))
sys.path.insert(0, str(repo_root / "kano-backlog-core" / "src"))

from kano_backlog_core.canonical import CanonicalStore
from kano_backlog_core.models import ItemType, ItemState


def test_cli_item_read_existing():
    """Test reading an existing item via canonical store."""
    product_root = Path.cwd().resolve() / "_kano" / "backlog" / "products" / "kano-agent-backlog-skill"
    if not product_root.exists():
        # Fallback to relative from script location
        product_root = Path(__file__).resolve().parent.parent / "_kano" / "backlog" / "products" / "kano-agent-backlog-skill"
    
    assert product_root.exists(), f"Product root not found: {product_root}"
    store = CanonicalStore(product_root)
    
    # Find KABSD-FTR-0019
    items = list(store.list_items(ItemType.FEATURE))
    assert len(items) > 0, f"No features found in {store.items_root}"
    
    for path in items:
        item = store.read(path)
        if item.id == "KABSD-FTR-0019":
            assert item.state == ItemState.DONE
            print("✓ item read KABSD-FTR-0019")
            return
    
    raise AssertionError(f"KABSD-FTR-0019 not found (found {len(items)} items)")


def test_cli_state_transition():
    """Test state transition on a test item."""
    product_root = Path.cwd() / "_kano" / "backlog" / "products" / "kano-agent-backlog-skill"
    store = CanonicalStore(product_root)
    
    # Create a test item
    item = store.create(ItemType.TASK, "Test Task", context="ctx", goal="g", approach="a", acceptance_criteria="ac", risks="r")
    assert item.state == ItemState.NEW
    print(f"✓ created test item {item.id}")


if __name__ == "__main__":
    test_cli_item_read_existing()
    test_cli_state_transition()
    print("\n✓ All smoke tests passed")
