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

# Context

Existing Topics are stored in `.cache/worksets/topics/<topic>/`, which is a derived cache.
According to KABSD-FTR-0037 design, Topics need to be migrated to `_kano/backlog/topics/<topic>/` so that brief.md can optionally be version controlled.
Simultaneously, a `materials/` subdirectory structure (clips/links/extracts/logs) is needed as a raw buffer.

# Goal

1. Update directory path function in `kano_backlog_ops/topic.py` to point to the new location.
2. Create `materials/` subdirectory structure automatically during topic creation.
3. Update manifest.json schema to support snippet refs.
4. Ensure existing topic CLI commands (create/add/switch/list) work normally.

# Approach

1. Modify `get_topics_root()` to return `backlog_root / "topics"` instead of `.cache/worksets/topics`.
2. Modify `create_topic()` to create `materials/{clips,links,extracts,logs}` subdirectories.
3. Extend `TopicManifest` dataclass to add `snippet_refs: List[SnippetRef]` field.
4. Add `SnippetRef` dataclass (type, repo, revision, file, lines, hash, cached_text).
5. Update tests.

# Acceptance Criteria

- [ ] `topic create` builds the complete structure in `_kano/backlog/topics/<name>/`.
- [ ] `materials/{clips,links,extracts,logs}` subdirectories exist.
- [ ] manifest.json includes snippet_refs field (default empty array).
- [ ] Existing topic property-based tests pass.

# Risks / Dependencies

- Existing data in `.cache/worksets/topics/` needs manual migration or cleanup.
- Need to update .gitignore rules to exclude `topics/*/materials/`.

# Worklog

2026-01-13 01:20 [agent=copilot] Created item
2026-01-13 01:21 [agent=copilot] Filled Ready gate
2026-01-13 01:21 [agent=copilot] State -> InProgress.
