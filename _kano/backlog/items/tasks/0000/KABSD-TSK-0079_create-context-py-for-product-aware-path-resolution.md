---
id: KABSD-TSK-0079
uid: 019b93ba-db8a-7965-b77c-a45fac6f7bf7
type: Task
title: Create context.py for product-aware path resolution
state: New
priority: P1
parent: KABSD-FTR-0010
area: architecture
iteration: null
tags:
- architecture
created: 2026-01-06
updated: 2026-01-06
owner: antigravity
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks:
  - KABSD-TSK-0080
  - KABSD-TSK-0082
  blocked_by: []
decisions: []
---

# Context

We need a centralized way to resolve paths in the new monorepo structure, taking into account the current product context and sandbox settings.

# Goal

Implement `skills/kano-agent-backlog-skill/scripts/common/context.py` with helpers for:
- Finding repo root.
- Resolving product name (arg -> env -> defaults -> fallback).
- Getting product root and sandbox root.
- Loading shared defaults.

# Acceptance Criteria

- `context.py` exists and is importable by other scripts.
- Correctly resolves paths for `kano-agent-backlog-skill`.
- Correctly resolves paths for new products.
