---
area: embedding
created: '2026-01-27'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0315
iteration: 0.0.2
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0061
priority: P1
state: Done
tags: []
title: Implement binary vector storage format (struct.pack)
type: Task
uid: 019bfb8c-9c7d-760c-a11b-f89e51a40f7c
updated: '2026-01-27'
---

# Context

Vector indexes store embeddings as JSON (30KB/vector), consuming 836 MB for 26,857 vectors. AAA projects with 3M chunks would need 95 GB storage.

# Goal

Implement binary vector storage using struct.pack to reduce storage by 74.5% (836 MB → 213 MB)

# Approach

Add storage_format parameter to SQLiteVectorBackend; Use struct.pack('f'*1536) for binary, json.dumps() for JSON; Auto-detect format on read; Add --storage-format CLI flag

# Acceptance Criteria

Binary storage saves 74.5% space; Query performance unchanged (~16ms); Auto-detect format on read; CLI flag --storage-format binary|json works

# Risks / Dependencies

None - backward compatible with auto-detection

# Worklog

2026-01-27 02:24 [agent=opencode] Created item [Parent Ready gate validated]
2026-01-27 02:26 [agent=opencode] State -> Done.
2026-01-27 02:26 [agent=opencode] [model=unknown] Implemented binary vector storage using struct.pack. Benchmarked: 836 MB to 213 MB (74.5% savings), query speed 16ms (no regression). Commit: feat(vector): add binary storage format for 74.5% space savings