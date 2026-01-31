---
area: core
created: '2026-01-31'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0065
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P1
state: Proposed
tags:
- id-management
- robustness
- ux
title: Improve ID allocation robustness and prevent ID collisions
type: Feature
uid: 019c11f1-c065-77be-9559-c6f0a10f963f
updated: '2026-01-31'
---

# Context

Agents can create duplicate IDs when DB sequences are stale, leading to ID collisions and manual cleanup. Root cause: lack of documentation, no automatic detection, and no preventive measures in CLI.

# Goal

Make ID allocation robust and foolproof through documentation, automatic detection, and preventive measures.

# Approach

1. Document ID allocation mechanism in SKILL.md (KABSD-TSK-0335)
2. Add CLI warnings for stale sequences (KABSD-TSK-0337)
3. Add doctor health checks (KABSD-TSK-0338)
4. Auto-sync sequences in item create (KABSD-TSK-0339)
5. Ensure all changes maintain backward compatibility

# Acceptance Criteria

- SKILL.md documents ID allocation completely
- CLI warns when sequences are stale
- doctor command checks sequence health
- item create auto-syncs when needed
- No ID con normal workflows
- All tests pass

# Risks / Dependencies

Performance impact from auto-sync. Mitigation: optimize sync-sequences or add caching.

# Worklog

2026-01-31 10:46 [agent=opencode] Created item