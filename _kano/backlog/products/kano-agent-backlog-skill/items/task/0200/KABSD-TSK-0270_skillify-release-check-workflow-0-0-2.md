---
area: general
created: '2026-01-20'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0270
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: InProgress
tags: []
title: Skillify release check workflow (0.0.2)
type: Task
uid: 019bda9d-8d14-70f9-a09d-8f15fc8493ef
updated: 2026-01-20
---

# Context

We need a deterministic release verification workflow for kano-agent-backlog-skill-demo and kano-agent-backlog-skill version 0.0.2, and we want to skillify it so agents can run it consistently.

# Goal

Provide a two-phase release check: (1) static audit (docs/version/implementation mapping) then (2) executable gate (doctor, pytest, CLI smoke). Record outputs under a topic for auditability.

# Approach

1) Create a topic release-0-0-2 to store reports and artifacts. 2) Implement a CLI command (or script) that runs Phase 1 then Phase 2 and writes deterministic markdown reports to topic publish/. 3) Add documentation describing the workflow and the expected artifacts.

# Acceptance Criteria

- A single command produces a Phase 1 report and Phase 2 report under _kano/backlog/topics/release-0-0-2/publish/. - Phase 1 checks version consistency and maps 0.0.2 changelog bullets to code/CLI entrypoints. - Phase 2 runs doctor, pytest, and a sandboxed CLI smoke workflow without modifying the main backlog. - The command exits non-zero when checks fail, and reports list failures clearly.

# Risks / Dependencies

- Commands that write to the main backlog could create noise; mitigate by using sandbox for smoke tests. - Version sources may drift again; mitigate by defining a single source of truth and validating it.

# Worklog

2026-01-20 16:55 [agent=opencode] Created item
2026-01-20 16:55 [agent=opencode] Start work: implement release check workflow (Phase 1 static audit then Phase 2 executable gate) and record artifacts in topic release-0-0-2.
2026-01-20 17:16 [agent=opencode] Implemented admin release check workflow; generated phase1/phase2 reports under topic release-0-0-2 publish/ (includes doctor+pytest+topic smoke + artifacts).
