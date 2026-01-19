---
area: docs
created: '2026-01-18'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0256
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: null
priority: P2
state: Done
tags: []
title: Add OpenCode skill wrappers pointing to canonical SKILL.md
type: Task
uid: 019bce93-74a0-7325-8524-0621cae67288
updated: 2026-01-18
---

# Context

This repo uses canonical skill docs at skills/<skill-name>/SKILL.md and thin adapter wrappers for different agent runtimes (.codex/.github/.claude/.goose/.agent). OpenCode is listed in the agent roster but currently has no wrapper path, so OpenCode users don’t get the same entrypoint.

# Goal

Add an OpenCode-compatible wrapper that points to the canonical SKILL.md so OpenCode can discover and use the skill without duplicating content.

# Approach

Create .opencode/skills/<skill-name>/SKILL.md wrapper files that mirror the existing adapter pattern (short intro + canonical link). Start with kano-agent-backlog-skill (and also kano-commit-convention-skill for completeness).

# Acceptance Criteria

1) New files exist: .opencode/skills/kano-agent-backlog-skill/SKILL.md and .opencode/skills/kano-commit-convention-skill/SKILL.md. 2) Each wrapper clearly links to the canonical skills/<skill-name>/SKILL.md. 3) No canonical content duplicated beyond a brief summary.

# Risks / Dependencies

If OpenCode expects different frontmatter keys/paths than other adapters, we may need to tweak wrapper format; keep it minimal and easy to adjust.

# Worklog

2026-01-18 08:48 [agent=codex] [model=unknown] Created item
2026-01-18 08:49 [agent=codex] [model=unknown] Create .opencode adapter wrappers for canonical skills.
2026-01-18 08:49 [agent=codex] [model=unknown] Added .opencode skill wrapper files pointing to canonical SKILL.md for kano-agent-backlog-skill and kano-commit-convention-skill.
