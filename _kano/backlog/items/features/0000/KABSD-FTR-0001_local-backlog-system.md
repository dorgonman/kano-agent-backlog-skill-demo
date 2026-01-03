---
id: KABSD-FTR-0001
type: Feature
title: Local-first backlog system
state: Proposed
priority: P1
parent: KABSD-EPIC-0001
area: infra
iteration:
tags:
  - backlog
created: 2026-01-02
updated: 2026-01-02
owner:
external:
  azure_id:
  jira_key:
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
---

# Context

Codex needs a consistent, local-first way to plan work and preserve project
evolution beyond git log.

# Goal

Provide a file-based backlog system with clear hierarchy, Ready gate, and views.

# Non-Goals

- External sync with Azure Boards/Jira.
- UI beyond Obsidian Dataview.

# Approach

Create backlog structure, views, and a project-backlog skill.

# Links

- Epic: [[KABSD-EPIC-0001_quboto-mvp 1|KABSD-EPIC-0001 Quboto_MVP]]
- UserStory: [[KABSD-USR-0001_plan-before-code|KABSD-USR-0001 Plan work before coding]]

# Alternatives

- Store planning only in AGENTS.md.

# Acceptance Criteria

- Backlog directory exists and is structured by item type.
- Skill and references exist for the workflow.
- Views are available for quick status checks.

# Risks / Dependencies

- Manual enforcement of Ready gate until automation exists.

# Worklog

2026-01-02 10:12 [agent=codex] Created feature under KABSD-EPIC-0001.
2026-01-02 11:22 [agent=codex] Added per-type item folders, per-item MOC index files, and an index registry in _kano/backlog/_meta/indexes.md (ADR-0001).
2026-01-02 11:24 [agent=codex] Switched index rendering to Obsidian-friendly links with Dataview (non-JS) fallback after DataviewJS issues.
2026-01-02 11:27 [agent=codex] Agreed Worklog must capture key discussion decisions and the agent must report which items were updated.
2026-01-03 01:16 [agent=codex] Reduced index files to Epic-only to avoid MOC file sprawl.
2026-01-03 01:35 [agent=codex] Adopted view-level archiving by hiding Done/Dropped items in dashboard and views.

