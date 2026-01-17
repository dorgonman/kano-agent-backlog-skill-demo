---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0239
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: KABSD-USR-0029
priority: P2
state: InProgress
tags: []
title: Implement token-budget fitting and trimming policy
type: Task
uid: 019bc76b-6c0e-773a-a315-474c87cfac84
updated: '2026-01-17'
---

# Context

Implement token-budget fitting with safety margin and trimming policy per KABSD-TSK-0207.

# Goal

Ensure chunks never exceed model max tokens and trimming is deterministic.

# Approach

- Compute max_tokens minus safety margin.
- Trim tail first for body text; preserve metadata where present.
- Hard cut when necessary.

# Acceptance Criteria

- Budget never exceeded.
- Trimming order is deterministic and documented in code.
- Safety margin applied consistently.

# Risks / Dependencies

Aggressive trimming may drop important context; ensure overlap mitigates.

# Worklog

2026-01-16 23:27 [agent=codex] [model=unknown] Created item
2026-01-16 23:28 [agent=codex] [model=gpt-5.2-codex] Parent updated: null -> KABSD-USR-0029.
2026-01-17 11:14 [agent=codex] [model=unknown] State -> InProgress.
2026-01-17 11:18 [agent=codex] [model=gpt-5.2-codex] Implemented token-budget fitting in kano_backlog_core.token_budget: policy with safety margin, deterministic tail trimming using token spans with binary-search fallback, and result struct; exported via kano_backlog_core.__init__.