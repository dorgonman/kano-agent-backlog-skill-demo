---
id: KABSD-TSK-0155
uid: 019ba90a-5c3d-7ad6-96f2-1c4bf2c6b8d4
type: Task
title: "Implement workset init/refresh/promote automation"
state: Proposed
priority: P1
parent: KABSD-FTR-0015
area: general
iteration: null
tags: ["workset", "cli"]
created: 2026-01-10
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
---

# Context

- Workset flow (ADR-0011/ADR-0012) requires concrete scripts so agents can open a cache, refresh plan checkpoints, and promote deliverables back to canonical files.
- Current `workset_init.py`, `workset_refresh.py`, `workset_promote.py`, and `workset_next.py` are placeholders: they write static templates, never read canonical sections, do not guard custom checklists, and ignore decision markers or state sync.
- Feature [KABSD-FTR-0015](../../feature/0000/KABSD-FTR-0015_execution-layer-workset-cache-promote.md) lists these scripts as acceptance criteria, so we need an implementation that actually uses the canonical SQLite index (KABSD-FTR-0013) and enforces TTL/worklog discipline.

# Goal

Ship workset automation that agents can rely on daily:
1. Auto-generate `plan.md` from canonical Context/Goal/Approach/Acceptance sections and preserve a custom checklist block.
2. Keep `meta.json` fresh with TTL + refresh timestamps and seed `notes.md` with Decision markers guidance.
3. `workset_next.py` lists only unchecked checklist items (auto + custom).
4. `workset_promote.py` promotes deliverables as artifacts, can optionally update item state, and escalates Decision markers through ADR creation (or dry-run preview).

# Non-Goals

- Conflict Guard/claim enforcement (handled by separate work).
- Implementing workset materialization DBs (covered by later tasks in FTR-0015).
- Automating ADR linkage back into frontmatter (manual until ADR tooling lands).

# Approach

1. Add a shared helper (`lib/workset.py`) to parse Markdown sections, render plan files with auto/custom blocks, and detect `Decision:` markers.
2. Update `workset_init.py` to resolve items through the canonical SQLite index, seed cache directories, write `meta.json`, and render the initial plan + notes templates.
3. Update `workset_refresh.py` to reuse the helper so it re-renders plan content while keeping the custom checklist, extend TTL, and log refresh work.
4. Enhance `workset_promote.py` to:
   - Attach every file in `deliverables/` (with dry-run preview).
   - Optionally call `workitem_update_state.py --state <STATE>`.
   - Detect Decision markers and invoke `adr_init.py` (or print preview in dry-run).
   - Summarize all actions in a single worklog entry.
5. Teach `workset_next.py` to read checkbox syntax (`- [ ] task`) so it shows actionable checklist items only.
6. Refresh docs (docs/workset.md + Workset guide) with the new behavior and run CLI smoke tests.

# Alternatives

1. **Keep static templates** – fails acceptance criteria and offers no guardrails; rejected.
2. **Implement a separate YAML descriptor for plan content** – duplicates canonical data; defeats local-first principle.
3. **Drive everything via Obsidian plugins** – adds external dependency and breaks CLI-only agents.

# Acceptance Criteria

- [ ] lib/workset.py exposes helpers for plan rendering, checklist preservation, and decision extraction; reused by init/refresh/promote/adr_init.
- [ ] `workset_init.py` creates/updates plan/notes/meta files with canonical data, TTL metadata, and custom checklist markers.
- [ ] `workset_refresh.py` re-renders plan content (auto block) while preserving the custom block and extends claim TTL.
- [ ] `workset_next.py` outputs unchecked checklist items (auto + custom) using checkbox syntax detection.
- [ ] `workset_promote.py` supports dry-run, attaches deliverables, optionally updates item state, runs ADR creation when Decision markers exist, and logs a summary.
- [ ] Documentation describes the flow end-to-end, including the new `--state` flag and Decision detection.
- [ ] CLI smoke tests show init → refresh → next → promote (--dry-run) without errors.

# Risks / Dependencies

1. **Dependency**: canonical SQLite index (`index_db.py`) must be available; fallback file scan should remain as safety net.
2. **Risk**: Overwriting agent-authored plan details – mitigated by isolating the custom checklist block.
3. **Risk**: ADR auto-generation may produce noisy drafts – mitigated by dry-run support and clear logging so humans can review.
4. **Dependency**: `workitem_update_state.py` must exist to handle optional state promotions.

# Worklog

2026-01-10 20:35 [agent=copilot] Drafted task with scope/approach/AC for workset init/refresh/promote automation.
