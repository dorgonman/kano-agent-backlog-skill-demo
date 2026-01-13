---
area: general
created: '2026-01-14'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-BUG-0004
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
title: Product snapshots include stubs from other skills
type: Bug
uid: 019bb88c-7943-70d5-ad94-71c01e8259d6
updated: 2026-01-14
---

# Context

When running snapshot with --scope product:<name>, stub scanning currently runs at repo root (or root/src), so product snapshots can include TODO/NotImplementedError from other skills (e.g. kano-commit-convention-skill snapshot lists kano-agent-backlog-skill stubs).

# Goal

Ensure product-scoped snapshots only scan stubs within the selected product's skill folder (and/or its backlog product folder), not the entire monorepo.

# Approach

In kano_backlog_ops.snapshot.generate_pack, choose stub scan root based on product: prefer <repo>/skills/<product> if present; otherwise fallback to <repo>/_kano/backlog/products/<product>; only use <repo>/src or repo root for scope=repo.

# Acceptance Criteria

Running snapshot create all --scope product:kano-commit-convention-skill no longer lists kano-agent-backlog-skill stubs; repo-scoped snapshots still scan whole repo as before; tests updated if needed.

# Risks / Dependencies

Some users may expect product snapshots to include shared/root-level stubs; clarify behavior as product-local for reproducibility.

# Worklog

2026-01-14 02:09 [agent=developer] Created item
2026-01-14 02:09 [agent=developer] [model=unknown] Fixing product-scoped stub scan root to avoid cross-skill leakage.
2026-01-14 02:11 [agent=developer] [model=unknown] Fixed product snapshot stub scan root to prefer skills/<product> (or backlog product root). Regenerated snapshots; commit-convention snapshot no longer includes kano-agent-backlog-skill stubs.
