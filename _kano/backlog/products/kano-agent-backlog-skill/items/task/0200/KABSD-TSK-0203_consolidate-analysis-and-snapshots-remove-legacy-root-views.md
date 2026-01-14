---
area: general
created: '2026-01-14'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0203
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: developer
parent: KABSD-FTR-0038
priority: P2
state: Done
tags: []
title: Consolidate analysis and snapshots; remove legacy root views
type: Task
uid: 019bbc2b-0de1-721b-b2c9-6835f75e0c3c
updated: 2026-01-14
---

# Context

We want analysis outputs to live alongside deterministic snapshot packs and be committed, and we want to remove the legacy repo-level _kano/backlog/views directory.

# Goal

1) Move existing analysis markdown into the snapshots tree. 2) Ensure analysis outputs are not gitignored so they can be committed. 3) Stop writing repo-scope snapshots under _kano/backlog/views so that folder can be deleted.

# Approach

- Move views/_analysis -> views/snapshots/_analysis for kano-agent-backlog-skill.\n- Update references inside the analysis markdown files.\n- Update snapshot CLI output routing for scope=repo to write under the default product at views/snapshots/repo/.\n- Remove legacy _kano/backlog/views folder.

# Acceptance Criteria

- No analysis files remain under views/_analysis; they exist under views/snapshots/_analysis.\n- .gitignore no longer ignores analysis outputs.\n- kano-backlog snapshot create/report with --scope repo writes under _kano/backlog/products/<default>/views/snapshots/repo/.\n- _kano/backlog/views is removed from the repo.

# Risks / Dependencies

- Some documentation may still reference _kano/backlog/views and should be updated separately if confusing.

# Worklog

2026-01-14 19:01 [agent=developer] Created item
2026-01-14 19:03 [agent=developer] [model=unknown] State -> InProgress.
2026-01-14 19:05 [agent=developer] [model=GPT-5.2] State -> InProgress.
2026-01-14 19:12 [agent=developer] [model=GPT-5.2] Consolidated analysis under snapshots, stopped ignoring analysis outputs, migrated repo-scope snapshot outputs out of legacy _kano/backlog/views, and removed the legacy root views folder.
