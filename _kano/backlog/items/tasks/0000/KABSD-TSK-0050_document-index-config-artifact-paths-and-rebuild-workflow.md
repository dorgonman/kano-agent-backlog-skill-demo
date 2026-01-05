---
id: KABSD-TSK-0050
type: Task
title: "Document index config, artifact paths, and rebuild workflow"
state: Proposed
priority: P3
parent: KABSD-FTR-0007
area: docs
iteration: null
tags: ["docs", "index", "config"]
created: 2026-01-05
updated: 2026-01-05
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

We decided DB/embeddings are optional and file-first remains source of truth.
We need clear docs so users understand what is generated, where artifacts live, and how to rebuild safely.

# Goal

Document how to enable the optional index layer and how to manage its artifacts without breaking file-first workflows (including Obsidian views).

# Non-Goals

# Approach

- Add a reference doc (e.g. `references/indexing.md`) describing:
  - `index.*` config keys and defaults (disabled).
  - Recommended artifact locations (`_kano/backlog/_index/` or sandbox).
  - Rebuild workflow and safety guarantees (no source edits).
  - How to keep using Obsidian views in file-first mode; optional DB->Markdown view generation.
- Update `REFERENCE.md` to list the new reference file.

# Alternatives

# Acceptance Criteria

- `references/indexing.md` exists and describes config + artifact paths + rebuild steps.
- `REFERENCE.md` links to `references/indexing.md`.
- Docs clearly state: file-first is default; DB-first is out of scope.

# Risks / Dependencies

- Doc drift if config keys or paths change.

# Worklog

2026-01-05 13:22 [agent=codex] Created from template.
