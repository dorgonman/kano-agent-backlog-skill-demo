---
id: KABSD-TSK-0119
uid: 019b985b-096c-735c-9dcc-0062dd31e0db
type: Task
title: "Design local multi-agent collaboration: multi repo via Git worktree"
state: Done
priority: P2
parent: KABSD-FTR-0020
area: collaboration
iteration: null
tags: ["multi-agent", "multi-repo", "worktree"]
created: 2026-01-07
updated: 2026-01-08
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

## Workflow (Worktree-Based Parallelism)

This mode uses **one Git repository** with **multiple worktrees** (separate working directories) so agents can operate concurrently with lower filesystem contention.

### Recommended Worktree Layout

```
repo-root/                      # Main worktree (integration)
_worktrees/
  agent-copilot/
    KABSD-TSK-0119/              # Per-item worktree
  agent-claude/
    KABSD-TSK-0120/
```

### Branch Naming Convention

- `agent/<agent>/<item-id>-<slug>`

### Setup / Teardown

1. **Claim item** (same as single-repo): set `owner`, append Worklog “Claimed (lease)”.
2. **Create branch** from integration branch (e.g., `main`).
3. **Add worktree**
   - `git worktree add _worktrees/agent-<agent>/<item-id> agent/<agent>/<item-id>-<slug>`
4. **Work** in that worktree only; keep changes scoped.
5. **Integrate** via PR or local merge into integration branch.
6. **Remove worktree** after merge:
   - `git worktree remove _worktrees/agent-<agent>/<item-id>`
   - `git branch -d agent/<agent>/<item-id>-<slug>` (once merged)

## Claim/Lease Across Worktrees

- The **lease is still represented in the backlog item** (`owner` + Worklog), not by Git.
- Worktrees reduce accidental file edit collisions but do not remove the need for lease discipline.

## Integration Cadence

- Prefer **short-lived branches** per item.
- Merge frequently to reduce long-lived divergence.
- If two agents must touch the same underlying file, decide a single “file owner” temporarily and record it in Worklog.

## Invariants

- Each worktree corresponds to exactly one active item (default).
- No two active worktrees should modify the same backlog item file.
- Canonical items remain SSOT; derived data is rebuildable.

## Helper Scripts (Optional)

- `kano worktree create --item <id> --agent <name>`: creates branch + adds worktree.
- `kano worktree cleanup --agent <name>`: removes merged worktrees.
- `kano index build --incremental`: run after merge to refresh views.

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
2026-01-08 00:10 [agent=copilot] Documented worktree layout, branch conventions, setup/teardown workflow, and invariants.
2026-01-08 07:24 [agent=copilot] Documented worktree-based collaboration workflow with layout, branch conventions, setup/teardown, integration cadence, and invariants
