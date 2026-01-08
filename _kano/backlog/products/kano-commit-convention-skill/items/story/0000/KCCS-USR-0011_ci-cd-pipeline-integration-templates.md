---
id: KCCS-USR-0011
uid: 019b98c3-585a-7b34-8980-f4e03aa3f3f3
type: Story
title: "CI/CD Pipeline Integration Templates"
state: Ready
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
KCCS should be a standard part of the "Ready Gate" in CI/CD. Providing ready-to-use templates reduces friction for adoption.

# Goal
Create example configurations for popular CI systems.

# Approach
- Provide `github-workflow.yml` example.
- Provide `gitlab-ci.yml` example.
- Document how to fail the build if `linter.py` fails on PR/MR titles or commit range.
- Document how to use the JSON changelog output in a release step.

# Acceptance Criteria
- [ ] YAML templates exist in `references/examples/`.
- [ ] Documentation clearly explains how to set up the "Commit Guard" in CI.

# Risks / Dependencies
- None.

2026-01-08 02:25 [agent=antigravity] Created for Sprint 4 planning.
