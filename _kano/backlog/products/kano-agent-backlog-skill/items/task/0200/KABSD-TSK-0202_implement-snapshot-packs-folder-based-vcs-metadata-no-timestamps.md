---
area: general
created: '2026-01-14'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0202
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: developer
parent: KABSD-FTR-0039
priority: P2
state: Done
tags: []
title: 'Implement snapshot packs: folder-based, VCS metadata, no timestamps'
type: Task
uid: 019bb883-1f8f-73e9-ae0b-5524d8d489f0
updated: 2026-01-14
---

# Context

Snapshot outputs currently write timestamped files in views/snapshots and only record Git SHA, making reproducibility and diffs noisy.

# Goal

Deliver folder-based snapshot packs that carry VCS-agnostic metadata (provider/revision/ref/label/dirty) and remove timestamp usage.

# Approach

Add a VCS adapter layer (git + null) to supply metadata; refactor snapshot generation/meta to rely on VCS data only; switch snapshot output paths to deterministic folders without timestamps; include metadata block in markdown/JSON outputs; update docs/tests as needed.

# Acceptance Criteria

No timestamps in snapshot filenames or content; VCS metadata block present and follows KABSD-FTR-0039; default outputs overwrite deterministically; tests/docs updated for new behavior.

# Risks / Dependencies

Legacy scripts expecting timestamped snapshot filenames may break; VCS detection could fail on non-git environments; path collisions if scope/view naming overlaps; Windows path edge cases.

# Worklog

2026-01-14 01:59 [agent=developer] Created item
2026-01-14 02:05 [agent=developer] [model=unknown] Started implementing snapshot pack VCS metadata and folder outputs.
2026-01-14 02:05 [agent=developer] [model=unknown] Implemented VCS-agnostic snapshot metadata, folder-based outputs, and updated templates/tests; pytest snapshot suite passing.
