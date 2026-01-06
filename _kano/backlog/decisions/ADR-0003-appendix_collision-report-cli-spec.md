# Collision Report & Resolver CLI

**ID 碰撞報告與解析器 CLI 工具規格**

## 概述

提供兩個工具：
1. **workitem_collision_report.py** - 掃描並報告 display ID 碰撞
2. **workitem_resolve_ref.py** - 互動式引用解析

## workitem_collision_report.py

### 功能

掃描 `_kano/backlog/items/` 下所有項目，找出 display `id` 重複的情況。

### 使用方式

```bash
# 基本報告
python scripts/backlog/workitem_collision_report.py

# JSON 輸出
python scripts/backlog/workitem_collision_report.py --format json

# 只顯示有碰撞的
python scripts/backlog/workitem_collision_report.py --collisions-only

# 指定 backlog 路徑
python scripts/backlog/workitem_collision_report.py --backlog-root _kano/backlog
```

### 輸出範例

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

### JSON 輸出格式

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

### 功能

解析引用字串，支援互動式消歧義。

### 使用方式

```bash
# 解析引用
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0059

# 使用 uidshort 精確匹配
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0100@019473f2

# 互動模式
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0100 --interactive

# 輸出格式
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0059 --format path   # 只輸出路徑
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0059 --format json   # JSON 格式
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0059 --format uid    # 只輸出 uid
```

### 輸出範例

**唯一匹配:**
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

**多筆匹配 (互動模式):**
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

## 實作要點

### 共用模組

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

### 整合至現有 skill scripts

| 現有腳本 | 整合方式 |
|----------|----------|
| `workitem_update_state.py` | 使用 resolve_ref 允許 id@uidshort 參數 |
| `workitem_create.py` | 自動生成 UUIDv7 uid |
| `view_generate.py` | 可選顯示 uidshort |

## 交付物

- [ ] `scripts/backlog/workitem_collision_report.py`
- [ ] `scripts/backlog/workitem_resolve_ref.py`
- [ ] `scripts/backlog/lib/index.py` (共用模組)
- [ ] 單元測試
