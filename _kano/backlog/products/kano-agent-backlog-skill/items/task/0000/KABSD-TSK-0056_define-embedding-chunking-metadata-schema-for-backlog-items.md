---
id: KABSD-TSK-0056
uid: 019b8f52-9fc8-7c94-aa2d-806cacdd9086
type: Task
title: Define embedding chunking + metadata schema for backlog items
state: Done
priority: P4
parent: KABSD-USR-0015
area: rag
iteration: null
tags:
- embedding
- rag
- schema
created: 2026-01-05
updated: 2026-01-09
owner: copilot
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

Before embedding, we need a consistent chunking and metadata design so retrieval is predictable and rebuildable.

# Goal

Define chunking rules and metadata schema for turning backlog items into embedding documents.

# Non-Goals

# Provider-specific vector DB adapters (kept for later tasks).
# Remote/service inference (Local-first only; no cloud dependency).

# Approach

- Define what gets embedded (title/context/goal/approach/acceptance/worklog/ADR links; exclude secrets by policy).
- Define chunk boundaries (per section, per worklog entry group, max chars; preserve section path for traceability).
- Define metadata keys (id/type/state/updated/tags/parent/source_path/product/doctype/section/path_hash/version).
- Keep provider-agnostic output format (JSONL); specify schema versioning and hash fields for incremental rebuild.
- Include language guard expectations (English) and redaction hooks for future use.

# Alternatives

# Single large-document embedding (rejected: poor retrieval granularity).
# Line-based chunking only (rejected: loses semantic grouping per section/worklog entry).

# Acceptance Criteria

- A reference doc (or section in ADR/README) describes chunking + metadata + versioning, including schema version.
- Example JSONL output included (at least 1 work item, 1 ADR) showing metadata keys and section path.
- Chunking rules cover sections and worklog grouping, with max length guidance.
- Metadata includes `source_path` and `path_hash` for rebuild consistency; includes `product` and `doctype`.

# Risks / Dependencies

- Must remain Local-first; no remote embedding provider assumed.
- Downstream tasks (TSK-0057) depend on schema; avoid breaking changes after publishing.

# Worklog

2026-01-05 16:21 [agent=codex] Created from template.
2026-01-09 18:05 [agent=copilot] Added Ready details (scope, metadata keys, acceptance criteria, risks) to proceed.
2026-01-09 17:37 [agent=copilot] State -> InProgress.
2026-01-09 19:10 [agent=copilot] Drafted embedding chunking + metadata schema artifact at _kano/backlog/products/kano-agent-backlog-skill/artifacts/KABSD-TSK-0056/embedding_chunking_metadata.md.
2026-01-09 17:56 [agent=copilot] State -> Done.
