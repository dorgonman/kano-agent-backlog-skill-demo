---
area: cli
created: '2026-01-18'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-BUG-0006
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: KABSD-FTR-0039
priority: P1
state: Done
tags: []
title: 'CLI: avoid Windows UnicodeEncodeError on non-UTF8 terminals'
type: Bug
uid: 019bce57-227d-7490-9305-d5740243451e
updated: 2026-01-18
---

# Context

On Windows terminals using a non-UTF8 code page/encoding, several kano-backlog CLI commands print Unicode glyphs (e.g., ✓, ❌, ⚠️). Typer/sys.stdout then raises UnicodeEncodeError (e.g., in 'view refresh'), causing first-run failures for new agents and wasted retries.

# Goal

Ensure kano-backlog CLI never crashes due to UnicodeEncodeError on Windows, regardless of terminal encoding, so first-run succeeds without requiring users/agents to set PYTHONIOENCODING or change code pages.

# Approach

Harden stdio configuration early in CLI startup (before any output) by reconfiguring stdout/stderr to use errors='replace' (and optionally UTF-8 when appropriate) on Windows. Keep existing user-facing output but guarantee it is encoding-safe. Add a regression test for the stdio hardening helper.

# Acceptance Criteria

1) Running 'python skills/kano-agent-backlog-skill/scripts/kano-backlog view refresh ...' does not crash on Windows even when stdout encoding cannot represent Unicode glyphs. 2) No more UnicodeEncodeError in CLI output paths. 3) Behavior is cross-platform safe (no change needed on Linux/macOS).

# Risks / Dependencies

Changing stdio configuration globally could affect tools that rely on a specific encoding; mitigate by only setting errors='replace' (no encoding override) and only on Windows.

# Worklog

2026-01-18 07:42 [agent=codex] [model=unknown] Created item
2026-01-18 07:43 [agent=codex] [model=unknown] Implement encoding-safe CLI stdout/stderr on Windows to avoid UnicodeEncodeError.
2026-01-18 07:44 [agent=codex] [model=unknown] Hardened CLI stdio on Windows (errors=replace) to prevent UnicodeEncodeError from Unicode glyph output; added regression test and verified view refresh no longer crashes without PYTHONIOENCODING.
