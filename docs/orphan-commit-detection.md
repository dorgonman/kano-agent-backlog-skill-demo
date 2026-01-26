# Backlog Discipline: Orphan Commit Detection

## 問題

開發時常常「先上車後補票」：
- 先寫 code，commit 後才想到要開票
- 忘記補票，導致工作沒有記錄
- 事後很難回憶當時的決策和 context

## 解決方案

實作了三層提醒機制：

### 1. Git Hooks（即時提醒）

**commit-msg hook**：commit 前警告
```bash
⚠️  WARNING: No backlog item ID found in commit message

   Recommended actions:
   1. Create a backlog item:
      kano-backlog item create --type task --title "..."

   2. Update commit message to include ticket ID:
      git commit --amend -m "KABSD-TSK-XXXX: your message"
```

**post-commit hook**：commit 後建議
```bash
📋 BACKLOG REMINDER: No ticket ID found in commit

Commit: a1b2c3d
Message: Add binary vector storage support...

💡 Suggested action: Create a TASK item

Quick commands:
  kano-backlog item create --type task --title "..."
```

**啟用方式：**
```bash
cd skills/kano-agent-backlog-skill
git config core.hooksPath .githooks
```

### 2. CLI 命令（批次檢查）

**檢查最近的 commits：**
```bash
kano-backlog orphan check --days 7
```

輸出：
```
Commit Analysis (last 7 days)

 Total commits       13 
 ✅ With tickets     0  
 ⚠️  Orphan commits   13 
 📝 Trivial commits  0  

⚠️  Orphan Commits (need tickets):

| Hash    | Date       | Message                          |
|---------|------------|----------------------------------|
| b68c065 | 2026-01-27 | feat(cli): add orphan detection  |
| 6b0271b | 2026-01-27 | feat(embedding): support vLLM    |
| 8d8224a | 2026-01-27 | feat(vector): add metadata files |
```

**建議 ticket 類型：**
```bash
kano-backlog orphan suggest b68c065
```

輸出：
```
Commit: b68c065
Message: feat(cli): add orphan detection...

💡 Suggested ticket:
  Type: TASK
  Title: add orphan detection

Create ticket:
  kano-backlog item create \
    --type task \
    --title "add orphan detection" \
    --product kano-agent-backlog-skill
```

### 3. 智能檢測（減少誤報）

**自動豁免的 commits：**
- `docs:` - 文件更新
- `chore:` - 雜項工作
- `style:` - 格式調整
- `Merge` - 合併 commit
- `Revert` - 回退 commit

**智能建議：**
- `feat:` → 建議 Task
- `fix:` → 建議 Bug
- `refactor:` → 建議 Task (refactoring)
- 修改 test 檔案 → 建議 Task (test)

## 使用場景

### 場景 1：理想流程（先開票）

```bash
# 1. 先開票
kano-backlog item create --type task --title "Add feature X"
# Output: KABSD-TSK-0318

# 2. 開發
vim src/feature.py

# 3. Commit（帶 ticket ID）
git commit -m "KABSD-TSK-0318: implement feature X"

# ✅ 沒有警告！
```

### 場景 2：先做後補（可接受）

```bash
# 1. 開發 + commit
git commit -m "feat: add feature X"

# ⚠️  Hook 警告你！

# 2. 立刻補票
kano-backlog item create --type task --title "Add feature X"
# Output: KABSD-TSK-0318

# 3. 修改 commit message
git commit --amend -m "KABSD-TSK-0318: add feature X"
```

### 場景 3：批次補票（週五回顧）

```bash
# 1. 檢查本週的 orphan commits
kano-backlog orphan check --days 7

# 2. 為每個 commit 建議 ticket
kano-backlog orphan suggest <hash>

# 3. 批次創建 tickets
for hash in $(git log --oneline --since="7 days ago" | cut -d' ' -f1); do
  kano-backlog orphan suggest $hash
done

# 4. Interactive rebase 更新 commit messages
git rebase -i HEAD~10
```

## 設計哲學

### 「溫柔提醒，不是嚴格執行」

