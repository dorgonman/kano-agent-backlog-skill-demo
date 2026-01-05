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
updated: 2026-01-04
owner:
external:
  azure_id:
  jira_key:
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: [ADR-0002, ADR-0003]
---

# Context

Codex needs a consistent, local-first way to plan work and preserve project
evolution beyond git log.

# Goal

Provide a file-based backlog system with clear hierarchy, Ready gate, and demo views.

# Non-Goals

- External sync with Azure Boards/Jira.
- UI beyond Obsidian Dataview.

# Approach

Create backlog structure, views, and the kano-agent-backlog-skill demo.

# Links


- ADR: [[_kano/backlog/decisions/ADR-0002_decisions-as-adr-links|ADR-0002 Decision handling: ADRs stay in decisions/ with item links]]
- ADR: [[_kano/backlog/decisions/ADR-0003_identifier-strategy-for-local-first-backlog|ADR-0003 Identifier strategy: sortable IDs without centralized allocation]]
- Epic: [[KABSD-EPIC-0001_kano-agent-backlog-skill-demo|KABSD-EPIC-0001 Kano Agent Backlog Skill Demo]]
- UserStory: [[KABSD-USR-0001_plan-before-code|KABSD-USR-0001 Plan work before coding]]
- Task: [[KABSD-TSK-0059_ulid-vs-uuidv7-comparison|KABSD-TSK-0059 ULID vs UUIDv7 comparison]]
- Task: [[KABSD-TSK-0060_migration-plan-add-uid-to-existing-items|KABSD-TSK-0060 Migration plan: add uid to existing items]]
- Task: [[KABSD-TSK-0061_id-resolver-spec-and-design|KABSD-TSK-0061 ID resolver spec and design]]
- Task: [[KABSD-TSK-0062_collision-report-and-resolver-cli|KABSD-TSK-0062 Collision report and resolver CLI]]

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
2026-01-04 00:43 [agent=codex] Rebuilt feature text to align with the kano-agent-backlog-skill demo scope.

2026-01-05 01:12 [agent=codex] Linked ADR-0002 for decision handling approach.

2026-01-05 13:55 [agent=codex] Linked ADR-0003 to capture ID/uid strategy trade-offs for local-first collaboration.

2026-01-06 00:36 [agent=antigravity] Added TSK-0059/0060/0061/0062 for ADR-0003 follow-ups: ULID vs UUIDv7 comparison, migration plan (frontmatter uid only), ID resolver spec, collision report CLI.
