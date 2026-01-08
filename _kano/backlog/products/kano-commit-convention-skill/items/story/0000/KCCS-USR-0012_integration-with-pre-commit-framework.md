---
id: KCCS-USR-0012
uid: 019b98c3-633a-7f1c-8980-f4e03aa3f3f4
type: Story
title: "Integration with pre-commit framework"
state: Ready
priority: P3
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
The `pre-commit` framework is widely used to manage multi-language hooks. Supporting it directly makes the tool easier to plug into existing CI/Dev workflows.

# Goal
Provide a `.pre-commit-hooks.yaml` definition so users can just add KCCS to their `.pre-commit-config.yaml`.

# Approach
- Add `.pre-commit-hooks.yaml` at the root of the skill or repo.
- Configure it to run `scripts/vcs/linter.py` for the `commit-msg` stage.
- Document usage in `SKILL.md`.

# Acceptance Criteria
- [ ] Users can add KCCS to `.pre-commit-config.yaml` using a `local` or `repo` source.
- [ ] The hook correctly blocks non-compliant messages when using the framework.

# Risks / Dependencies
- Requires Python to be available in the user's environment (standard for pre-commit).

2026-01-08 02:25 [agent=antigravity] Created for Sprint 4 planning.
