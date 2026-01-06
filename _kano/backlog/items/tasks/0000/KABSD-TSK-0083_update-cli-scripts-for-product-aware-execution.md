---
id: KABSD-TSK-0083
uid: 019b93bb-3c9e-7e6d-b5a7-904ee79191f9
type: Task
title: Update CLI scripts for product-aware execution
state: New
priority: P1
parent: KABSD-FTR-0010
area: architecture
iteration: null
tags:
- cli
created: 2026-01-06
updated: 2026-01-06
owner: antigravity
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by:
  - KABSD-TSK-0082
decisions: []
---

# Context

All CLI scripts (e.g., `list_items`, `create_item`) need to accept `--product` and `--sandbox` to operate on the correct data.

# Goal

Update the CLI argument parsers in `scripts/backlog/cli/` to use a shared `context` argument setup.

# Acceptance Criteria

- Scripts accept `--product` and correctly point to the product-specific folders.
- CLI help updated to reflect multi-product support.
