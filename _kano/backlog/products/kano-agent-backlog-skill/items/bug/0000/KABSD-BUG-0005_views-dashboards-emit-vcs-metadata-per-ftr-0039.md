---
area: core
created: '2026-01-18'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-BUG-0005
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: KABSD-FTR-0039
priority: P1
state: Done
tags: []
title: 'Views: dashboards emit VCS metadata per FTR-0039'
type: Bug
uid: 019bccb7-2f44-7182-8b45-3ee7193dc2b1
updated: 2026-01-18
---

# Context

Generated dashboards under _kano/backlog/products/<product>/views (Dashboard_PlainMarkdown_*.md) currently emit a kano:build block using vcs.revision and omit vcs.branch/vcs.revno/vcs.hash, which violates the KABSD-FTR-0039 metadata spec (provider/branch/revno/hash/dirty).

# Goal

Make view refresh emit the VCS-agnostic metadata block per KABSD-FTR-0039 (fixed field order, no timestamps), including correct Git branch, commit-count revno, full commit hash, and dirty flag.

# Approach

Update kano_backlog_core.vcs detection/formatting to output provider/branch/revno/hash/dirty (min/full), and enhance Git adapter to populate branch, revno, and hash consistently. Regenerate dashboards via kano-backlog view refresh and adjust any tests/templates that validate metadata.

# Acceptance Criteria

1) After running kano-backlog view refresh, Dashboard_PlainMarkdown_{Active,New,Done}.md contain a kano:build block with vcs.provider, vcs.branch, vcs.revno, vcs.hash, vcs.dirty (in that order) and no timestamps. 2) Git repos show correct values for those fields. 3) Existing snapshot/report generation remains deterministic and continues to emit the same schema.

# Risks / Dependencies

Changing metadata keys may break downstream parsers expecting vcs.revision; mitigate by ensuring internal parsing accepts both keys or by providing a compatibility mapping in code.

# Worklog

2026-01-18 00:08 [agent=codex] [model=unknown] Created item
2026-01-18 00:09 [agent=codex] [model=unknown] Start fixing view VCS metadata to match KABSD-FTR-0039 (provider/branch/revno/hash/dirty).
2026-01-18 00:49 [agent=codex] [model=unknown] Fixed kano_backlog_core.vcs formatting to follow KABSD-FTR-0039 (provider/branch/revno/hash/dirty) and enhanced Git adapter to populate branch+revno+hash; refreshed dashboards and added tests.