**為什麼不 block commit？**
1. **保持生產力**：緊急修復不應該被流程阻擋
2. **鼓勵探索**：實驗性工作可以先做再決定要不要開票
3. **避免反感**：太嚴格的規則會讓人想繞過
4. **建立習慣**：溫柔提醒比強制執行更能培養好習慣

**設計原則：**
- ✅ 警告，不是錯誤
- ✅ 提供具體建議（copy-paste 命令）
- ✅ 智能檢測（豁免 trivial commits）
- ✅ 容易關閉（`--no-verify`）

## 實際效果

### 我們這次的經驗

**問題：**
- 做了 3 個功能（binary storage, metadata files, vLLM support）
- 全部都是「先做後補票」
- 差點忘記補票

**如果有這個機制：**
```bash
# 第一個 commit
git commit -m "feat(vector): add binary storage"

# Hook 立刻提醒：
⚠️  WARNING: No backlog item ID found

# 立刻補票
kano-backlog item create --type task --title "Binary storage"
# Output: KABSD-TSK-0315

# 修改 commit
git commit --amend -m "KABSD-TSK-0315: add binary storage"

# ✅ 不會忘記！
```

### 預期改善

**Before（沒有提醒）：**
- 10 個 commits → 3 個有票（30%）
- 7 個 orphan commits 需要事後補票
- 容易忘記，導致工作沒記錄

**After（有提醒）：**
- 10 個 commits → 8 個有票（80%）
- 2 個 orphan commits（trivial 或實驗性）
- 即時補票，不會忘記

## 整合到 CI/CD

### GitHub Actions

```yaml
name: Check Backlog Discipline

on: [pull_request]

jobs:
  check-tickets:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Check commit messages
        run: |
          git log origin/main..HEAD --pretty=%s | while read msg; do
            if ! echo "$msg" | grep -qE "KABSD-|^(docs|chore|style):"; then
              echo "❌ Commit without ticket: $msg"
              exit 1
            fi
          done
```

### Pre-push Hook（可選）

```bash
# .githooks/pre-push
# 阻止 push 沒有 ticket 的 commits

while read local_ref local_sha remote_ref remote_sha; do
    commits=$(git log "$remote_sha..$local_sha" --pretty=%s)
    
    while IFS= read -r msg; do
        if ! echo "$msg" | grep -qE "KABSD-|^(docs|chore|style):"; then
            echo "❌ Cannot push: Commit without ticket: $msg"
            exit 1
        fi
    done <<< "$commits"
done
```

## 文件

### 完整文件
- `.githooks/README.md` - Git hooks 使用指南
- `kano-backlog orphan --help` - CLI 命令說明

### 快速參考

**啟用 hooks：**
```bash
git config core.hooksPath .githooks
```

**檢查 orphan commits：**
```bash
kano-backlog orphan check --days 7
```

**建議 ticket 類型：**
```bash
kano-backlog orphan suggest <commit-hash>
```

**暫時關閉 hook：**
```bash
git commit --no-verify -m "emergency fix"
```

## 總結

### 實作內容

1. **Git Hooks**
   - commit-msg: 警告沒有 ticket ID
   - post-commit: 建議創建 ticket
   - 完整文件和範例

2. **CLI 命令**
   - `orphan check`: 批次檢查
   - `orphan suggest`: 智能建議
   - 支援 table/json/plain 輸出

3. **智能檢測**
   - 自動豁免 trivial commits
   - 根據 commit 內容建議 ticket 類型
   - 提供 copy-paste 命令

### 設計理念

**「溫柔提醒，不是嚴格執行」**

- 警告，不是錯誤
- 提供具體建議
- 容易關閉
- 建立好習慣

### 預期效果

- 補票率從 30% 提升到 80%
- 減少「忘記補票」的情況
- 保持開發流暢度
- 培養良好的工作紀律

---

**相關 Commits：**
- Skill: `feat(cli): add orphan commit detection and git hooks for backlog discipline`
- Demo: `feat(backlog): add orphan commit detection and git hooks`

**相關文件：**
- `.githooks/README.md`
- `.githooks/commit-msg`
- `.githooks/post-commit`
- `src/kano_backlog_cli/commands/orphan.py`
