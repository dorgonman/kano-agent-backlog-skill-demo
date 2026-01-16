---
uid: 019bc5dc-68d7-74a5-ba60-d1a782ba21c6
---

# Collision Report & Resolver CLI

**ID collision reporting and resolver CLI tool specifications**

## Overview

Provides two tools:
1. **workitem_collision_report.py** - Scan and report display ID collisions
2. **workitem_resolve_ref.py** - Interactive reference resolution

## workitem_collision_report.py

### Features

Scans all items under `_kano/backlog/items/` to find duplicate display `id` cases.

### Usage

```bash
# Basic report
python scripts/backlog/workitem_collision_report.py

# JSON output
python scripts/backlog/workitem_collision_report.py --format json

# Show collisions only
python scripts/backlog/workitem_collision_report.py --collisions-only

# Specify backlog path
python scripts/backlog/workitem_collision_report.py --backlog-root _kano/backlog
```

### Output example

```
ID Collision Report
===================
Generated: 2026-01-06 01:30
Scanned: 85 items

Collisions Found: 1

ID: KABSD-TSK-0100 (2 items)
  1. 019473f2 | Task | Done  | First implementation | items/tasks/0000/...
  2. 01947428 | Task | New   | Second attempt      | items/tasks/0000/...
  Suggestion: Use KABSD-TSK-0100@019473f2 or KABSD-TSK-0100@01947428

No other collisions found.
```

### JSON output format

```json
{
  "generated": "2026-01-06T01:30:00",
  "total_items": 85,
  "collision_count": 1,
  "collisions": [
    {
      "id": "KABSD-TSK-0100",
      "items": [
        {
          "uid": "019473f2-79b0-7cc3-98c4-dc0c0c07398f",
          "uidshort": "019473f2",
          "type": "Task",
          "state": "Done",
          "title": "First implementation",
          "path": "items/tasks/0000/KABSD-TSK-0100_first-impl.md"
        },
        {
          "uid": "01947428-1234-7abc-5678-def012345678",
          "uidshort": "01947428",
          "type": "Task",
          "state": "New",
          "title": "Second attempt",
          "path": "items/tasks/0000/KABSD-TSK-0100_second-attempt.md"
        }
      ]
    }
  ]
}
```

## workitem_resolve_ref.py

### Features

Resolves reference strings with interactive disambiguation support.

### Usage

```bash
# Resolve reference
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0059

# Use uidshort for exact match
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0100@019473f2

# Interactive mode
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0100 --interactive

# Output format
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0059 --format path   # path only
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0059 --format json   # JSON format
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0059 --format uid    # uid only
```

### Output examples

**Unique match:**
```
Resolved: KABSD-TSK-0059

  UID:      019473f2-79b0-7cc3-98c4-dc0c0c07398f
  ID:       KABSD-TSK-0059
  Type:     Task
  State:    Done
  Title:    ULID vs UUIDv7 comparison document
  Path:     items/tasks/0000/KABSD-TSK-0059_ulid-vs-uuidv7-comparison.md
  Created:  2026-01-06
  Updated:  2026-01-06
```

**Multiple matches (interactive mode):**
```
Ambiguous: 2 items match "KABSD-TSK-0100"

  # | UID (short) | Type | State | Title
  --|-------------|------|-------|------
  1 | 019473f2    | Task | Done  | First implementation
  2 | 01947428    | Task | New   | Second attempt

Enter number to select (or 'q' to quit): 1

Selected: KABSD-TSK-0100@019473f2
Path: items/tasks/0000/KABSD-TSK-0100_first-impl.md
```

## Implementation notes

### Shared module

```python
# scripts/backlog/lib/index.py

class BacklogIndex:
    def __init__(self, backlog_root: str):
        self.items = self._scan_items(backlog_root)
        self._build_indexes()
    
    def get_by_uid(self, uid: str) -> Optional[BacklogItem]: ...
    def get_by_uidshort(self, prefix: str) -> List[BacklogItem]: ...
    def get_by_id(self, display_id: str) -> List[BacklogItem]: ...
    def get_collisions(self) -> Dict[str, List[BacklogItem]]: ...
```

### Integration with existing skill scripts

| Existing script | Integration approach |
|-----------------|----------------------|
| `workitem_update_state.py` | Use resolve_ref to allow id@uidshort parameters |
| `workitem_create.py` | Auto-generate UUIDv7 uid |
| `view_generate.py` | Optionally display uidshort |

## Deliverables

- [ ] `scripts/backlog/workitem_collision_report.py`
- [ ] `scripts/backlog/workitem_resolve_ref.py`
- [ ] `scripts/backlog/lib/index.py` (shared module)
- [ ] Unit tests