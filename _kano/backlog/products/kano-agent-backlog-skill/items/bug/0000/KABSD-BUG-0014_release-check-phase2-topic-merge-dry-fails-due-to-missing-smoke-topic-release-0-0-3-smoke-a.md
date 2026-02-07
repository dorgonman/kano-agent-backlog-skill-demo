---
area: release
created: '2026-02-07'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-BUG-0014
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: copilot
parent: KABSD-EPIC-0016
priority: P0
state: InProgress
tags:
- release-gate
- smoke
- topic
- merge
title: 'Release check Phase2: topic-merge-dry fails due to missing smoke topic release-0-0-3-smoke-a'
type: Bug
uid: 019c377b-af1a-72bc-a3ba-1d1bfceccc19
updated: 2026-02-07
---

# Context

Release Check Phase2 report for v0.0.3 shows only failing check is topic-merge-dry. The artifact _kano/backlog/topics/release-0-0-3/publish/phase2_smoke_topic-merge-dry.txt indicates Topic not found: release-0-0-3-smoke-a. Other smoke artifacts show topic creation collisions (topic already exists) for smoke-b. This points to sandbox backlog root mismatch or non-idempotent smoke topic naming.

# Goal

Fix the Phase2 release gate so topic-merge-dry passes deterministically by ensuring the smoke topics are created in the sandbox root and the merge command reads from that same sandbox.

# Approach

1) Re-run the Phase2 release check for 0.0.3 to reproduce. 2) Inspect the release check smoke implementation to confirm backlog root overrides and topic naming. 3) Fix root override propagation and/or naming/idempotency. 4) Add a regression assertion: verify smoke topics exist before attempting merge.

# Acceptance Criteria

- Phase2 release check for 0.0.3 passes including topic-merge-dry. - Smoke does not depend on canonical topics under _kano/backlog/topics. - Artifacts show clear, consistent sandbox root usage.

# Risks / Dependencies

Smoke may be flaky if it depends on shared topic state or if backlog root override is missing in any step. Collisions can occur if topic names are not unique within the sandbox.

# Worklog

2026-02-07 17:42 [agent=copilot] Created item [Parent Ready gate validated]
2026-02-07 17:43 [agent=copilot] Updated Ready fields: Context, Goal, Approach, Acceptance Criteria, Risks
2026-02-07 17:47 [agent=copilot] Updated Ready fields: Context, Goal, Approach, Acceptance Criteria, Risks
2026-02-07 17:47 [agent=copilot] State -> Planned.
2026-02-07 18:55 [agent=copilot] State -> Done.
2026-02-07 18:55 [agent=copilot] State -> InProgress. [Ready gate validated]
