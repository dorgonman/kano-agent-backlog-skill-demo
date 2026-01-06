---
id: KABSD-EPIC-0002
type: Epic
title: "Milestone 0.0.1 (Core demo)"
state: InProgress
priority: P1
parent: null
area: release
iteration: null
tags: ["milestone", "release", "0.0.1"]
created: 2026-01-06
updated: 2026-01-06
owner: codex-cli
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

This milestone ships the minimum end-to-end demo of `kano-agent-backlog-skill`:
- local-first backlog items as the source of truth
- agent-enforced workflow (Ready gate + Worklog discipline)
- dashboard views that stay up-to-date
- audit logging for tool invocations

# Goal

Deliver a usable demo that can be opened in Obsidian and used by multiple agents without losing decisions.

# Non-Goals

- DB-first backlog storage
- Embeddings/RAG pipeline

# Approach

- Group core Features under this milestone Epic.
- Keep the system file-first; any index is optional and derived.

# Alternatives

# Acceptance Criteria

- A new repo user can follow the skill workflow and see dashboards update via scripts.
- Backlog items capture decisions and trade-offs (Worklog + ADR links).
- Audit log captures tool invocations (with redaction + rotation).

# Risks / Dependencies

- Obsidian view syntax drift across versions.
- Windows file locking can interfere with deletes; scripts must fail clearly.

# Links

- Feature: [[KABSD-FTR-0001_local-backlog-system|KABSD-FTR-0001 Local-first backlog system]]
- Feature: [[KABSD-FTR-0002_agent-tool-invocation-audit-logging-system|KABSD-FTR-0002 Agent tool invocation audit logging system]]
- Feature: [[KABSD-FTR-0003_self-contained-skill-bootstrap-and-automation|KABSD-FTR-0003 Self-contained skill bootstrap and automation]]
- Feature: [[KABSD-FTR-0004_backlog-config-system-and-process-profiles|KABSD-FTR-0004 Backlog config system and process profiles]]
- Feature: [[KABSD-FTR-0005_verify-agent-compliance|KABSD-FTR-0005 Verify agent compliance]]
- Feature: [[KABSD-FTR-0006_conflict-prevention-mechanism|KABSD-FTR-0006 Conflict Prevention Mechanism]]

# Worklog

2026-01-06 08:26 [agent=codex-cli] Created milestone epic for v0.0.1.
2026-01-06 08:34 [agent=codex-cli] Populated milestone scope and linked the core Features.
2026-01-06 08:33 [agent=codex-cli] State -> InProgress. Milestone 0.0.1 is the active scope for core demo work.
