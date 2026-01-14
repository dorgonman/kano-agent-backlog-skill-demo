---
area: general
created: '2026-01-15'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0205
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: copilot
parent: null
priority: P2
state: Done
tags: []
title: Make skill README standalone-focused
type: Task
uid: 019bbd78-3f12-701b-9a54-f15cdf12b03d
updated: 2026-01-15
---

# Context

The skill README currently reads like part of the demo monorepo (paths like skills/.../scripts/...) and duplicates content covered by the demo root README. As a standalone repo, it should focus on how a user installs and runs the CLI in their own repository.

# Goal

Make skills/kano-agent-backlog-skill/README.md a standalone, user-repo-friendly entrypoint that explains install/run, the minimal workflow, and links to deeper docs without demo-specific paths.

# Approach

Rewrite the README around: (1) what the skill is, (2) how to install it (pip -e .) and run it (kano-backlog / python scripts/kano-backlog), (3) how to initialize a backlog in the current repo, (4) the minimal tickets-first workflow, (5) high-level Workset/Topic pointers with links to docs. Remove or demote demo-monorepo-specific instructions and fix any stray/invalid markdown blocks.

# Acceptance Criteria

- README shows commands that work when this repo is checked out standalone (no skills/... paths)
- README uses kano-backlog as the canonical CLI command (matching pyproject entrypoint)
- Workset/Topic sections remain high-level and link to docs/workset.md and docs/topic.md
- No trailing stray code fences or broken markdown

# Risks / Dependencies

Potential inconsistency with demo root README command naming; keep this README correct for the standalone package entrypoint.

# Worklog

2026-01-15 01:05 [agent=copilot] Created item
2026-01-15 01:05 [agent=copilot] [model=gpt-5.2] Start rewriting skill README for standalone usage.
2026-01-15 01:11 [agent=copilot] [model=gpt-5.2] Rewrote skill README to be standalone-repo friendly (kano-backlog install/run, corrected paths, cleaned broken markdown).
