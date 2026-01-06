# ULID vs UUIDv7 Comparison

**為 ADR-0003 的 uid 格式選擇提供技術比較**

## 摘要

| 特性 | ULID | UUIDv7 |
|------|------|--------|
| **總長度** | 128 bits | 128 bits |
| **字串長度** | 26 字元 (Base32) | 36 字元 (hex + hyphens) |
| **時間戳** | 48 bits (ms) | 48 bits (ms) |
| **隨機部分** | 80 bits | 74 bits (扣除 version/variant) |
| **標準化** | 社群規範 | IETF RFC 9562 |
| **排序** | 字典序可排序 | 字典序可排序 |
| **可讀性** | 較短、無連字號 | 標準 UUID 格式 |

## 詳細比較

### 1. 格式與可讀性

**ULID**
```
01AN4Z07BY79KA1307SR9X4MV3
|----------|----------------|
 Timestamp    Randomness
  (10 ch)      (16 ch)
```
- 使用 Crockford's Base32 (排除 I, L, O, U 避免混淆)
- 全大寫，無連字號
- **26 字元**

**UUIDv7**
```
017f22e2-79b0-7cc3-98c4-dc0c0c07398f
|-------|    |  |    |
  time  ver  var  random
```
- 標準 UUID 格式 (8-4-4-4-12)
- 十六進位，含連字號
- **36 字元**

### 2. 排序特性

| 方面 | ULID | UUIDv7 |
|------|------|--------|
| 字典序排序 | ✅ 完全支援 | ✅ 完全支援 |
| 同毫秒內排序 | 透過單調遞增 | 透過 counter/random |
| 跨機器排序 | 僅時間精度 | 僅時間精度 |

兩者在**字典序排序**都能正確反映時間順序。

### 3. 碰撞安全性

| 方面 | ULID | UUIDv7 |
|------|------|--------|
| 隨機熵 | 80 bits | ~74 bits |
| 同毫秒碰撞率 | 2^-80 | 2^-74 |
| 理論安全性 | 極高 | 極高 |

兩者在實際應用中**碰撞機率都可忽略**。

### 4. Library 支援

**ULID**
- Python: `python-ulid`, `ulid-py`
- JavaScript: `ulid` (official)
- Go: `oklog/ulid`
- 社群驅動，多語言覆蓋良好

**UUIDv7**
- Python: `uuid6` (backport for <3.x), Python 3.12+ 內建計畫中
- JavaScript: `uuid@9+`
- Go: `google/uuid`
- **IETF 標準化** (RFC 9562)，主流 UUID 庫正在加入支援

### 5. uidshort 前綴長度建議

**ULID**
- 前 10 字元 = 時間戳部分
- 建議 uidshort: **8-10 字元** (涵蓋時間 + 部分隨機)
- 範例: `01AN4Z07BY` → 8 字元 `01AN4Z07`

**UUIDv7**
- 前 8 字元 (不含連字號) = 時間戳高位
- 建議 uidshort: **8-12 字元** (hex)
- 範例: `017f22e2-79b0-7...` → 8 字元 `017f22e2`

## 建議

### 初始分析建議：ULID

| 優勢 | 說明 |
|------|------|
| **更短** | 26 vs 36 字元，檔名更簡潔 |
| **更易讀** | 無連字號，視覺上更乾淨 |
| **充足熵** | 80 bits 隨機，碰撞風險極低 |
| **成熟生態** | 多年使用，庫支援穩定 |
| **適合檔名** | 無特殊字元，所有檔案系統相容 |

### UUIDv7 的優勢

- **標準化**: IETF RFC 9562，長期穩定性有保障
- **相容性**: 與現有 UUID 基礎設施相容 (如資料庫 UUID 欄位)
- **未來性**: Python 3.12+、主流庫原生支援

---

## 最終決策 (2026-01-06)

**採用 UUIDv7**

使用者選擇 UUIDv7，基於以下考量：
1. IETF 標準化，長期穩定性更有保障
2. 與現有 UUID 生態系統相容
3. 主流語言未來原生支援

**uidshort 長度：8 字元 (hex prefix)**
- 範例：`017f22e2-79b0-7...` → `017f22e2`

## 參考資料

- [ULID Spec](https://github.com/ulid/spec)
- [RFC 9562 - UUIDv7](https://www.rfc-editor.org/rfc/rfc9562)
- [python-ulid](https://github.com/mdomke/python-ulid)
