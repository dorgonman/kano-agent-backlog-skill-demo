---
id: KABSD-FTR-0037
uid: 019bb336-c221-7203-93e2-6e88b9ce7fa3
type: Feature
title: "Topic Lifecycle and Materials Buffer System"
state: Done
priority: P2
parent: null
area: topic
iteration: backlog
tags: []
created: 2026-01-13
updated: 2026-01-13
owner: None
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

目前 backlog skill 需要解決「同一串聊天中頻繁上下文切換」與「任務探索過程太碎、不能全塞回 workitem」的問題。

現有實作：
- **Topic**（`.cache/worksets/topics/<topic>/`）：僅作為跨 item 分組 + 簡單 notes
- **Workset**（`.cache/worksets/items/<ITEM_ID>/`）：per-item working memory

需要重新定位：
- **Topic** 應為「動態生成的 buffer / filter（類 subtask，但不進工單系統）」
- **Materials**（raw buffer）應掛在 Topic 下，收集 code snippets refs、links、extracts、logs
- 現有 per-item Workset 概念合併到 Topic materials

比喻：雜兵（collector agents）收集 raw materials → 軍師（synthesizer）消化成 brief → 事實確定後回寫 workitem/ADR

# Goal

1. 重新定位 Topic 為「任務探索 buffer + distilled brief」
2. 在 Topic 下新增 `materials/` 作為 raw data 收集區
3. 實作 Topic Lifecycle：Collect → Distill → Publish → Close/Cleanup
4. 支援 Snippet refs 結構（引用型優先，避免大量複製貼上）
5. 合併現有 per-item Workset 到 Topic materials

# Non-Goals

- 不做 coordinator/dispatcher（將軍機制）
- 不做雲端共享後端（HTTP/MCP/DB server）
- 不做 graph RAG（可後續結合）

# Approach

## 目錄結構（方案 B：新路徑，brief.md 可選擇進版控）

```
_kano/backlog/topics/<topic>/
  manifest.json          # topic 定義與 refs（items/docs/snippets refs）
  brief.md               # distilled briefing（可分享、可回寫）
  materials/             # raw collected stuff（cache，不進版控）
    clips/               # code snippet refs + optional cached text
    links/               # urls / notes
    extracts/            # extracted paragraphs
    logs/                # build logs / command outputs
  synthesis/             # optional intermediate drafts
  publish/               # prepared write-backs (patches)
```

## Snippet refs 格式

```json
{
  "type": "snippet",
  "repo": "local",
  "revision": "abc123",
  "file": "src/config.py",
  "lines": [42, 58],
  "hash": "sha256:...",
  "cached_text": "..."
}
```

## Topic Lifecycle（三關卡）

1. **Gate A: Collect** — 把 raw 資料放入 materials/，附 provenance
2. **Gate B: Distill** — 生成 brief.md（Facts, Unknowns, Proposed Actions, Decision Candidates）
3. **Gate C: Publish** — 產出 deterministic patch 回寫 workitem/ADR

## Brief 模板

```markdown
# Topic Brief: <name>
Generated: <timestamp>

## Facts
- [ ] <fact> — [source](ref)

## Unknowns / Risks
- [ ] <unknown>

## Proposed Actions
- [ ] <action> → <workitem ref or "new ticket needed">

## Decision Candidates
- [ ] <decision> → <ADR ref or draft>
```

## CLI 指令（最小可用）

- `topic create <name>`
- `topic switch <name>`
- `topic add --item <ID> / --doc <path> / --snippet <ref>`
- `topic list / topic show <name>`
- `topic distill <name>` → 產生 brief.md
- `topic publish <name>` → 產生 patch + 可選套用
- `topic close <name>`
- `topic cleanup --ttl-days N`

## 遷移策略

- 現有 `.cache/worksets/items/` 的 per-item workset 將逐步遷移到 topic materials
- 現有 `.cache/worksets/topics/` 遷移到 `_kano/backlog/topics/`

# Alternatives

- 方案 A：沿用 `.cache/worksets/topics/`，但 brief.md 無法進版控
- 不合併 Workset：保留 per-item 獨立，但概念重疊易混淆

# Acceptance Criteria

- [ ] 能在本地建立 topic、收集 materials、生成 brief、回寫 patch、封存並 TTL 清理
- [ ] brief 與 publish patch 產出具 deterministic 特性（同樣輸入規則 → 同樣結構輸出）
- [ ] snippet refs 格式固定，且能被引用/追溯
- [ ] .gitignore/cache 規則清楚：raw materials 預設不進版控
- [ ] 現有 topic/workset 測試仍然通過（或有對應遷移）

# Risks / Dependencies

- 現有 per-item workset CLI/ops 需要重構或 deprecate
- 需要決定 brief.md 進版控的規則（自動 vs 手動）
- Snippet refs 的 revision 取得依賴 git；非 git repo 需 fallback

# Worklog

2026-01-13 01:17 [agent=copilot] Created item
2026-01-13 01:18 [agent=copilot] Filled Ready gate: Context, Goal, Approach, Acceptance Criteria, Risks
2026-01-13 02:05 [agent=antigravity] Update state to Done. Verified implementation in `kano_backlog_cli.commands.topic` and `kano_backlog_ops.topic`.
2026-01-13 01:18 [agent=copilot] Filled Ready gate: Context, Goal, Approach, Acceptance Criteria, Risks
