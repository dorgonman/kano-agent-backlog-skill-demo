---
id: KABSD-FTR-0015
uid: 019b96cb-fd5e-7656-9103-e2948c9212bb
type: Feature
title: "Execution Layer: Workset Cache + Promote"
state: Planned
priority: P2
parent: KABSD-EPIC-0006
area: general
iteration: null
tags: ["roadmap", "execution", "workset"]
created: 2026-01-07
updated: 2026-01-10
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: [KABSD-FTR-0013]
decisions: [ADR-0011, ADR-0012]
original_type: Feature
---

# Context

**Architecture**: See [ADR-0011](../../decisions/ADR-0011_workset-graphrag-context-graph-separation-of-responsibilities.md) for the complete specification of Workset responsibilities and how it relates to GraphRAG/Context Graph. See [ADR-0012](../../decisions/ADR-0012_workset-db-canonical-schema-reuse.md) for schema requirements.

Workset provides per-agent/per-task execution memory and cache. Key properties:
- Materialized cache bundle (SQLite + optional filesystem)
- Derived and rebuildable from canonical files + repo-level index
- Ephemeral (TTL-based cleanup)
- Local (not source of truth; promotes back to canonical on important updates)

# Goal

- Provide agents with a lightweight, per-task execution memory system (Workset)
- Support three-file pattern: `plan.md` (checklist plan), `notes.md` (research/findings), `deliverable.md` (output draft)
- Enable seamless "promotion" (escalation) of important context back to canonical items (Worklog, ADRs, or work item body)
- Prevent long-session agent drift while maintaining local-first principles

# Non-Goals

- Worksets are not a permanent storage mechanism; they must be ephemeral and discardable
- Worksets are not a replacement for canonical backlog items; they supplement execution, not replace documentation
- Do not implement cloud sync for worksets; focus on local-first in this iteration
- Do not create a separate workset schema; reuse canonical schema (per ADR-0012)

# Approach

1. **Workset Directory Layout**:
   - Store worksets under `_kano/backlog/.cache/worksets/<item-id>/`
   - Three files: `plan.md` (execution checklist), `notes.md` (research notes), `deliverable.md` (output draft)
   - Add `_kano/backlog/.cache/` to `.gitignore` (not tracked in Git)

2. **Three-File Pattern**:
   - **plan.md**: Checkbox-based execution plan with phases and current status
   - **notes.md**: Freeform research findings, decisions, and discoveries
   - **deliverable.md**: Draft final output (to be promoted to work item body or PR description)

3. **Core Operations**:
   - `workset_init.py --item <ID>`: Create workset directory and populate templates
   - `workset_refresh.py --item <ID>`: Regenerate plan snapshot from canonical work item
   - `workset_promote.py --item <ID> --section <section>`: Promote content from workset back to canonical (ADR, worklog, work item body)

4. **TTL and Cleanup**:
   - Mark worksets with creation timestamp
   - Implement lazy cleanup: `workset_cleanup.py --max-age-days 7` removes worksets older than TTL
   - Optional scheduled cleanup (cron, GitHub Actions, or manual)

5. **Promote Triggers**:
   - Decision → create ADR stub, link to work item via `decisions` field
   - Status update → call `workitem_update_state.py` to sync state + append worklog
   - Completion → copy `deliverable.md` content to work item body or designated output location

# Alternatives

- **Keep everything in canonical work items**: No separation between execution and documentation; messy worklogs, hard to read
- **Use external note-taking tools**: Violates local-first principle; context scattered across multiple systems
- **Full bidirectional sync (workset ↔ canonical)**: Over-engineered; violates source-of-truth invariant; introduces sync lag and conflicts
- **Workset as the source of truth**: Breaks local-first; canonical files become stale; merge conflicts on multi-agent scenarios

# Acceptance Criteria

- [x] **Workset directory structure created and documented**
  - Verified: `_kano/backlog/.cache/worksets/<item-id>/` layout confirmed; templates provided in Workset_Status_and_Integration_Guide.md
  - Verified: `.gitignore` updated to exclude `_kano/backlog/.cache/**`

- [ ] **`workset_init.py` script implemented**
  - Creates workset directory for a given item ID
  - Populates `plan.md`, `notes.md`, `deliverable.md` with templates
  - Respects `.gitignore` and verifies cache directory is not tracked

- [ ] **`workset_refresh.py` script implemented**
  - Reads canonical work item (Context, Goal, Approach)
  - Regenerates `plan.md` with fresh checkpoint/phases from current work item state
  - Preserves existing `notes.md` and `deliverable.md` (non-destructive)

- [ ] **`workset_promote.py` script implemented**
  - Promotes decision from `notes.md` → create ADR stub or update existing ADR
  - Promotes status → call `workitem_update_state.py` with appropriate state + append worklog entry
  - Promotes deliverable → copy `deliverable.md` content to work item body or artifact location
  - Verification: All promote operations logged in audit trail

- [ ] **Demo / manual testing**
  - Create a sample workset for KABSD-TSK-0104 or similar
  - Demonstrate init → edit → refresh → promote cycle
  - Verify `.cache/` remains untracked and content is properly promoted

- [ ] **Documentation**
  - User guide: how to init, work with, and promote worksets
  - Examples: before/after for each promote operation
  - Troubleshooting: common issues (cache stale, promote conflicts, TTL cleanup)

# Risks / Dependencies

- **Risk: Promote conflicts**: If agent promotes while canonical item is being edited elsewhere, conflict may occur. **Mitigation**: Use owner locking (per conflict guard protocol); prompt user if canonical state changed since workset init.
- **Risk: Workset becomes truth**: Agents may forget to promote important context. **Mitigation**: Clear documentation, enforce promote rules via pre-commit hooks or script validation.
- **Risk: TTL cleanup too aggressive**: Accidentally delete working progress. **Mitigation**: Conservative TTL default (e.g., 7-14 days); warn before cleanup; allow restore from git reflog if needed.
- **Dependency**: Must complete KABSD-FTR-0013 (derived index + SQLite) first; workset schema reuses canonical schema (ADR-0012)
- **Dependency**: Conflict Guard (owner locking) must be implemented (KABSD-TSK-0036 or equivalent)

# Worklog

2026-01-07 12:51 [agent=copilot] Seed minimal landing: workset init/refresh/promote; next defaults to plan checklist; gitignore _kano/.cache/**; cache discardable, canonical promotion required.
2026-01-07 13:02 [agent=copilot] Attach demo artifact for testing auto-refresh
- Artifact: [artifact_test.txt](../../../../../artifacts/KABSD-FTR-0015/artifact_test.txt)
2026-01-07 13:04 [agent=copilot] Workset initialized: _kano/backlog/sandboxes/.cache/019b96cb-fd5e-7656-9103-e2948c9212bb
2026-01-10 14:45 [agent=copilot] Completed Ready gate: fully specified Goal/Non-Goals/Approach/Alternatives; detailed 8 acceptance criteria with init/refresh/promote scripts; clarified risks/dependencies/promote conflicts. State moved to Planned.
2026-01-10 16:28 [agent=copilot] Recorded explicit `blocked_by` dependency on KABSD-FTR-0013 (infrastructure must ship first).
