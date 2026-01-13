---
area: snapshot
created: '2026-01-14'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0200
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0039
priority: P2
state: Proposed
tags:
- snapshot
- reproducible
- metadata
title: 'Evaluate snapshot artifacts: folder-based packs, VCS metadata, no timestamps'
type: Task
uid: 019bb880-6ead-74d8-a199-d0e343067c5d
updated: '2026-01-14'
---

# Context

Snapshot outputs under views/snapshots currently include timestamps in filenames (and sometimes inside content), which creates diff noise and prevents reproducible outputs for the same repo state. KABSD-FTR-0039 proposes a VCS-agnostic metadata mechanism and forbids timestamps for reproducible docs.

# Goal

Evaluate and propose a new snapshot storage layout that avoids timestamped filenames by default, stores a snapshot as a folder (pack) containing related artifacts, and records VCS-agnostic build metadata (no runtime timestamps) so reruns on the same revision are stable.

# Approach

1) Inventory current snapshot outputs and where they are written (paths, filenames, formats). 2) Propose a folder-based naming scheme (stable ID or revision-based) and an internal manifest file that links all artifacts. 3) Apply the KABSD-FTR-0039 metadata block spec to snapshot artifacts (or a pack-level manifest). 4) Define retention/cleanup rules (what gets overwritten vs archived). 5) Identify required CLI changes and backward compatibility plan.

# Acceptance Criteria

- Clear proposed directory layout for snapshot packs (root, naming, per-artifact filenames). - Decision on stable identifiers (e.g., vcs.revision + scope) and how to handle dirty/unknown VCS. - Proposed manifest schema and where metadata lives. - Migration/backward-compat plan for existing timestamped snapshot files. - Recommendation for default behavior vs optional archive mode. - Follow-up implementation tasks identified.

# Risks / Dependencies

Risk: Without timestamps, multiple snapshot runs can collide; mitigation: use a deterministic key including scope + revision + dirty flag, and provide an explicit --archive mode when users want history. Risk: VCS may be unavailable; mitigation: allow provider=unknown and choose a stable fallback key.

# Worklog

2026-01-14 01:56 [agent=copilot] Created item