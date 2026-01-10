---
id: KABSD-TSK-0151
uid: 019ba6e7-ad7f-7c21-93c5-1f56c12065f2
type: Task
title: "Accept ADR-0011 and ADR-0012 for Workset Architecture"
state: Done
priority: P1
parent: KABSD-FTR-0013
area: general
iteration: null
tags: ["workset", "adr", "architecture"]
created: 2026-01-10
updated: 2026-01-10
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: ["ADR-0011", "ADR-0012"]
---

# Context

ADR-0011 (Workset vs GraphRAG separation) and ADR-0012 (Workset DB canonical schema reuse) were still marked as Proposed.
They are load-bearing for the Workset roadmap:

- Workset is an ephemeral per-agent/per-item cache (derived)
- GraphRAG is a repo-level shared derived index
- Schema reuse prevents divergence across SQLite instances

We should explicitly accept these ADRs so downstream implementation work has a stable reference.

# Goal

1. Confirm ADR-0011 and ADR-0012 are accepted decisions.
2. Update ADR status from Proposed → Accepted.
3. Ensure relevant features reference these ADRs via `decisions:` links.

# Non-Goals

- Do not implement Workset scripts (tracked under FTR-0013 / FTR-0015).
- Do not change the content beyond finalizing acceptance status/metadata.

# Approach

1. Review ADR-0011 and ADR-0012.
2. Capture remaining open questions as follow-up items (do not block acceptance unless necessary).
3. Update ADR frontmatter (e.g., `status: Accepted` and a decision date).
4. Ensure `KABSD-FTR-0013` and `KABSD-FTR-0015` reference the ADRs in `decisions:`.
5. Append Worklog lines describing what was accepted.

# Alternatives

1. Keep them Proposed longer: increases ambiguity and re-litigation.
2. Split into separate ADRs: adds overhead without improving clarity for this scope.

# Acceptance Criteria

- [x] ADR-0011 `status` = "Accepted" and has a decision date
- [x] ADR-0012 `status` = "Accepted" and has a decision date
- [x] `KABSD-FTR-0013.decisions` includes `["ADR-0011", "ADR-0012"]`
- [x] `KABSD-FTR-0015.decisions` includes `["ADR-0011", "ADR-0012"]`
- [x] Worklog updated

# Risks / Dependencies

1. **Risk**: accepted ADRs may still contain open questions.
   - Mitigation: keep open questions as explicit follow-up work items.
2. **Dependency**: directory layout decision (TSK-0152) should align with ADR content.

# Worklog

2026-01-10 15:55 [agent=copilot] Created from template.
2026-01-10 15:58 [agent=copilot] Populated Ready gate content based on Workset review findings.
2026-01-10 16:25 [agent=copilot] Accepted ADR-0011 + ADR-0012 (status + decision_date) and confirmed feature decisions already reference them. Task complete.
