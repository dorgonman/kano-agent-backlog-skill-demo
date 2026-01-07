---
id: KABSD-TSK-0114
uid: 019b980d-ef65-74b7-8ccc-72cf6613657e
type: Task
title: "Evaluate data backends: local files, SQLite, PostgreSQL/MySQL"
state: Proposed
priority: P2
parent: KABSD-FTR-0018
area: infrastructure
iteration: null
tags: ["cloud", "data", "sqlite", "postgres", "mysql"]
created: 2026-01-07
updated: 2026-01-07
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

Server mode requires a clear stance on what “the data” is and where it lives. Prior roadmap items already assume Git/files as SSOT and treat DB indexes as derived/cache. For server mode we must decide what storage backends are supported and under what constraints:

- Local file (Markdown) as SSOT (local-first).
- Local SQLite as a rebuildable derived index/cache.
- PostgreSQL/MySQL as an optional acceleration layer (likely cache/replica or write-through).

This affects performance, concurrency, conflict handling, backups, and compatibility.

# Goal

- Produce a decision matrix for backends:
  - file-first only
  - file-first + local sqlite index
  - file-first + remote DB acceleration (Postgres/MySQL)
- Recommend a default backend for “server mode” MVP and an upgrade path.
- Define invariants to prevent split-brain (write policies, sync direction, source-of-truth).

# Non-Goals

- Designing a full bidirectional replication/conflict-free sync system.
- Supporting commercial DB features beyond basic SQL needs.

# Approach

1. Define the invariants (must hold for all backends):
  - SSOT definition
  - rebuild-from-files capability
  - auditable changes and compatibility guarantees
2. Compare backend options across:
  - correctness/safety (split-brain risk)
  - performance and scaling
  - operational complexity (backups, migrations)
  - developer ergonomics
3. Propose a layered model:
  - canonical write path (likely files)
  - derived indexes (sqlite / postgres / mysql) as read views or cache
4. Identify what must be decided now vs can be deferred.

# Alternatives

- Make Postgres the master and dump to files (violates local-first principle).
- Use only local sqlite and never support external DB.

# Acceptance Criteria

- A written decision matrix exists with a clear recommended default.
- SSOT and sync direction are explicitly stated for each backend option.
- A minimal data-access interface boundary is identified (so server code can swap backends).
- Any “requires ADR” decisions are called out.

# Risks / Dependencies

- Supporting write-through to DB can introduce subtle consistency bugs.
- Concurrency semantics differ heavily across file, sqlite, and client/server DBs.
- External DB support implies secret management and network security requirements.

# Worklog

2026-01-07 18:43 [agent=copilot] Created for data backend decision matrix and SSOT implications.
