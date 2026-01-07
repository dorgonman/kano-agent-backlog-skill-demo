---
id: KABSD-TSK-0119
uid: 019b985b-096c-735c-9dcc-0062dd31e0db
type: Task
title: "Design local multi-agent collaboration: multi repo via Git worktree"
state: Proposed
priority: P2
parent: KABSD-FTR-0020
area: collaboration
iteration: null
tags: ["multi-agent", "multi-repo", "worktree"]
created: 2026-01-07
updated: 2026-01-07
owner: null
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

Local multi-agent collaboration across multiple repos can be orchestrated with Git worktree setups, allowing agents to work in parallel while sharing a common history. We need patterns for mapping items to worktrees and ensuring consistency.

# Goal

- Define safe patterns for multi-repo local work using Git worktree.
- Map collaboration workflows (claim/lease) across worktrees.
- Document sync/merge strategies and visibility in dashboards.

# Non-Goals

- Implement remote synchronization.

# Approach

1. Propose worktree layout conventions (paths, naming, mapping to items/branches).
2. Define claim/lease rules across worktrees and handoff etiquette.
3. Describe merge/integration cadence and conflict resolution.
4. Identify helper scripts for worktree setup/cleanup and index refresh.

# Alternatives

- Use separate clones without shared history (harder integration).

# Acceptance Criteria

- A documented worktree-based workflow exists with clear setup/teardown steps.
- Visibility and index refresh mechanism are described.
- Conflict management guidance is included.

# Risks / Dependencies

- Worktree complexity may confuse users; provide automation.
- Tooling differences across platforms (paths, symlinks).

# Worklog

2026-01-07 20:07 [agent=copilot] Created to define patterns using git worktree multi-repo setups for parallel agent work.
