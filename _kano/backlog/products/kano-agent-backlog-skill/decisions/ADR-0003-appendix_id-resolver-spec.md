# ID Resolver Specification

**ResolveRef() 函數規格設計 - 用於解析 backlog 項目引用**

## 概述

根據 ADR-0003，所有引用解析必須經過 Resolver 處理，以支援：
- 完整 `uid` 精確匹配
- `uidshort` 前綴匹配
- Display `id` 匹配 (可能多筆)

## ResolveRef() 函數規格

### 簽名

```python
def resolve_ref(
    ref: str,
    index: BacklogIndex,
    interactive: bool = False
) -> ResolveResult:
    """
    Resolve a reference to one or more backlog items.
    
    Args:
        ref: Reference string (uid, uidshort, id, or id@uidshort format)
        index: Backlog index instance
        interactive: If True, prompt user for disambiguation
        
    Returns:
        ResolveResult with matched item(s) or error
    """
```

### 輸入格式

| 格式 | 範例 | 說明 |
|------|------|------|
| Full uid | `019473f2-79b0-7cc3-98c4-dc0c0c07398f` | 36 chars, hyphens |
| uidshort | `019473f2` | 8 hex chars |
| Display id | `KABSD-TSK-0059` | Project prefix + type + number |
| id@uidshort | `KABSD-TSK-0059@019473f2` | 人類友善格式 |

### 解析邏輯

```python
def resolve_ref(ref: str, index: BacklogIndex) -> ResolveResult:
    # 1. Check if ref is full uid (36 chars with hyphens)
    if is_full_uid(ref):
        item = index.get_by_uid(ref)
        if item:
            return ResolveResult(matches=[item], exact=True)
        return ResolveResult(error=f"UID not found: {ref}")
    
    # 2. Check if ref contains @uidshort (e.g., KABSD-TSK-0059@019473f2)
    if "@" in ref:
        id_part, uidshort = ref.split("@", 1)
        matches = index.get_by_id(id_part)
        matches = [m for m in matches if m.uid.startswith(uidshort)]
        if len(matches) == 1:
            return ResolveResult(matches=matches, exact=True)
        elif len(matches) > 1:
            return ResolveResult(matches=matches, exact=False, 
                error="Multiple matches even with uidshort")
        return ResolveResult(error=f"No match for {ref}")
    
    # 3. Check if ref is uidshort (8 hex chars)
    if is_uidshort(ref):
        matches = index.get_by_uidshort(ref)
        if len(matches) == 1:
            return ResolveResult(matches=matches, exact=True)
        elif len(matches) > 1:
            return ResolveResult(matches=matches, exact=False)
        return ResolveResult(error=f"uidshort not found: {ref}")
    
    # 4. Assume ref is display id
    matches = index.get_by_id(ref)
    if len(matches) == 1:
        return ResolveResult(matches=matches, exact=True)
    elif len(matches) > 1:
        return ResolveResult(matches=matches, exact=False)
    
    return ResolveResult(error=f"ID not found: {ref}")
```

### 輸出結構

```python
@dataclass
class ResolveResult:
    matches: List[BacklogItem] = field(default_factory=list)
    exact: bool = False
    error: Optional[str] = None
    
@dataclass
class BacklogItem:
    uid: str
    id: str
    uidshort: str  # derived from uid[:8]
    type: str
    title: str
    state: str
    path: str
    created: str
    updated: str
```

## Index 需求

Resolver 需要以下 index 查詢能力：

| 查詢 | 方法 | 說明 |
|------|------|------|
| `uid -> item` | `get_by_uid(uid)` | 唯一匹配 |
| `uidshort -> [items]` | `get_by_uidshort(prefix)` | 前綴匹配 |
| `id -> [items]` | `get_by_id(id)` | 可能多筆 |

### Index Schema (SQLite)

```sql
CREATE TABLE items (
    uid TEXT PRIMARY KEY,
    id TEXT NOT NULL,
    uidshort TEXT NOT NULL,  -- first 8 hex chars
    type TEXT,
    title TEXT,
    state TEXT,
    path TEXT UNIQUE,
    created TEXT,
    updated TEXT
);

CREATE INDEX idx_id ON items(id);
CREATE INDEX idx_uidshort ON items(uidshort);
```

## 消歧義 (Disambiguation)

當 `exact=False` 且有多個匹配時，輸出候選清單：

```
Multiple matches for "KABSD-TSK-0100":

  # | ID              | UID (short)  | Type | State | Title
---------------------------------------------------------------
  1 | KABSD-TSK-0100 | 019473f2     | Task | Done  | First task
  2 | KABSD-TSK-0100 | 01947428     | Task | New   | Second task

Enter number to select, or use: KABSD-TSK-0100@019473f2
```

## CLI 整合

```bash
# Resolve and show item details
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0059

# Resolve with uidshort hint
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0100@019473f2

# Interactive mode
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0100 --interactive

# Output format
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0059 --format json
python scripts/backlog/workitem_resolve_ref.py KABSD-TSK-0059 --format path
```

## 錯誤處理

| 情況 | 錯誤訊息 |
|------|----------|
| UID not found | `Error: UID not found: {uid}` |
| ID not found | `Error: ID not found: {id}` |
| Multiple matches | `Ambiguous: {count} items match "{ref}". Use id@uidshort format.` |
| Invalid format | `Error: Invalid reference format: {ref}` |
