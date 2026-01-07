"""Tests for Refs module (RefParser, RefResolver)."""

import pytest
from pathlib import Path
from kano_backlog_core.canonical import CanonicalStore
from kano_backlog_core.derived import InMemoryDerivedStore
from kano_backlog_core.refs import RefParser, RefResolver
from kano_backlog_core.models import ItemType, ItemState
from kano_backlog_core.errors import RefNotFoundError, ParseError


@pytest.fixture
def setup_store(tmp_path):
    product_root = tmp_path / "products" / "test-product"
    product_root.mkdir(parents=True)
    canonical = CanonicalStore(product_root)

    # Seed items
    t1 = canonical.create(ItemType.TASK, "Ref test task")
    canonical.write(t1)
    b1 = canonical.create(ItemType.BUG, "Ref test bug")
    canonical.write(b1)

    derived = InMemoryDerivedStore(canonical)
    return canonical, derived, t1, b1


def test_parse_display_id():
    parsed = RefParser.parse("KABSD-TSK-0125")
    assert parsed is not None
    assert parsed["type"] == "display_id"
    assert parsed["type_abbrev"] == "TSK"


def test_parse_adr():
    parsed = RefParser.parse("ADR-0003-appendix_migration-plan")
    assert parsed is not None
    assert parsed["type"] == "adr"
    assert parsed["adr_number"] == 3
    assert parsed["appendix"] == "migration-plan"


def test_parse_uuid():
    parsed = RefParser.parse("01234567-89ab-7def-8123-456789abcdef")
    assert parsed is not None
    assert parsed["type"] == "uuid"


def test_parse_invalid():
    assert RefParser.parse("invalid-ref") is None


def test_resolve_display_id(setup_store):
    canonical, derived, t1, _ = setup_store
    resolver = RefResolver(canonical, derived)
    item = resolver.resolve(t1.id)
    assert item.id == t1.id


def test_resolve_uuid(setup_store):
    canonical, derived, t1, _ = setup_store
    resolver = RefResolver(canonical, derived)
    item = resolver.resolve(t1.uid)
    assert item.uid == t1.uid


def test_resolve_adr_not_found(setup_store):
    canonical, derived, _, _ = setup_store
    resolver = RefResolver(canonical, derived)
    with pytest.raises(RefNotFoundError):
        resolver.resolve("ADR-0001")


def test_resolve_invalid_ref(setup_store):
    canonical, derived, _, _ = setup_store
    resolver = RefResolver(canonical, derived)
    with pytest.raises(ParseError):
        resolver.resolve("not-a-ref")


def test_get_references_and_validate(setup_store):
    canonical, derived, t1, b1 = setup_store
    resolver = RefResolver(canonical, derived)

    # Add links and decisions into a new item
    i = canonical.create(ItemType.TASK, "Ref collector")
    i.links = {"relates": [t1.id], "blocks": [], "blocked_by": [b1.id, "ADR-0001"]}
    i.decisions = ["ADR-0003"]
    i.context = f"This relates to {t1.id} and {b1.uid}"
    canonical.write(i)

    refs = resolver.get_references(i)
    assert t1.id in refs
    assert "ADR-0003" in refs

    invalid = resolver.validate_references(i)
    # ADR-0001 does not exist in canonical; should be invalid
    assert "ADR-0001" in invalid
