---
id: KCCS-USR-0009
uid: 019b986b-61f8-75ed-811c-d62e4490fd1a
type: Story
title: "Automate version file update and git tagging"
state: Proposed
priority: P2
parent: KCCS-FTR-0004
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
Releasing involves multiple steps: bumping version, updating changelog, committing, and tagging.

# Goal
Create `release.py` to orchestrate the entire release process.

# Approach
- **Workflow**:
    1.  Run `bump_version.py` to determine new version and update `VERSION`.
    2.  Run `generate_changelog.py` to prepend the new changes to `CHANGELOG.md`.
    3.  Git add `VERSION` and `CHANGELOG.md`.
    4.  Git commit -m "chore(release): vX.Y.Z".
    5.  Git tag -a "vX.Y.Z" -m "vX.Y.Z".
- **Safety checks**:
    - Ensure git workspace is clean before starting.
    - Ask for confirmation before pushing (or leave pushing manual).

# Acceptance Criteria
- [ ] `release.py` runs the full chain without error.
- [ ] A new git commit and tag exist at the end.
- [ ] `CHANGELOG.md` reflects the changes in that version.

# Risks / Dependencies
- Integration of previous tools.

2026-01-07 20:25 [agent=antigravity] Created from template.
