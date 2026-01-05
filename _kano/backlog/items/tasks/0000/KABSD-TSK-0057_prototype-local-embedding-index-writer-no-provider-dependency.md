---
id: KABSD-TSK-0057
type: Task
title: "Prototype local embedding index writer (no provider dependency)"
state: Proposed
priority: P4
parent: KABSD-USR-0015
area: rag
iteration: null
tags: ["embedding", "rag", "local"]
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

We want a minimal RAG pipeline without forcing a specific embedding provider or vector DB yet.

# Goal

Prototype a local embedding-index writer that outputs provider-agnostic artifacts (no network required).

# Non-Goals

# Approach

- Implement a script that reads backlog files and emits chunk JSONL (and optionally placeholder vectors).
- Store artifacts under `_kano/backlog/_index/embeddings/` (gitignored) or sandbox.
- Later, providers/vector DB adapters can consume these artifacts.

# Alternatives

# Acceptance Criteria

- Script runs offline and produces chunk JSONL with correct metadata for the demo backlog.
- Artifact path is gitignored.
- No secrets are required; no network calls.

# Risks / Dependencies

# Worklog

2026-01-05 16:21 [agent=codex] Created from template.
