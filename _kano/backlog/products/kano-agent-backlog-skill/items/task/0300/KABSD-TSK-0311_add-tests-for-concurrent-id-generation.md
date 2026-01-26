---
id: KABSD-TSK-0311
uid: 019bf65a-924f-76b0-aabc-90d254c3a2cd
type: Task
title: "Add tests for concurrent ID generation"
state: Done
priority: P2
parent: KABSD-FTR-0060
area: general
iteration: backlog
tags: []
created: 2026-01-26
updated: 2026-01-26
owner: opencode
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

We need to verify that the DB-based approach actually solves the race condition.

# Goal

Add integration tests that simulate concurrent item creation to ensure uniqueness.

# Approach

1. Create a test using `concurrent.futures.ThreadPoolExecutor` or `ProcessPoolExecutor`
2. Spawn multiple threads/processes trying to generate IDs simultaneously
3. Verify that all generated IDs are unique and sequential (no gaps, no duplicates)
4. Verify behavior when DB is locked

# Acceptance Criteria

- Test with 10+ concurrent threads generating 100+ IDs passes
- No duplicate IDs generated
- Test fails if using the old file-scan method (proving the test is valid)

# Risks / Dependencies

**Risks**:
- Flaky tests due to timing issues (mitigate: sufficiently high concurrency and iteration count)

**Dependencies**:
- KABSD-TSK-0309 (Core logic)

# Worklog

2026-01-26 02:11 [agent=opencode] Created item

2026-01-26 02:23 [agent=opencode] State -> InProgress.
2026-01-26 02:24 [agent=opencode] State -> Done.
