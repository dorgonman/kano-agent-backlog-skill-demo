---
id: KCCS-USR-0015
uid: 019b98c3-9e3a-7f1c-8980-f4e03aa3f3f8
type: Story
title: "Interactive Commit Assistant"
state: Proposed
priority: P3
parent: KCCS-FTR-0002
area: general
iteration: null
tags: [dx, cli]
created: 2026-01-08
updated: 2026-01-08
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
Typing compliant KCC messages manually can be tedious. A CLI wizard can help developers pick the right subsystem, type, and ticket, ensuring 100% compliance from the start.

# Goal
Provide an interactive CLI tool `scripts/vcs/commit.py` to guide user through the commit process.

# Approach
- implement a wizard using `input()` or a library (if allowed/present).
- Steps:
  1. Pick Subsystem (list from history/config).
  2. Pick Type (list from config).
  3. Is it Breaking? (Y/N).
  4. Enter Summary.
  5. Enter Ticket ID (suggest (NO-TICKET)).
- Combine into string and execute `git commit -m "..."`.

# Acceptance Criteria
- [ ] Users can run `python scripts/vcs/commit.py` to create a compliant commit without manual typing.
- [ ] Tool suggests subsystems based on existing repo usage.

2026-01-08 13:35 [agent=antigravity] Created for Sprint 6 planning.
