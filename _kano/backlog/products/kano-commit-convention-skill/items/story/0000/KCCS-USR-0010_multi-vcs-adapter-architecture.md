---
id: KCCS-USR-0010
uid: 019b98c3-4e7e-7735-8980-f4e03aa3f3f2
type: Story
title: "Implement Multi-VCS Adapter architecture"
state: InProgress
priority: P2
parent: KCCS-FTR-0002
area: general
iteration: null
tags: []
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
Currently, the KCCS tool assumes Git (e.g., using `git log`, `git describe`). To be truly "Kano compliant" as per the spec, it should be VCS-agnostic and support other systems like Perforce or SVN via adapters.

# Goal
Refactor the core logic to use a `VCSAdapter` interface, allowing different systems to provide commit history and metadata.

# Approach
- Define a `BaseVCSAdapter` class.
- Implement `GitAdapter` (moving existing git commands here).
- Prepare a stub for `P4Adapter` (or manual change list provider).
- Update `generate_changelog.py` and `bump_version.py` to use the adapter.

# Acceptance Criteria
- [ ] Core scripts run normally on Git repos using the new adapter.
- [ ] Unit tests mock the adapter instead of calling real git.
- [ ] Adapter selection is automatic or via CLI flag.

# Risks / Dependencies
- Complexity in abstracting different VCS behaviors (e.g., Perforce changelists vs Git commits).

2026-01-08 02:25 [agent=antigravity] Created for Sprint 4 planning.
