"""
Tests for kano_backlog_core.state module (StateMachine, ReadyValidator).
"""
import pytest
from datetime import datetime, timezone, date
from kano_backlog_core import (
    BacklogItem,
    ItemType,
    ItemState,
    StateMachine,
    ReadyValidator,
    StateAction,
)
from kano_backlog_core.errors import ValidationError


def test_can_transition_valid():
    """Test can_transition returns True for valid transitions."""
    assert StateMachine.can_transition(ItemState.NEW, StateAction.START) is True
    assert StateMachine.can_transition(ItemState.NEW, StateAction.READY) is True
    assert StateMachine.can_transition(ItemState.READY, StateAction.START) is True
    assert StateMachine.can_transition(ItemState.IN_PROGRESS, StateAction.REVIEW) is True


def test_can_transition_invalid():
    """Test can_transition returns False for invalid transitions."""
    assert StateMachine.can_transition(ItemState.NEW, StateAction.REVIEW) is False
    assert StateMachine.can_transition(ItemState.DONE, StateAction.START) is False
    assert StateMachine.can_transition(ItemState.BLOCKED, StateAction.REVIEW) is False


def test_transition_new_to_ready():
    """Test transitioning from New to Ready."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="Test goal",
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
    )
    
    result = StateMachine.transition(item, StateAction.READY)
    assert result.state == ItemState.READY
    assert len(result.worklog) == 1
    assert "State: New → Ready" in result.worklog[0]


def test_transition_new_to_inprogress():
    """Test transitioning from New to InProgress."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="Test goal",
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
    )
    
    result = StateMachine.transition(item, StateAction.START)
    assert result.state == ItemState.IN_PROGRESS
    assert len(result.worklog) == 1
    assert "State: New → InProgress" in result.worklog[0]


def test_transition_ready_to_inprogress():
    """Test transitioning from Ready to InProgress."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.READY,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="Test goal",
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
    )
    
    result = StateMachine.transition(item, StateAction.START)
    assert result.state == ItemState.IN_PROGRESS
    assert len(result.worklog) == 1


def test_transition_inprogress_to_review():
    """Test transitioning from InProgress to Review."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.IN_PROGRESS,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="Test goal",
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
    )
    
    result = StateMachine.transition(item, StateAction.REVIEW)
    assert result.state == ItemState.REVIEW
    assert len(result.worklog) == 1


def test_transition_review_to_done():
    """Test transitioning from Review to Done."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.REVIEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="Test goal",
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
    )
    
    result = StateMachine.transition(item, StateAction.DONE)
    assert result.state == ItemState.DONE
    assert len(result.worklog) == 1


def test_transition_inprogress_to_blocked():
    """Test transitioning from InProgress to Blocked."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.IN_PROGRESS,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="Test goal",
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
    )
    
    result = StateMachine.transition(item, StateAction.BLOCK)
    assert result.state == ItemState.BLOCKED
    assert len(result.worklog) == 1


def test_transition_blocked_to_start():
    """Test transitioning from Blocked to InProgress."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.BLOCKED,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="Test goal",
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
    )
    
    result = StateMachine.transition(item, StateAction.START)
    assert result.state == ItemState.IN_PROGRESS
    assert len(result.worklog) == 1


def test_transition_any_to_dropped():
    """Test transitioning from any state to Dropped."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.IN_PROGRESS,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="Test goal",
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
    )
    
    result = StateMachine.transition(item, StateAction.DROP)
    assert result.state == ItemState.DROPPED
    assert len(result.worklog) == 1


def test_transition_invalid_raises_error():
    """Test transitioning with invalid action raises ValidationError."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="Test goal",
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
    )
    
    with pytest.raises(ValidationError, match="Invalid transition"):
        StateMachine.transition(item, StateAction.REVIEW)


def test_transition_to_ready_with_missing_context():
    """Test transitioning to Ready with missing context fails."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="",  # Empty context
        goal="Test goal",
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
    )
    
    with pytest.raises(ValidationError, match="Ready gate failed"):
        StateMachine.transition(item, StateAction.READY)


def test_transition_to_ready_with_missing_goal():
    """Test transitioning to Ready with missing goal fails."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="",  # Empty goal
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
    )
    
    with pytest.raises(ValidationError, match="Ready gate failed"):
        StateMachine.transition(item, StateAction.READY)


def test_transition_to_ready_epic_no_validation():
    """Test transitioning Epic to Ready does not require Ready gate."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-EPC-0001",
        type=ItemType.EPIC,
        state=ItemState.NEW,
        title="Test epic",
        created="2024-01-01",
        updated="2024-01-01",
        context="",  # Empty is OK for Epic
        goal="",
        approach="",
        acceptance_criteria="",
        risks="",
    )
    
    result = StateMachine.transition(item, StateAction.READY)
    assert result.state == ItemState.READY


def test_ready_validator_check_task_valid():
    """Test ReadyValidator.check with valid Task."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="Test goal",
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
    )
    
    errors = ReadyValidator.check(item)
    assert len(errors) == 0


def test_ready_validator_check_task_missing_all():
    """Test ReadyValidator.check with Task missing all required sections."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="",
        goal="",
        approach="",
        acceptance_criteria="",
        risks="",
    )
    
    errors = ReadyValidator.check(item)
    assert len(errors) == 5
    assert "context" in errors
    assert "goal" in errors
    assert "approach" in errors
    assert "acceptance_criteria" in errors
    assert "risks" in errors


def test_ready_validator_check_bug_missing_sections():
    """Test ReadyValidator.check with Bug missing required sections."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-BUG-0001",
        type=ItemType.BUG,
        state=ItemState.NEW,
        title="Test bug",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="",  # Missing goal
        approach="Test approach",
        acceptance_criteria="",  # Missing criteria
        risks="Risk 1",
    )
    
    errors = ReadyValidator.check(item)
    assert len(errors) == 2
    assert "goal" in errors
    assert "acceptance_criteria" in errors


def test_ready_validator_check_epic_no_validation():
    """Test ReadyValidator.check does not validate Epic."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-EPC-0001",
        type=ItemType.EPIC,
        state=ItemState.NEW,
        title="Test epic",
        created="2024-01-01",
        updated="2024-01-01",
        context="",
        goal="",
        approach="",
        acceptance_criteria="",
        risks="",
    )
    
    errors = ReadyValidator.check(item)
    assert len(errors) == 0


def test_transition_updates_timestamp():
    """Test transition updates the item's updated timestamp."""
    today = date.today().isoformat()
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="Test goal",
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
    )
    
    result = StateMachine.transition(item, StateAction.START)
    assert result.updated == today


def test_transition_appends_worklog():
    """Test transition appends worklog entry with agent."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        context="Test context",
        goal="Test goal",
        approach="Test approach",
        acceptance_criteria="Criterion 1",
        risks="Risk 1",
        worklog=["2024-01-01 10:00 [agent=test] Created item"],
    )
    
    result = StateMachine.transition(item, StateAction.START, agent="copilot")
    assert len(result.worklog) == 2
    assert "[agent=copilot]" in result.worklog[1]
    assert "State: New → InProgress" in result.worklog[1]
