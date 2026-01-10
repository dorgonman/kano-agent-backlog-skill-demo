---
id: KABSD-TSK-0153
uid: 019ba6e8-032b-7a82-a76f-5ba8bb7a7094
type: Task
title: "Verify canonical_schema.sql existence and consistency"
state: Done
priority: P2
parent: KABSD-FTR-0013
area: general
iteration: null
tags: ["workset", "schema", "validation"]
created: 2026-01-10
updated: 2026-01-10
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: ["ADR-0012"]
---

# Context

ADR-0012 (Workset DB canonical schema reuse) states:

> "The canonical schema is defined once (e.g., `_meta/canonical_schema.sql` or in code) and applied to all SQLite instances."

To avoid schema drift, we need a clear canonical schema location and it must match what the indexing and workset databases expect.
This affects:

1. `index_db.py --rebuild` schema creation
2. Workset DB initialization (schema reuse)
3. preventing accidental divergence across derived data stores

# Goal

1. Confirm `canonical_schema.sql` exists in the expected location.
2. Confirm the schema matches ADR-0012’s described tables.
3. Capture any mismatch as follow-up work.

# Non-Goals

- Do not rewrite index scripts here.
- Do not redesign ADR-0012’s schema model.

# Approach

1. Check for canonical schema files:
   - `_kano/backlog/products/kano-agent-backlog-skill/_meta/canonical_schema.sql`
   - `skills/kano-agent-backlog-skill/references/indexing_schema.sql`
   - `skills/kano-agent-backlog-skill/references/indexing_schema.json`
2. Confirm ADR-0012’s required tables exist:
   - `items` (id, uid, type, title, state, priority, parent, area, iteration, tags, created, updated, owner)
   - `links` (source_id, target_id, link_type)
   - `worklog` (item_id, timestamp, agent, message)
   - `chunks` (item_id, heading_path, content_hash, body_text)
   - `schema_meta` (version, migrated_at)
3. Record any gaps (e.g., FTS tables) explicitly as extensions.

# Alternatives

1. Define schema only in code: reduces duplication, but makes it harder to audit and share.
2. Keep schema only as ADR text: not executable.

# Acceptance Criteria

- [x] Canonical schema file exists at `_kano/backlog/products/kano-agent-backlog-skill/_meta/canonical_schema.sql`
- [x] The tables `items`, `links`, `worklog`, `chunks`, `schema_meta` exist in the canonical definition
- [x] Any intentional extensions are documented (not silently diverging)
- [x] Worklog updated

# Risks / Dependencies

1. **Risk**: schema mismatches can break derived index rebuilds.
   - Mitigation: keep ADR-0012 aligned and add validation scripts.
2. **Dependency**: ADR acceptance should be done first (TSK-0151).

# Worklog

2026-01-10 15:56 [agent=copilot] Created from template.
2026-01-10 16:01 [agent=copilot] Populated Ready gate content based on Workset review findings.
2026-01-10 16:12 [agent=copilot] Verified canonical_schema.sql exists and matches ADR-0012 (tables + indexes + workset_* guidance). Marking task Done.
