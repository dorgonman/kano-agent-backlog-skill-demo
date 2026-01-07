---
id: KABSD-TSK-0104
uid: 019b962e-c5f6-75cd-b509-5695dfe10991
type: Task
title: "Evaluate integrating working memory on disk into Kano Backlog"
state: Done
priority: P2
parent: null
area: research
iteration: null
tags: ["planning", "integration", "evaluation"]
created: 2026-01-07
updated: 2026-01-07
owner: antigravity
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
---

# Context

`planning-with-files` 提出了一種「working memory on disk」模式：
- 每個任務使用三個檔案：`task_plan.md`（檢查清單計劃）、`notes.md`（研究筆記）、`deliverable.md`（最終產出）
- 目的：防止 agent drift，跨 session 保持執行上下文

Kano backlog 已實現部分功能（結構化工作項、ADR、worklog），但需評估是否整合「即時執行層記憶」的優點。

## 參考來源
- [planning-with-files SKILL.md](https://github.com/OthmanAdi/planning-with-files/blob/master/planning-with-files/SKILL.md)

# Goal

1. 比較兩套系統並識別差距
2. 評估將最佳部分整合到 Kano backlog（作為可選功能）
3. 輸出行銷差異化文案：「系統化多 agent 協作 + 決策留存」

# Non-Goals

- 破壞現有 local-first 原則
- 將 cache 變成唯一真相來源
- 與其他 skill 產生耦合依賴

# Approach

1. **比較報告**：逐軸比較 planning-with-files vs Kano backlog
   - 範圍與粒度
   - 資料模型
   - 漂移防護 vs 長期完整性
   - 自動化與護欄
2. **整合規格**（如建議採用）：Workset 資料夾佈局、模板、promote 規則
3. **行銷差異化**：promotion 文案（含安全版 + 需驗證版）

# Alternatives

- 不整合，僅將 planning-with-files 當作外部參考
- 完整搬遷至類似 Manus 的記憶體管理（過度設計風險）

# Acceptance Criteria

- [x] 比較報告精確區分「推論」vs「已確認」
- [x] 整合方案最小化，不破壞現有不變量
- [x] 行銷區塊包含 safe version 和 needs-verification version 的 Manus/Meta 語句

# Risks / Dependencies

- 維護開銷：多一層 cache 檔案需要維護
- 隱藏真相風險：若 workset 成為實際工作區但不 promote 回 canonical
- 需驗證 Manus/Meta 收購金額等外部聲明

# Worklog

2026-01-07 10:00 [agent=antigravity] Created from template.
2026-01-07 10:01 [agent=antigravity] Populated task scope, acceptance criteria, and deliverables based on user discussion with ChatGPT.
2026-01-07 14:10 [agent=antigravity] Completed evaluation. Report generated at [workset_evaluation_report.md](../../../artifacts/workset_evaluation_report.md). State changed to Done.
