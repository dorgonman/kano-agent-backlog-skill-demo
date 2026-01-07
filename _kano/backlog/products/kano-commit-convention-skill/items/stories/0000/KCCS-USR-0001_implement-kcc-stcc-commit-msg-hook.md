---
id: KCCS-USR-0001
uid: 019b9866-a3c9-71d3-b9ac-2bb9a5e21fe0
type: Story
title: "Implement KCC-STCC commit-msg hook"
state: Proposed
priority: P2
parent: KCCS-FTR-0002
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
To ensure consistent commit messages, we need a local Git hook that validates the message before the commit is finalized.

# Goal
Implement a `commit-msg` hook script that uses the regex defined in `Kano-commit-convention.md`.

# Non-Goals
- Remote server-side validation (CI).
- Automatic fixing of invalid messages.

# Approach
- Use a Python script as the hook.
- Read the commit message from the temporary file provided by Git (argument 1).
- Validate the first line (subject) against the KCC-STCC regex:
  `^\[[A-Za-z][A-Za-z0-9]{1,23}\]\[(Feature|BugFix|Refactor|Perf|Chore|Test|Docs)\](\[(Breaking)\])? .+ \(((NO-TICKET)|([A-Z][A-Z0-9]+-\d+))(, [A-Z][A-Z0-9]+-\d+)*\)$`
- If validation fails, print a descriptive error message with examples and exit with non-zero status.

# Acceptance Criteria
- [ ] Hook blocks commits with subjects that don't match KCC-STCC.
- [ ] Hook allows commits with subjects matching KCC-STCC.
- [ ] Error message clearly explains why it failed and shows the expected format.
- [ ] Supports `(NO-TICKET)` and multiple tickets.

# Risks / Dependencies
- Dependency on Python being available in the environment.

2026-01-07 20:20 [agent=antigravity] Created from template.
