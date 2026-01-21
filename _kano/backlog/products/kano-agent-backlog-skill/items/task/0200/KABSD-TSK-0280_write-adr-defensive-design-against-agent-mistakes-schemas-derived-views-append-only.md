---
area: architecture
created: '2026-01-21'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0280
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P2
state: Proposed
tags:
- adr
- defensive-design
- agent-proof
title: 'Write ADR: Defensive design against agent mistakes (schemas, derived views,
  append-only)'
type: Task
uid: 019bde96-a91c-7684-a361-1220add15449
updated: '2026-01-21'
---

# Context

Agents are powerful but unreliable: they hallucinate, forget context, and can accidentally create inconsistent artifacts. The discussion highlighted that the system works best when it assumes agents will make mistakes and constrains them via structure (Ready gate, append-only Worklog, derived views).

# Goal

Capture and standardize the project's 'agent-proof' design principles as an ADR so future features (Inbox, Health Scan, Constellation) stay consistent.

# Approach

Create an ADR describing: (1) canonical SoT vs derived artifacts; (2) structured schemas for inputs; (3) append-only history for decisions/worklog; (4) prohibition on manual edits to derived data; (5) evidence-based edges/links. Link the ADR from relevant Features.

# Acceptance Criteria

- An ADR exists in the product decisions folder describing defensive design principles.
- The ADR explicitly defines canonical vs derived artifacts and editing rules.
- The ADR lists concrete guardrails applicable to Inbox/Constellation/Health Scan.
- Relevant work items link to the ADR in their body (Links section) or decisions list.

# Risks / Dependencies

Risk: ADR overload. Mitigation: keep ADR short and actionable; avoid repeating existing ADRs; link instead of duplicating.

# Worklog

2026-01-21 11:26 [agent=opencode] Created item