# Migration Plan: Add uid to Existing Items

**為現有 backlog 項目加入 UUIDv7 uid 欄位的遷移計畫**

## 概述

所有現有 backlog 項目目前只有 `id` (display ID)。根據 ADR-0003，需要為每個項目加入 `uid` (UUIDv7 格式) 作為 immutable primary key。

**關鍵決策 (ADR-0003):**
- uid 格式: UUIDv7 (RFC 9562)
- 檔名維持不變 (`<id>_<slug>.md`)
- uid 只加入 frontmatter

## 遷移步驟

### Phase 1: 準備工作

1. **備份現有 backlog**
   ```bash
   cp -r _kano/backlog _kano/backlog_backup_$(date +%Y%m%d)
   ```

2. **確認 UUIDv7 library 可用**
   - Python: `uuid6` package 或 Python 3.12+ 內建
   - 安裝: `pip install uuid6`

### Phase 2: 遷移腳本

建立 `scripts/backlog/migrate_add_uid.py`:

```python
#!/usr/bin/env python3
"""
Add uid (UUIDv7) to existing backlog items.

Usage:
    python migrate_add_uid.py --dry-run  # Preview changes
    python migrate_add_uid.py --apply    # Apply changes
"""
import uuid6  # or uuid (Python 3.12+)

def generate_uid():
    """Generate a UUIDv7 string."""
    return str(uuid6.uuid7())

def extract_uidshort(uid: str, length: int = 8) -> str:
    """Extract uidshort (first N hex chars, no hyphens)."""
    return uid.replace("-", "")[:length]
```

**腳本功能:**
1. 掃描 `_kano/backlog/items/` 下所有 .md 檔案
2. 解析 frontmatter
3. 如果沒有 `uid` 欄位，生成 UUIDv7 並加入
4. 更新 `updated` 欄位
5. 寫回檔案

### Phase 3: 處理 parent/link 引用

**向後相容策略 (漸進式):**

1. **保留現有 `parent` 欄位** (by display id)
2. **新增 `parent_uid` 欄位** (optional)
3. Resolver 工具負責將 `parent` 解析為實際 uid

```yaml
# 遷移前
parent: KABSD-FTR-0001

# 遷移後 (向後相容)
parent: KABSD-FTR-0001
parent_uid: 019473f2-79b0-7cc3-98c4-dc0c0c07398f  # optional
```

### Phase 4: 驗證

1. 執行驗證腳本確認所有項目都有 uid
2. 確認 uid 格式正確 (UUIDv7)
3. 確認 Dashboard views 正常顯示

## Frontmatter Schema 變更

### 新增欄位

| 欄位 | 類型 | 必要性 | 說明 |
|------|------|--------|------|
| `uid` | string | Required (遷移後) | UUIDv7 格式，immutable |
| `parent_uid` | string | Optional | 父項目的 uid |
| `aliases` | list | Optional | 舊 ID 或替代名稱 |

### 範例

```yaml
---
id: KABSD-TSK-0059
uid: 019473f2-79b0-7cc3-98c4-dc0c0c07398f
type: Task
title: "ULID vs UUIDv7 comparison document"
state: Done
priority: P3
parent: KABSD-FTR-0001
parent_uid: 019473e8-1234-7abc-5678-def012345678  # optional
# ... rest of frontmatter
---
```

## uidshort 規格

| 屬性 | 值 |
|------|---|
| 長度 | 8 字元 |
| 來源 | uid 前 8 個 hex 字元 (不含 hyphen) |
| 範例 | `019473f2` |
| 用途 | 人類友善引用 `KABSD-TSK-0059@019473f2` |

## 風險與緩解

| 風險 | 緩解措施 |
|------|----------|
| 遷移失敗導致資料損壞 | 先備份，dry-run 模式 |
| uid 重複 | UUIDv7 碰撞機率極低，加入驗證檢查 |
| 工具不相容 | 向後相容：保留 `parent` 欄位，新增 `parent_uid` |

## 實作順序

1. [ ] 建立 `migrate_add_uid.py` 腳本
2. [ ] 在 sandbox 測試
3. [ ] Dry-run 預覽
4. [ ] 備份並執行遷移
5. [ ] 驗證結果
6. [ ] 更新相關工具支援 uid 解析
