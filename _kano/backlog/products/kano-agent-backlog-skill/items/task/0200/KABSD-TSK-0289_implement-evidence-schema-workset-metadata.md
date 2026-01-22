---
id: KABSD-TSK-0289
uid: 019be474-c6ed-72ae-b0dd-ed3cf80564a1
type: Task
title: "Implement Evidence Schema & Workset Metadata"
state: Ready
priority: P1
parent: KABSD-EPIC-0011
area: general
iteration: backlog
tags: ['evidence', 'schema', 'workset']
created: 2026-01-22
updated: 2026-01-22
owner: None
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

Based on GPT-5.2 feedback (ADR-0037), we need a **Evidence Layer** to ensure agent decisions are based on high-quality, traceable information. Currently, workset materials are just files without structured provenance, making it hard to verify "why" an agent trusted a specific snippet.

# Goal

Make every workset item (file, snippet, log) traceable and verifiable using the **5-axes evidence quality model** (Relevance, Reliability, Sufficiency, Verifiability, Independence).

# Approach

1.  **Define Schema**: Implement `EvidenceRecord` in `kano_backlog_core` (see ADR-0037).
2.  **Update Workset**: Extend `Workset` model to support a list of evidence records.
3.  **CLI Support**: Add `kano-backlog workset add-evidence` command to attach metadata to existing materials.
4.  **Automation**: Auto-capture provenance (git hash, url) when pinning documents or adding snippets.

# Acceptance Criteria

- [ ] `EvidenceRecord` Pydantic model implemented with 5-axes fields
- [ ] Workset metadata (`meta.json`) supports `evidence` list
- [ ] `kano-backlog workset add-evidence` command implemented
- [ ] `kano-backlog workset list` supports `--with-evidence` flag
- [ ] `Workset_Evidence_Index.md` (or JSON equivalent) generated in workset root

# Risks / Dependencies

- **Risk**: Manual entry friction.
  - **Mitigation**: Automate capture. When adding a snippet, auto-fill `file_path`, `line_range`, `commit_hash`.
- **Dependency**: KABSD-FTR-0055 (Evidence Schema definition).

# Worklog

2026-01-22 14:46 [agent=antigravity] Created item
2026-01-22 14:48 [agent=antigravity] Filled in Ready gate fields (Context, Goal, Approach, AC, Risks)
2026-01-22 14:48 [agent=antigravity] Filled in Ready gate requirements (Context, Goal, Approach, AC, Risks)
