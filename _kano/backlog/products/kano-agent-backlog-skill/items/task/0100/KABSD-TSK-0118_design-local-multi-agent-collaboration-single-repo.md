---
id: KABSD-TSK-0118
uid: 019b985a-dd84-7df1-8713-491415539d85
type: Task
title: "Design local multi-agent collaboration: single repo"
state: Done
priority: P1
parent: KABSD-FTR-0020
area: collaboration
iteration: null
tags: ["multi-agent", "single-repo"]
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

Local multi-agent collaboration within a single repository requires clear workflows to prevent conflicts and ensure auditable progress. Agents need claim/lease mechanisms on items, predictable state transitions, and conventions for file operations.

# Goal

- Define single-repo collaboration workflows (claim/lease, handoff, merge etiquette).
- Document conflict avoidance: file-level locks or logical leases, plus commit conventions.
- Specify minimal tooling/hooks to assist agents (e.g., pre-commit checks, status validation).

# Non-Goals

- Implement remote synchronization or multi-repo setups.

# Approach

1. Describe claim/lease lifecycle on Tasks/Features/UserStories.
2. Propose file operation rules (append-only worklog, no history rewrite; consistent timestamps/agents).
3. Define merge/review etiquette and compatibility with dashboards/index.
4. Identify lightweight hooks/scripts to enforce Ready gate and prevent in-progress collisions.

## Workflow (Single Repo)

**Actors:** multiple agents working in one Git repo.

**Claim/Lease concept:** a *lease* is a social+automatable convention that “Agent X is the only writer for item Y right now”. In single-repo mode the lease is represented by:

- `owner: <agent>` in the item frontmatter
- a Worklog entry that declares claim / release
- state transition to `InProgress` when work starts (after Ready gate)

### Lifecycle

1. **Select work**
  - Pick a `New`/`Proposed`/`Ready` Task.
  - If item is not `Ready`, bring it to Ready by filling required sections.

2. **Claim (acquire lease)**
  - Set `owner` to the agent name.
  - Append Worklog: `Claimed by <agent> (lease)`.
  - Optional: move item to `InProgress` when actual implementation begins.

3. **Work loop**
  - Keep changes focused to the claimed item.
  - Append Worklog for load-bearing decisions and state changes.
  - Prefer small PRs/commits; keep the item file updated.

4. **Review / integrate**
  - Use PR (preferred) even locally to force review discipline.
  - Ensure index/views regeneration is run after merge (derived data refresh).

5. **Release (handoff or done)**
  - If handing off: append Worklog `Released lease to <next-agent>` and set `owner` accordingly.
  - If done: transition to `Done`, append Worklog summary.

## Conflict Avoidance Practices

- **One writer per item**: only the lease holder edits the item file and its artifacts.
- **Branch naming**: `agent/<agent>/<item-id>-<slug>`.
- **Scope fence**: do not mix multiple items in a single commit/PR unless unavoidable.
- **Rebase policy**: prefer merge commits or squash merges; avoid rewriting shared history.

## Invariants

- Canonical markdown files remain the SSOT.
- Worklog is append-only; never delete/rewind entries.
- `updated` is only advanced via tool-driven updates (keeps audit trail consistent).
- Derived index/views are rebuildable; stale derived data is acceptable short-term but must be refreshed before “Done”.

## Minimal Tooling / Hooks (MVP)

- **Pre-commit check** (advisory): if an item is set to `InProgress`, require non-empty `owner`.
- **Ready gate check** (advisory): prevent moving Task/Bug to `InProgress` unless required sections are present.
- **Lease warning** (advisory): if `owner` is set to another agent, block or require `--force`.

# Alternatives

- Ad-hoc coordination via chat alone (low auditability, higher conflict risk).

# Acceptance Criteria

- A documented single-repo workflow exists with claim/lease steps.
- Conflict avoidance practices are listed and testable.
- Hook/script suggestions are captured for enforcement.

# Risks / Dependencies

- Human discipline on leases can drift; require automation assists.
- Windows/macOS/Linux differences for file locks.

# Worklog

2026-01-07 20:07 [agent=copilot] Created to define workflows, claims/leases, and conflict avoidance in one repository.
2026-01-08 00:10 [agent=copilot] Documented single-repo claim/lease lifecycle, invariants, and minimal hook suggestions.
2026-01-08 07:24 [agent=copilot] Documented single-repo collaboration workflow with claim/lease lifecycle, conflict avoidance, invariants, and minimal enforcement hooks
