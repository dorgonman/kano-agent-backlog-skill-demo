"""
Tests for kano_backlog_core.audit module (AuditLog, WorklogEntry).
"""
import pytest
import json
import tempfile
from pathlib import Path
from datetime import datetime, timezone
from kano_backlog_core import (
    BacklogItem,
    ItemType,
    ItemState,
    AuditLog,
    WorklogEntry,
)


def test_worklog_entry_parse_valid():
    """Test WorklogEntry.parse with valid format."""
    line = "2024-01-15 14:30 [agent=copilot] Task created"
    entry = WorklogEntry.parse(line)
    
    assert entry.timestamp == "2024-01-15 14:30"
    assert entry.agent == "copilot"
    assert entry.message == "Task created"


def test_worklog_entry_parse_invalid_format():
    """Test WorklogEntry.parse with invalid format returns None."""
    line = "Invalid worklog entry"
    entry = WorklogEntry.parse(line)
    
    assert entry is None


def test_worklog_entry_format():
    """Test WorklogEntry.format creates correct string."""
    entry = WorklogEntry(
        timestamp="2024-01-15 14:30",
        agent="copilot",
        message="Task created"
    )
    
    formatted = entry.format()
    assert formatted == "2024-01-15 14:30 [agent=copilot] Task created"


def test_worklog_entry_parse_format_roundtrip():
    """Test parse and format are reversible."""
    original = "2024-01-15 14:30 [agent=copilot] Task created"
    entry = WorklogEntry.parse(original)
    formatted = entry.format()
    
    assert formatted == original


def test_append_worklog():
    """Test AuditLog.append_worklog adds entry to item."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        worklog=[]
    )
    
    AuditLog.append_worklog(item, "Task created", agent="copilot")
    
    assert len(item.worklog) == 1
    assert "[agent=copilot]" in item.worklog[0]
    assert "Task created" in item.worklog[0]


def test_append_worklog_no_agent():
    """Test AuditLog.append_worklog without agent."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        worklog=[]
    )
    
    AuditLog.append_worklog(item, "Task created")
    
    assert len(item.worklog) == 1
    assert "[agent=" not in item.worklog[0]
    assert "Task created" in item.worklog[0]


def test_append_worklog_to_existing():
    """Test AuditLog.append_worklog appends to existing worklog."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        worklog=["2024-01-01 10:00 [agent=test] First entry"]
    )
    
    AuditLog.append_worklog(item, "Second entry", agent="copilot")
    
    assert len(item.worklog) == 2
    assert "First entry" in item.worklog[0]
    assert "Second entry" in item.worklog[1]


def test_parse_worklog():
    """Test AuditLog.parse_worklog parses all entries."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        worklog=[
            "2024-01-15 14:30 [agent=copilot] First entry",
            "2024-01-15 14:31 [agent=human] Second entry",
            "Invalid entry",
        ]
    )
    
    entries = AuditLog.parse_worklog(item)
    
    assert len(entries) == 2
    assert entries[0].message == "First entry"
    assert entries[0].agent == "copilot"
    assert entries[1].message == "Second entry"
    assert entries[1].agent == "human"


def test_parse_worklog_empty():
    """Test AuditLog.parse_worklog with empty worklog."""
    item = BacklogItem(
        uid="550e8400-e29b-41d4-a716-446655440000",
        id="KABSD-TSK-0001",
        type=ItemType.TASK,
        state=ItemState.NEW,
        title="Test task",
        created="2024-01-01",
        updated="2024-01-01",
        worklog=[]
    )
    
    entries = AuditLog.parse_worklog(item)
    assert len(entries) == 0


def test_log_file_operation():
    """Test AuditLog.log_file_operation writes JSONL."""
    with tempfile.TemporaryDirectory() as tmpdir:
        log_path = Path(tmpdir) / "tool_invocations.jsonl"
        
        AuditLog.log_file_operation(
            operation="create",
            path="test/file.md",
            tool="test_tool",
            agent="copilot",
            metadata={"key": "value"},
            log_path=log_path
        )
        
        assert log_path.exists()
        with open(log_path, "r", encoding="utf-8") as f:
            line = f.readline()
            record = json.loads(line)
            
            assert record["operation"] == "create"
            assert record["path"] == "test/file.md"
            assert record["tool"] == "test_tool"
            assert record["agent"] == "copilot"
            assert record["metadata"] == {"key": "value"}
            assert "timestamp" in record


def test_log_file_operation_appends():
    """Test AuditLog.log_file_operation appends to existing file."""
    with tempfile.TemporaryDirectory() as tmpdir:
        log_path = Path(tmpdir) / "tool_invocations.jsonl"
        
        AuditLog.log_file_operation(
            operation="create",
            path="file1.md",
            tool="tool1",
            agent="copilot",
            log_path=log_path
        )
        AuditLog.log_file_operation(
            operation="update",
            path="file2.md",
            tool="tool2",
            agent="human",
            log_path=log_path
        )
        
        with open(log_path, "r", encoding="utf-8") as f:
            lines = f.readlines()
            assert len(lines) == 2
            
            record1 = json.loads(lines[0])
            assert record1["operation"] == "create"
            assert record1["path"] == "file1.md"
            
            record2 = json.loads(lines[1])
            assert record2["operation"] == "update"
            assert record2["path"] == "file2.md"


def test_read_file_operations():
    """Test AuditLog.read_file_operations reads JSONL."""
    with tempfile.TemporaryDirectory() as tmpdir:
        log_path = Path(tmpdir) / "tool_invocations.jsonl"
        
        AuditLog.log_file_operation(
            operation="create",
            path="file1.md",
            tool="tool1",
            agent="copilot",
            log_path=log_path
        )
        AuditLog.log_file_operation(
            operation="update",
            path="file2.md",
            tool="tool2",
            agent="human",
            log_path=log_path
        )
        
        records = AuditLog.read_file_operations(log_path)
        
        assert len(records) == 2
        assert records[0]["operation"] == "create"
        assert records[0]["path"] == "file1.md"
        assert records[1]["operation"] == "update"
        assert records[1]["path"] == "file2.md"


def test_read_file_operations_empty():
    """Test AuditLog.read_file_operations with non-existent file."""
    with tempfile.TemporaryDirectory() as tmpdir:
        log_path = Path(tmpdir) / "nonexistent.jsonl"
        
        records = AuditLog.read_file_operations(log_path)
        assert len(records) == 0


def test_read_file_operations_with_filter():
    """Test AuditLog.read_file_operations with operation filter."""
    with tempfile.TemporaryDirectory() as tmpdir:
        log_path = Path(tmpdir) / "tool_invocations.jsonl"
        
        AuditLog.log_file_operation(operation="create", path="file1.md", tool="tool1", agent="copilot", log_path=log_path)
        AuditLog.log_file_operation(operation="update", path="file2.md", tool="tool2", agent="copilot", log_path=log_path)
        AuditLog.log_file_operation(operation="create", path="file3.md", tool="tool3", agent="copilot", log_path=log_path)
        
        records = AuditLog.read_file_operations(log_path, operation_filter="create")
        
        assert len(records) == 2
        assert all(r["operation"] == "create" for r in records)
