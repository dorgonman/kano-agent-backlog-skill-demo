# Workset 整合評估報告

> **工單**: [KABSD-TSK-0104](file:///d:/_work/_Kano/kano-agent-backlog-skill-demo/_kano/backlog/products/kano-agent-backlog-skill/items/tasks/0100/KABSD-TSK-0104_evaluate-integrating-working-memory-on-disk-into-kano-backlog.md)
> **日期**: 2026-01-07

---

## 1. planning-with-files 方法摘要

來源：[planning-with-files SKILL.md](https://github.com/OthmanAdi/planning-with-files/blob/master/planning-with-files/SKILL.md)

### 核心概念：Working Memory on Disk
將「容易蒸發的執行狀態」持久化為檔案，避免 agent 在長對話或多 session 中「漂移」。

### 3-File Pattern
| 檔案 | 用途 | 更新時機 |
|------|------|---------|
| `task_plan.md` | 階段清單 + 進度追蹤 | 每完成一階段 |
| `notes.md` | 研究筆記、發現 | 研究期間 |
| `deliverable.md` | 最終產出 | 完成時 |

### 核心規則（已確認）
1. **Plan First**: 任何複雜任務前必須先建立 `task_plan.md`
2. **Read Before Decide**: 每次重大決策前重讀 plan，確保目標在注意力窗口內
3. **Update After Act**: 每個階段完成後立即更新 plan
4. **Store, Don't Stuff**: 大量輸出存檔案，不塞 context

### 優勢
- ✅ 極低門檻（3 個純文字檔）
- ✅ 有效防止單一任務內的 drift
- ✅ 強化「先計劃再執行」紀律
- ✅ 適合能力較弱的模型（減少每次重新推導計劃的開銷）

---

## 2. 比較分析

### A) 範圍與粒度

| 維度 | planning-with-files | Kano backlog |
|------|---------------------|--------------|
| 涵蓋範圍 | 單一任務執行記憶 | 專案級工作項管理 + 治理 |
| 粒度 | 任務級（3 檔案） | Epic → Feature → Story → Task/Bug 階層 |
| 適用場景 | 複雜但獨立的任務 | 多人/多 agent 協作專案 |

### B) 資料模型

| 維度 | planning-with-files | Kano backlog |
|------|---------------------|--------------|
| 檔案結構 | 3 個自由格式 .md | YAML frontmatter + 結構化 Markdown |
| 關聯 | 無明確連結 | `parent`, `links.blocks`, `links.blocked_by` |
| 決策記錄 | 內嵌於 `task_plan.md` (Decisions Made) | 獨立 ADR + `decisions` frontmatter |
| 索引 | 無 | 可選 SQLite index + views |

### C) 漂移防護 vs 長期完整性

| 維度 | planning-with-files | Kano backlog |
|------|---------------------|--------------|
| 防止執行期漂移 | ⭐⭐⭐ (Read Before Decide 規則) | ⭐⭐ (依賴 worklog 但無強制重讀) |
| 防止長期記憶流失 | ⭐ (無歸檔/版本策略) | ⭐⭐⭐ (ADR + append-only worklog) |
| 多 session 延續 | ⭐⭐ (靠檔案存在) | ⭐⭐⭐ (狀態機 + 明確 state 欄位) |

### D) 自動化與護欄

| 維度 | planning-with-files | Kano backlog |
|------|---------------------|--------------|
| 強制性 | 軟性建議（skill 規範） | 硬護欄（Ready gate、script 強制 audit） |
| 腳本支援 | 無 | `workitem_create.py`, `workitem_update_state.py`, etc. |
| 稽核 | 無 | `audit_logger.py`, JSONL 日誌 |

---

## 3. Kano 已涵蓋 / 尚未涵蓋

### ✅ 已涵蓋
- 結構化工作項（比 `task_plan.md` 更嚴謹）
- 關聯與依賴（parent、blocks、blocked_by）
- 決策持久化（ADR）
- Append-only worklog（不可刪除的進度追蹤）
- 自動化腳本 + 稽核

### ⚠️ 部分涵蓋
- 「Read Before Decide」紀律：Kano 有 worklog，但無強制讓 agent 每次行動前「重新載入 context」

### ❌ 尚未涵蓋（可從 planning-with-files 借鏡）
1. **輕量即時計劃**：`task_plan.md` 式的 checkbox 計劃（比 work item 更輕）
2. **notes.md 研究暫存區**：收集研究筆記的專用空間
3. **deliverable.md 產出草稿**：最終交付物草稿區

---

## 4. 整合建議

> [!IMPORTANT]
> 整合目標：獲得「執行層記憶」的好處，但 **不破壞 local-first 與 canonical source of truth**。

### 建議採用：Workset 作為「per-item local cache」

#### 概念
- 每個 Task/Bug 可擁有一個 **Workset 資料夾**
- Workset 是 **agent local cache**，用於即時執行記憶
- Git 不追蹤（加入 `.gitignore`）

#### 規則
1. **Workset 不是 source of truth**；canonical 仍是 work item + ADR
2. **Promote back to canonical**：
   - 決策 → ADR
   - 狀態/進度 → work item state + worklog
   - 最終文字 → 複製到 work item body / PR description / release notes

---

## 5. Workset 規格（建議）

### 資料夾佈局
```text
_kano/backlog/.cache/worksets/<item-id>/
├── plan.md          # 執行計劃（checkbox）
├── notes.md         # 研究筆記
└── deliverable.md   # 產出草稿
```
> `.cache/` 整個加入 `.gitignore`

### 模板

#### plan.md
```markdown
# Workset Plan: <Item ID>

## Goal
[One sentence from work item Goal section]

## Phases
- [ ] Phase 1: Research and understand
- [ ] Phase 2: Design approach
- [ ] Phase 3: Implement
- [ ] Phase 4: Verify and close

## Status
**Currently in Phase X** - [Current activity]

## Quick Decisions
- [Decision]: [Rationale] → (promote to ADR if significant)

## Errors Encountered
- [Error]: [Resolution]
```

#### notes.md
```markdown
# Research Notes: <Item ID>

## Sources
### Source 1: [Name]
- URL: [link]
- Key points:
  - [Finding]

## Synthesized Findings
- [Category]: [Summary]
```

#### deliverable.md
```markdown
# Deliverable Draft: <Item ID>

## Summary
[One paragraph]

## Details
[Content to be promoted to work item body or PR]
```

### Promote 規則
| 觸發條件 | Promote 動作 |
|----------|-------------|
| 重大決策 | 建立 ADR stub，連結到 work item |
| 狀態變更 | 呼叫 `workitem_update_state.py`，自動 append worklog |
| 任務完成 | 將 `deliverable.md` 內容複製到 work item body 或指定位置 |

### 建議腳本（未來實作）
- `workset_init.py --item <ID>`: 建立 workset 模板
- `workset_refresh.py --item <ID>`: 從 canonical work item 重新生成 plan snapshot
- `workset_promote.py --item <ID>`: 將 workset 內容推回 canonical

---

## 6. 風險評估

| 風險 | 緩解措施 |
|------|----------|
| 維護開銷 | Workset 是可選功能；不使用則無額外成本 |
| 隱藏真相 | Git 不追蹤 `.cache/`；強調 promote 規則；可設定 expire/TTL |
| 模型差異 | Workset 對弱模型尤其有用；強模型可不啟用 |

---

## 7. 行銷差異化文案

### 定位
Kano 比純粹的「planning template」更進一階：
- planning-with-files：單任務執行記憶 + 漂移防護
- **Kano**：多 agent 協調 + 治理 + 決策留存 + 稽核

### Promotion Bullets

| Bullet | 說明 |
|--------|------|
| **系統化多 agent 協作** | 結構化工作項 + 依賴連結 + 稽核軌跡 |
| **Decision Retention by Design** | ADR + append-only worklog + 可執行工作流 |
| **Drift-Resistant Execution Layer** | 可選 Workset (plan/notes/deliverable) 強化即時記憶 |
| **Local-First, Offline-First** | Git/files 為 canonical；可選 cloud accelerator |

### Manus/Meta 標語

> [!CAUTION]
> **以下標語需外部驗證後方可公開發佈。**

| 版本 | 標語 | 狀態 |
|------|------|------|
| **安全版** | 「Work like Manus — an AI-agent company in the spotlight.」 | ✅ 可使用 |
| **強勢版** | 「Work like Manus — the AI agent company Meta just acquired for $2B.」 | ⚠️ **需驗證**：截至 2026-01-07，我無法獨立確認 Meta 收購 Manus 的金額或交易是否完成。發佈前請查證。 |

---

## 8. 結論與下一步

1. **比較結論**：Kano backlog 已覆蓋專案級治理與長期決策留存；planning-with-files 強於「執行層即時記憶」。兩者互補。
2. **建議整合**：以「Workset as local cache」方式納入，保持 local-first 原則。
3. **行銷差異化**：可強調「systematic multi-agent collaboration + decision retention」，搭配可選 drift-resistant workset。

### 待辦
- [ ] 決定是否實作 Workset 腳本（`workset_init`, `workset_refresh`, `workset_promote`）
- [ ] 若採用，更新 SKILL.md 加入 Workset 規則
- [ ] 驗證 Manus/Meta 標語後決定是否使用強勢版

---

*此報告由 antigravity 依據 [KABSD-TSK-0104] 評估產出。*
