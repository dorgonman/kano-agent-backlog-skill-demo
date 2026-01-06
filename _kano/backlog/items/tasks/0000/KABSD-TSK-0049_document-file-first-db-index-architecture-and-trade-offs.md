---
id: KABSD-TSK-0049
uid: 019b8f52-9fb9-7575-bfe5-0afbe14543ad
type: Task
title: Document file-first + DB index architecture and trade-offs
state: Done
priority: P2
parent: KABSD-FTR-0007
area: infra
iteration: null
tags:
- doc
- architecture
created: 2026-01-02
updated: 2026-01-06
owner: antigravity
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

This feature impacts workflow and expectations; we should document the trade-offs clearly.

# Goal

Document the architecture choices and when to use file-only vs file+DB index vs DB-first.

# Non-Goals

# Approach

- Write an ADR and/or references doc describing the layers: files (SoT) -> DB index -> embeddings.
- Document view implications and recommended patterns.
- Add short guidance to README/REFERENCE if needed.

# Alternatives

# Acceptance Criteria

- Documentation exists and is linked from the feature item.
- Clear statement: default remains file-first; DB is optional and rebuildable.

# Risks / Dependencies

# Worklog

2026-01-05 08:31 [agent=codex] Created from template.
2026-01-06 08:19 [agent=antigravity] Starting ADR-0004 documentation.
2026-01-06 08:36 [agent=antigravity] Created ADR-0004: File-First Architecture with SQLite Index.
