---
id: KABSD-TSK-0103
uid: 019b947e-ddb3-7799-b7d7-8c5896099d5c
type: Task
title: "Add dependency management CLI for linking work items"
state: Proposed
priority: P2
parent: KABSD-FTR-0001
area: general
iteration: null
tags: []
created: 2026-01-07
updated: 2026-01-07
owner: null
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

Manually editing frontmatter to add `blocks` or `blocked_by` links is error-prone and tedious. A dedicated CLI tool is needed to manage these relationships efficiently and ensure consistency.

# Goal

Create a new script (e.g., `scripts/backlog/workitem_link.py`) to manage relationships between backlog items.

# Non-Goals

# Approach

1.  Implement a CLI that accepts `--from ID`, `--to ID`, and `--relation [blocks|blocked_by|relates]`.
2.  The tool should update the YAML frontmatter of both items if necessary (e.g., `blocks` implies `blocked_by`).
3.  Include validation:
    *   Verify both items exist.
    *   Prevent circular dependencies.
    *   Prevent self-linking.

# Alternatives

# Acceptance Criteria

- [ ] CLI tool can create `blocks` relationship between two items.
- [ ] CLI tool can remove a relationship.
- [ ] CLI tool prevents circular dependencies (e.g., A blocks B, B blocks A).
- [ ] CLI tool supports the monorepo structure and `--product` argument.

# Risks / Dependencies

- Potential for frontmatter corruption; must use safe YAML parsing/writing.

# Worklog

2026-01-07 02:21 [agent=antigravity] Created from template.
2026-01-07 02:26 [agent=antigravity] Filled in goal and approach.
