---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KA-TSK-0002
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
- docs
- workflow
- bug-triage
- vcs
title: 'Add guidance: record bug origin via git history'
type: Task
uid: 019bc4cf-a590-771d-af21-970a6a5057ec
updated: '2026-01-16'
---

# Context

Bug triage and fixes often need a clear, auditable answer to: when did the problem start, and which change introduced it? The current skill emphasizes Worklog/Ready discipline but does not explicitly require recording the earliest known bad revision or git evidence.

# Goal

Update the canonical skill docs so that, when fixing a bug, agents record the origin point (first bad revision / last known good) and supporting git evidence (log/blame/bisect) in the item Worklog or attached artifacts.

# Approach

1) Extend SKILL.md guidance under bug triage/worklog updates with a 'Bug Origin Trace' checklist. 2) Recommend a lightweight evidence path: capture commit hashes and short summaries, avoid pasting large diffs. 3) Provide example commands (git log, git blame, optional git bisect) and a suggested Worklog entry template. 4) Keep it non-blocking: if repo has no VCS history available, record what evidence was used instead.

# Acceptance Criteria

- SKILL.md includes an explicit, easy-to-follow rule for recording bug origin (when it started) with git evidence when available. - Guidance specifies what to record (commit hashes, last-good/first-bad, suspect lines) and where (Worklog and/or attach-artifact). - Content is English-only and consistent with existing non-negotiables.

# Risks / Dependencies

Risk: not all environments have full git history (shallow clones, exported zips). Mitigation: document fallback evidence and record limitations explicitly.

# Worklog

2026-01-16 11:18 [agent=copilot] [model=GPT-5.2] Created item