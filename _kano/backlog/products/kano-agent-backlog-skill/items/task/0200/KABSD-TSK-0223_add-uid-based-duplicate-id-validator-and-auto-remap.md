---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0223
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: null
priority: P2
state: Done
tags: []
title: Add UID-based duplicate ID validator and auto-remap
type: Task
uid: 019bc550-8ef9-739c-9fd1-49289deb9a10
updated: 2026-01-16
---

# Context

Duplicate IDs should be permitted when UIDs differ; only conflicting UID reuse with differing content should be flagged. Current validation/linking uses filename IDs and treats duplicates as ambiguous.

# Goal

Add UID-aware duplicate-ID detection and auto-remap support, plus CLI surface to report conflicts and remap duplicates deterministically.

# Approach

Implement a scanner that groups items by ID, compares UIDs/content hashes, and emits conflicts only when same UID has diverged content. For non-conflicting duplicates, assign new IDs (next available) and update references. Add an admin subcommand and wire into CLI.

# Acceptance Criteria

CLI command reports duplicate IDs with UID info; only same-UID/different-content reported as conflict; non-conflicting duplicates can be auto-remapped; link validation no longer fails solely due to duplicate IDs.

# Risks / Dependencies

Auto-remap could update unintended references; mitigate with deterministic selection and optional dry-run.

# Worklog

2026-01-16 13:39 [agent=codex] [model=unknown] Created item
2026-01-16 13:39 [agent=codex] [model=unknown] Started UID-based duplicate ID validator/remap work.
2026-01-16 13:43 [agent=codex] [model=unknown] Implemented admin links normalize-ids for UID-aware duplicate ID detection/remap, and added ops support in validate.normalize_duplicate_ids.
2026-01-16 14:04 [agent=codex] [model=unknown] Completed UID-aware duplicate ID normalization command and CLI.
