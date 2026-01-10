---
id: KABSD-TSK-0154
uid: 019ba761-87e9-770d-9f34-7f0a2a20c576
type: Task
title: "Implement canonical SQLite index builder"
state: Proposed
priority: P1
parent: KABSD-FTR-0013
area: general
iteration: null
tags: ["index", "schema", "sqlite"]
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
decisions: []
---

# Context

- KABSD-FTR-0013 requires a rebuildable SQLite index that mirrors the canonical schema defined in `_meta/canonical_schema.sql` (per ADR-0012).
- The current `scripts/backlog/index_db.py` only tracks minimal frontmatter data and assumes `_kano/backlog/items/`, ignoring multi-product layout and the canonical schema contract.
- Workset features (KABSD-FTR-0015) and downstream tooling need `items`, `links`, `worklog`, and `chunks` tables populated consistently so workset DBs can be materialized from the same schema.

# Goal

Deliver a canonical index builder (`scripts/backlog/index_db.py`) that:
1. Targets a specific product (default from `_shared/defaults.json`) or sandbox, honoring per-product index paths (ADR-0004).
2. Loads and applies `_meta/canonical_schema.sql` before writing any data.
3. Parses backlog + decision Markdown files into `items`, `links`, `worklog`, and `chunks` tables, storing deterministic hashes and relative paths.
4. Supports `--mode rebuild` (delete+recreate DB) and an incremental mode that updates only changed items.

# Non-Goals

- Do not implement vector embeddings or ANN sidecars (handled by other scripts).
- Do not implement schema migrations beyond reading the canonical SQL file.
- Workset materialization scripts (init/refresh/promote) remain out-of-scope.

# Approach

1. Extend `index_db.py` CLI to resolve product/sandbox roots using `context.resolve_product_name` and to load `_meta/canonical_schema.sql`.
2. Implement Markdown parsing helpers:
  - Frontmatter extraction via `lib.utils.parse_frontmatter`.
  - Worklog parser for `# Worklog` entries (date + `[agent=]`).
  - Simple section chunker that produces deterministic `chunk_id`s per heading.
3. Rebuild mode: remove existing DB, create directories, execute schema SQL, and insert all rows inside a transaction.
4. Incremental mode: compare `content_hash` per UID, upsert changed items (delete dependent rows first), and prune missing items.
5. Update metadata rows (e.g., `schema_meta.generator`, `schema_meta.generated_at_utc`) for traceability.

# Alternatives

1. **Re-use `scripts/indexing/build_sqlite_index.py`** – heavier dependency, uses a different schema file; would require translation anyway.
2. **Materialize via Obsidian Dataview exports** – couples to Obsidian runtime, impossible for headless agents.
3. **Store JSON sidecars per item** – explodes file count and breaks SQL query patterns.

# Acceptance Criteria

- [ ] `scripts/backlog/index_db.py --rebuild --product kano-agent-backlog-skill` recreates `_kano/backlog/products/kano-agent-backlog-skill/_index/backlog.sqlite3` using `_meta/canonical_schema.sql`.
- [ ] Items table stores uid/id/type/title/state/parent_uid/tags/frontmatter/path/mtime/content_hash for both backlog items and ADRs.
- [ ] `links` table contains at least parent/relates/blocks/blocked_by edges where target IDs can be resolved.
- [ ] `worklog` table contains parsed entries (timestamp+agent+content) with deterministic UIDs.
- [ ] `chunks` table contains at least one chunk per section (skipping `Worklog`).
- [ ] `--mode incremental` reruns without deleting the DB, only touching changed/missing items.
- [ ] Script updates schema_meta with generator metadata and exits non-zero when canonical_schema.sql is missing.

# Risks / Dependencies

1. **Dependency**: canonical schema file must stay synchronized with ADR-0012; script should fail fast if missing.
2. **Risk**: Improper worklog parsing may miss entries; mitigate with unit-style helper + defensive parsing.
3. **Risk**: Schema drift between products; mitigate by always loading product-local `_meta/canonical_schema.sql`.
4. **Dependency**: Python env needs `pyyaml` (already required for parse_frontmatter).

# Worklog

2026-01-10 18:09 [agent=copilot] Created from template.
2026-01-10 18:12 [agent=copilot] Filled Ready gate with scope, approach, and acceptance criteria for canonical index builder.
