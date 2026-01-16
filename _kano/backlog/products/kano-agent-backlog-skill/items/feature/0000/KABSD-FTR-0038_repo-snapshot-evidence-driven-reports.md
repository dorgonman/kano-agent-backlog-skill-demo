---
area: general
created: 2026-01-13 08:50:00
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0038
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: Antigravity
parent: null
priority: High
product: kano-agent-backlog-skill
state: Done
tags: []
title: Repo Snapshot + Evidence-driven Reports
type: Feature
uid: 019bbc2e-a8bf-7807-8e57-5907f03272cf
updated: 2026-01-13 18:00:00
---

# Feature: Repo Snapshot + Evidence-driven Reports

## Context
Code rot and hallucination are major issues in long-running projects. LLMs often "hallucinate" features that don't exist, and humans lose track of what's actually implemented vs. what's just planned.

## Goal
Implement a deterministic "Repo Snapshot" mechanism that produces an "evidence pack" (JSON) characterizing the actual state of the repo (CLI surface, stubs, capability implementation), which is then used to generate truthful, evidence-based reports.

## Approach
1.  **Snapshot Evidence Pack Generator**: A tool to scan the repo and produce a JSON dump of:
    *   **CLI Tree**: Derived from `--help` (truth about exposed surface).
    *   **Stubs**: Derived from `NotImplementedError`, `TODO`, `FIXME` scan.
    *   **Capabilities**: Derived from mapping features to files/evidence.
    *   **Health**: Derived from `doctor` checks.
2.  **Report Templates**: Markdown templates that require evidence citations for every claim.
3.  **Generator Command**: `kano snapshot <view> --scope <scope>`.

## Worklog
2026-01-13: Created feature item.
2026-01-13: [Antigravity] Implemented Feature.
- **Evidence Pack Generator**: Created `snapshot.py` and `kano snapshot create` command. Captures stubs, CLI tree, and maps feature capabilities to evidence.
- **Templates**: Created Developer, PM, and QA report templates in `templates/` directory.
- **Report Generator**: Implemented `kano snapshot report` command with a native zero-dependency template engine.
- **Verification**: Verified end-to-end flow with product scope.

# Worklog

2026-01-16 13:58 [agent=q-developer] [model=nova-pro] Auto-fixed missing fields: parent, tags, area, iteration, external, links, decisions
