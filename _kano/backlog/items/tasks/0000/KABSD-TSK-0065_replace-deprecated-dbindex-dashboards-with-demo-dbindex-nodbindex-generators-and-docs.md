---
id: KABSD-TSK-0065
type: Task
title: "Replace deprecated DBIndex dashboards with demo DBIndex/NoDBIndex generators and docs"
state: Done
priority: P2
parent: KABSD-FTR-0001
area: views
iteration: null
tags: ["views", "demo", "sqlite"]
created: 2026-01-06
updated: 2026-01-06
owner: codex-cli
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

# Goal

# Non-Goals

# Approach

# Alternatives

# Acceptance Criteria

# Risks / Dependencies

# Worklog

2026-01-06 07:38 [agent=codex-cli] Created task to remove deprecated DBIndex dashboards, generate DBIndex/NoDBIndex demo views, and document view generation scripts.
2026-01-06 07:39 [agent=codex-cli] State -> InProgress. Implementing demo view generators (DBIndex/NoDBIndex), cleaning deprecated dashboards, and updating docs.
2026-01-06 07:48 [agent=codex-cli] State -> Done. Added view_generate_demo.py to generate DBIndex/NoDBIndex demo dashboards under views/_demo; updated Dashboard docs and views reference; added project-specific focus-view tool example; retained legacy Dashboard_DBIndex_* files as deprecated pointers due to delete restrictions in this environment.
