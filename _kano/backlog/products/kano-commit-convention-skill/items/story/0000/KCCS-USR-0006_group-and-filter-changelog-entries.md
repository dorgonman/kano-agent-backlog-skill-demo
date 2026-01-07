---
id: KCCS-USR-0006
uid: 019b9866-bc35-7735-8980-f4e03aa3f3f1
type: Story
title: "Group and filter changelog entries"
state: Proposed
priority: P2
parent: KCCS-FTR-0003
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
In a large monorepo, a global changelog might be too noisy. Teams often only care about changes to their specific subsystem (e.g., `UI` or `Network`).

# Goal
Enhance `generate_changelog.py` to support filtering entries by Subsystem and customizing the grouping logic.

# Approach
- Add CLI arguments:
    - `--subsystem <name>`: Only include commits for this subsystem (can be repeated).
    - `--exclude-subsystem <name>`: Exclude specific subsystems.
    - `--type <name>`: Only include specific types (e.g., only `Feature` and `BugFix`).
- Add grouping options:
    - Default: Group by Type.
    - `--group-by-subsystem`: Top-level headers are Subsystems, then Types.

# Acceptance Criteria
- [ ] `generate_changelog.py --subsystem UI` output only contains UI commits.
- [ ] `generate_changelog.py --type Feature` output only contains features.
- [ ] `--group-by-subsystem` changes the Markdown hierarchy appropriately.

# Risks / Dependencies
- Filtering might result in an empty changelog if no matching commits are found; should warn the user.

2026-01-07 20:20 [agent=antigravity] Created from template.
