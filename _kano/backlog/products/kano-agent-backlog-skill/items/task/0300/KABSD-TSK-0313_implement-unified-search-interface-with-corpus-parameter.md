---
area: general
created: '2026-01-26'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0313
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: Done
tags: []
title: Implement unified search interface with --corpus parameter
type: Task
uid: 019bf8a3-1a19-7480-8d7e-e5d89468500d
updated: '2026-01-26'
---

# Context

Current search commands are inconsistent: 'search hybrid' (backlog) vs 'chunks search-repo-hybrid' (repo). Need unified interface with --corpus parameter for extensibility.

# Goal

Implement unified search interface where both query and hybrid commands accept --corpus parameter to select backlog/repo/all corpus.

# Approach

1. Add --corpus parameter to search.py commands (query, hybrid). 2. Route to appropriate corpus handler based on --corpus value. 3. Remove chunks search-repo-hybrid command. 4. Update tests and documentation.

# Acceptance Criteria

search query/hybrid --corpus {backlog|repo} works correctly. Old chunks search-repo-hybrid removed. Tests pass. Documentation updated.

# Risks / Dependencies

None - pre-alpha stage, no backward compatibility needed.

# Worklog

2026-01-26 12:49 [agent=opencode] Created item
2026-01-26 12:50 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-01-26 13:01 [agent=opencode] State -> Done.
2026-01-26 13:01 [agent=opencode] [model=unknown] Implemented unified search interface with --corpus parameter. Added --corpus to search query/hybrid commands (backlog|repo). Removed deprecated chunks search-repo-hybrid command. Updated documentation in SKILL.md and docs/multi-corpus-search.md.