---
id: KCCS-USR-0008
uid: 019b986b-5cee-7f89-b862-e3f1d4027c8c
type: Story
title: "Implement bump_version.py for semantic versioning"
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
Semantic Versioning (SemVer) allows us to communicate the impact of changes to consumers. Doing this manually is prone to mistakes (e.g., missing a breaking change).

# Goal
Create `bump_version.py` to automatically calculate the next version number based on KCC history.

# Approach
- **Base Version**: Read from a file named `VERSION` (plain text) or the latest git tag.
- **Scope**: Analyze commits from `HEAD` back to the last version tag.
- **Logic**:
    - **Major**: If *any* commit contains `[Breaking]` or `BREAKING CHANGE` footer.
    - **Minor**: If *any* commit is `[Feature]`.
    - **Patch**: All other cases (`BugFix`, `Refactor`, `Perf`).
- **Action**: Overwrite `VERSION` file with the new number.
- **CLI**:
    - `--dry-run`: Print next version but don't write file.
    - `--force-major/minor/patch`: Override logic.

# Acceptance Criteria
- [ ] `bump_version.py` correctly identifying breaking changes bumps Major.
- [ ] Features bump Minor.
- [ ] BugFixes bumps Patch.
- [ ] `VERSION` file is updated.

# Risks / Dependencies
- Requires a strict adherence to KCC. If someone forgets `[Breaking]`, SemVer breaks.

2026-01-07 20:25 [agent=antigravity] Created from template.
