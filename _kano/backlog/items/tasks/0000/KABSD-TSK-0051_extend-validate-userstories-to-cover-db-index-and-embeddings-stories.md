---
id: KABSD-TSK-0051
type: Task
title: "Extend validate_userstories to cover DB index and embeddings stories"
state: Done
priority: P4
parent: KABSD-FTR-0007
area: tests
iteration: null
tags: ["tests", "index", "rag"]
created: 2026-01-05
updated: 2026-01-06
owner: codex
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

We have new user stories under KABSD-FTR-0007 but the current validation script only checks up to USR-0010.

# Goal

Extend script-level validation so the repo can detect missing artifacts/docs for DB index and embedding/RAG stories.

# Non-Goals

# Approach

- Update `skills/kano-agent-backlog-skill/scripts/tests/validate_userstories.py` to add checks for:
  - `index.enabled` key exists in config defaults.
  - Jira built-in profile exists (already) and new indexing doc exists.
  - Presence of placeholder files or scripts as they are implemented (schema doc, indexer script).
- Keep checks non-flaky: validate file existence/strings, not runtime DB connectivity.

# Alternatives

# Acceptance Criteria

- Validation includes entries for USR-0012~0016 and fails when expected files are missing.
- Running the script passes in this demo repo for the current implemented subset.

# Risks / Dependencies

- Overly strict checks could block iteration; keep them minimal and additive.

# Worklog

2026-01-05 13:22 [agent=codex] Created from template.
2026-01-06 01:04 [agent=codex] State -> Ready. Ready gate validated for extending validate_userstories.
2026-01-06 01:04 [agent=codex] State -> InProgress. Updating validate_userstories.py to cover USR-0012~0017 baseline artifacts.
2026-01-06 01:05 [agent=codex] State -> Done. Extended validate_userstories.py to cover indexing docs/scripts and index config keys; script passes on demo repo.
