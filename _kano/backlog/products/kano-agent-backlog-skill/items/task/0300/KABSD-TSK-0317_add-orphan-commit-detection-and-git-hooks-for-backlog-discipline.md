---
area: backlog
created: '2026-01-27'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0317
iteration: 0.0.2
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0061
priority: P2
state: Done
tags: []
title: Add orphan commit detection and git hooks for backlog discipline
type: Task
uid: 019bff8b-27c6-778d-ba4d-3f0a9709afba
updated: '2026-01-27'
---

# Context

Developers often commit code without creating backlog items first ('先上車後補票'). Need gentle reminders to maintain backlog discipline without blocking workflow.

# Goal

Implement soft git hooks and CLI commands to detect orphan commits and suggest creating backlog items, with easy opt-out.

# Approach

1) Create .githooks/commit-msg and post-commit hooks with gentle reminders. 2) Add kano-backlog orphan check/suggest CLI commands. 3) Auto-exempt trivial commits (WIP, docs, chore, style). 4) Allow disable via git config.

# Acceptance Criteria

1) Git hooks installed in .githooks/ with README. 2) Hooks use 💡 Reminder tone, not warnings. 3) CLI commands: orphan check --days N, orphan suggest COMMIT. 4) Config option: git config kano.backlog.reminders false. 5) Hooks always exit 0 (never block commits).

# Risks / Dependencies

Users may find reminders annoying. Mitigation: soft tone, easy disable, auto-exempt trivial commits.

# Worklog

2026-01-27 21:01 [agent=opencode] Created item [Parent Ready gate validated]
2026-01-27 21:01 [agent=opencode] State -> Done.
2026-01-27 21:01 [agent=opencode] [model=unknown] Implementation complete. Created .githooks/commit-msg and post-commit with soft reminders (💡 tone). Added CLI commands: kano-backlog orphan check/suggest. Auto-exempts WIP/docs/chore/style commits. Easy disable via git config kano.backlog.reminders false. Hooks always exit 0. Commits: 2430a1e, b68c065, ed82b80.