---
id: KABSD-TSK-0188
uid: 019bb338-c4f4-7379-8422-1c5838e1a736
type: Task
title: "Restructure Topic directory to _kano/backlog/topics with materials buffer"
state: InProgress
priority: P2
parent: KABSD-FTR-0037
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

現有 Topic 儲存於 `.cache/worksets/topics/<topic>/`，屬於 derived cache。
根據 KABSD-FTR-0037 設計，Topic 需要遷移到 `_kano/backlog/topics/<topic>/`，讓 brief.md 可選擇進版控。
同時需要新增 `materials/` 子目錄結構（clips/links/extracts/logs）作為 raw buffer。

# Goal

1. 更新 `kano_backlog_ops/topic.py` 的目錄路徑函式，指向新位置
2. 新增 `materials/` 子目錄結構於 topic create 時自動建立
3. 更新 manifest.json schema 以支援 snippet refs
4. 確保現有 topic CLI 指令（create/add/switch/list）正常運作

# Approach

1. 修改 `get_topics_root()` 回傳 `backlog_root / "topics"` 而非 `.cache/worksets/topics`
2. 修改 `create_topic()` 建立 `materials/{clips,links,extracts,logs}` 子目錄
3. 擴充 `TopicManifest` dataclass 新增 `snippet_refs: List[SnippetRef]` 欄位
4. 新增 `SnippetRef` dataclass（type, repo, revision, file, lines, hash, cached_text）
5. 更新測試

# Acceptance Criteria

- [ ] `topic create` 在 `_kano/backlog/topics/<name>/` 建立完整結構
- [ ] `materials/{clips,links,extracts,logs}` 子目錄存在
- [ ] manifest.json 包含 snippet_refs 欄位（預設空陣列）
- [ ] 現有 topic property-based tests 通過

# Risks / Dependencies

- 現有 `.cache/worksets/topics/` 的資料需要手動遷移或清理
- 需要更新 .gitignore 規則以排除 `topics/*/materials/`

# Worklog

2026-01-13 01:20 [agent=copilot] Created item
2026-01-13 01:21 [agent=copilot] Filled Ready gate
2026-01-13 01:21 [agent=copilot] State -> InProgress.
