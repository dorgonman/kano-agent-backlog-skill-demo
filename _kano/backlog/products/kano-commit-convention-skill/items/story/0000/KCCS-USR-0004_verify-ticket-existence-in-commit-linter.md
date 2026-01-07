---
id: KCCS-USR-0004
uid: 019b9866-b239-76ca-85e5-923483da19fe
type: Story
title: "Verify ticket existence in commit linter"
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
Currently, the Linter only checks if the ticket ID looks like a valid ID (regex `[A-Z]+-\d+`). It doesn't check if the ticket actually exists. This leads to commits with typo'd IDs (e.g., `KCCS-TAS-123` instead of `KCCS-TSK-123`) that become dead links in the changelog.

# Goal
Enhance the commit-msg hook to verify that the referenced User Story, Task, or Bug actually exists in the local backlog (`_kano/backlog`).

# Non-Goals
- Check status of the ticket (e.g., allow closed tickets for now).
- Remote validation (Jira/Azure DevOps API integration).

# Approach
1.  **Parse IDs**: Extract all ticket IDs from the commit subject. 
    - If `(NO-TICKET)` is used, skip verification.
2.  **Backlog Lookup**:
    - The hook should assume the root of the repo contains `_kano/backlog`.
    - It should search for a file containing `id: <TICKET_ID>` within the `_kano/backlog/products` directories.
    - *Optimization*: Can use `grep` or `find` on the `items` directories.
3.  **Error Handling**:
    - If ID is not found, print: `Error: Ticket <ID> not found in local backlog.`
    - Suggest `(NO-TICKET)` if appropriate.
4.  **Bypass**:
    - Allow an environment variable `KCC_SKIP_TICKET_CHECK=1` to bypass this check in emergencies.

# Acceptance Criteria
- [ ] Commit with `(KCCS-TSK-EXISTING)` succeeds.
- [ ] Commit with `(KCCS-TSK-NONEXISTENT)` fails with descriptive error.
- [ ] Commit with `(NO-TICKET)` succeeds.
- [ ] `KCC_SKIP_TICKET_CHECK=1` allows invalid ticket ID.
- [ ] Works efficiently (sub-second) for typical backlog sizes (< 1000 items).

# Risks / Dependencies
- Relies on the user having an up-to-date local backlog (might need `git pull` before commit if the ticket was just created by someone else).

2026-01-07 20:20 [agent=antigravity] Created from template.
