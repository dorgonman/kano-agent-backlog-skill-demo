---
area: workflow
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0275
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0052
priority: P1
state: Proposed
tags:
- inbox
- cli
title: 'Implement inbox commands: add, list, triage (human-in-the-loop)'
type: Task
uid: 019bde95-4e58-7293-aad9-6c2b2e097523
updated: '2026-01-21'
---

# Context

After selecting an inbox storage layout, we need ergonomic commands so humans/agents can capture fragments and later triage them into canonical outputs.

# Goal

Provide CLI commands to add inbox entries, list/show them, and triage them into work item drafts or brainstorm entries, without automatic promotion.

# Approach

Add a new command group (name TBD) that wraps the chosen storage layout. The add command accepts text from stdin/file/clipboard; the list/show commands display recent entries; the triage command generates a deterministic draft and requires explicit confirmation before creating/updating a work item. Record agent identity for audit when applicable.

# Acceptance Criteria

- The add command can ingest transcript text and write an inbox entry with metadata.
- The list/show commands can display stored entries.
- The triage command can output a draft work item payload or brainstorm payload without committing it automatically.
- When promotion occurs, it uses existing item create / item set-ready commands so audit trails remain consistent.

# Risks / Dependencies

Risk: UX becomes too complex. Mitigation: keep CLI surface minimal and composable.

# Worklog

2026-01-21 11:24 [agent=opencode] Created item