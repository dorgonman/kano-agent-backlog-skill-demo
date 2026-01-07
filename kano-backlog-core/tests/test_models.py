"""Tests for models."""

import pytest
from kano_backlog_core.models import ItemType, ItemState, BacklogItem, WorklogEntry


def test_item_type_enum():
    """Test ItemType enum values."""
    assert ItemType.EPIC.value == "Epic"
    assert ItemType.FEATURE.value == "Feature"
    assert ItemType.USER_STORY.value == "UserStory"
    assert ItemType.TASK.value == "Task"
    assert ItemType.BUG.value == "Bug"


def test_item_state_enum():
    """Test ItemState enum values."""
    assert ItemState.NEW.value == "New"
    assert ItemState.PROPOSED.value == "Proposed"
    assert ItemState.READY.value == "Ready"
    assert ItemState.IN_PROGRESS.value == "InProgress"
    assert ItemState.REVIEW.value == "Review"
    assert ItemState.DONE.value == "Done"
    assert ItemState.BLOCKED.value == "Blocked"
    assert ItemState.DROPPED.value == "Dropped"


def test_backlog_item_minimal():
    """Test BacklogItem with minimal required fields."""
    item = BacklogItem(
        id="KABSD-TSK-0001",
        uid="01234567-89ab-7def-8123-456789abcdef",
        type=ItemType.TASK,
        title="Test Task",
        state=ItemState.NEW,
        created="2024-01-01",
        updated="2024-01-01",
    )
    assert item.id == "KABSD-TSK-0001"
    assert item.type == ItemType.TASK
    assert item.state == ItemState.NEW
    assert item.tags == []
    assert item.worklog == []


def test_backlog_item_full():
    """Test BacklogItem with all fields populated."""
    item = BacklogItem(
        id="KABSD-FTR-0010",
        uid="01234567-89ab-7def-8123-456789abcdef",
        type=ItemType.FEATURE,
        title="New Feature",
        state=ItemState.IN_PROGRESS,
        priority="High",
        parent="KABSD-EPIC-0001",
        owner="alice",
        tags=["core", "p1"],
        created="2024-01-01",
        updated="2024-01-15",
        area="Backend",
        iteration="Sprint 5",
        external={"jira": "PROJ-123"},
        links={"relates": ["KABSD-TSK-0020"], "blocks": [], "blocked_by": []},
        decisions=["ADR-0001"],
        context="User needs this feature",
        goal="Implement the feature",
        approach="Use pattern X",
        acceptance_criteria="- Works\n- Fast",
        worklog=["2024-01-01 - Started", "2024-01-15 - In progress"],
    )
    assert item.id == "KABSD-FTR-0010"
    assert item.priority == "High"
    assert item.parent == "KABSD-EPIC-0001"
    assert item.owner == "alice"
    assert len(item.tags) == 2
    assert item.external["jira"] == "PROJ-123"
    assert len(item.worklog) == 2


def test_worklog_entry_parse():
    """Test WorklogEntry.parse extracts components."""
    entry = WorklogEntry.parse("2024-01-15 14:30 [agent=copilot] Started implementation")
    assert entry.timestamp == "2024-01-15 14:30"
    assert entry.agent == "copilot"
    assert entry.message == "Started implementation"


def test_worklog_entry_parse_invalid():
    """Test WorklogEntry.parse returns None for invalid format."""
    entry = WorklogEntry.parse("Invalid format")
    assert entry is None


def test_worklog_entry_format():
    """Test WorklogEntry.format generates correct string."""
    entry = WorklogEntry(timestamp="2024-01-15 14:30", agent="alice", message="Fixed bug")
    assert entry.format() == "2024-01-15 14:30 [agent=alice] Fixed bug"


def test_worklog_entry_round_trip():
    """Test parse and format work together."""
    original = "2024-01-15 14:30 [agent=system] Automated update"
    entry = WorklogEntry.parse(original)
    assert entry is not None
    assert entry.format() == original
