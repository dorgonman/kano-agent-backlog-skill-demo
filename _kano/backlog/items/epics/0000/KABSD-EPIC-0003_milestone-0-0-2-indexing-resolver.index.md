---
type: Index
for: KABSD-EPIC-0003
title: "Milestone 0.0.2 (Indexing + Resolver) Index"
updated: 2026-01-06
---

# MOC

- [[KABSD-FTR-0007_optional-db-index-and-embedding-rag-pipeline|KABSD-FTR-0007 Optional DB index and embedding/RAG pipeline]] (state: InProgress)
  - [[KABSD-USR-0012_index-file-based-backlog-into-sqlite-rebuildable|KABSD-USR-0012 Index file-based backlog into SQLite (rebuildable)]] (state: Done)
    - [[KABSD-TSK-0046_define-db-index-schema-items-links-worklog-decisions|KABSD-TSK-0046 Define DB index schema (items, links, worklog, decisions)]] (state: Done)
    - [[KABSD-TSK-0047_implement-sqlite-indexer-import-rebuild-incremental|KABSD-TSK-0047 Implement sqlite indexer (import + rebuild + incremental)]] (state: Done)
    - [[KABSD-TSK-0052_default-sqlite-index-artifacts-to-kano-backlog-index-and-gitignore|KABSD-TSK-0052 Default SQLite index artifacts to _kano/backlog/_index and gitignore]] (state: Done)
    - [[KABSD-TSK-0053_support-sandbox-backlog-root-mode-in-sqlite-indexer-config-resolution|KABSD-TSK-0053 Support sandbox backlog-root mode in SQLite indexer config resolution]] (state: Done)
  - [[KABSD-USR-0013_index-file-based-backlog-into-postgres-optional|KABSD-USR-0013 Index file-based backlog into Postgres (optional)]] (state: Proposed)
  - [[KABSD-USR-0014_configurable-process-choose-file-only-vs-db-index-backend|KABSD-USR-0014 Configurable process: choose file-only vs DB index backend]] (state: Done)
    - [[KABSD-TSK-0048_add-config-keys-for-db-index-backend-selection|KABSD-TSK-0048 Add config keys for DB index backend selection]] (state: Done)
  - [[KABSD-USR-0015_generate-embeddings-for-backlog-items-derivative-index|KABSD-USR-0015 Generate embeddings for backlog items (derivative index)]] (state: Proposed)
    - [[KABSD-TSK-0056_define-embedding-chunking-metadata-schema-for-backlog-items|KABSD-TSK-0056 Define embedding chunking + metadata schema for backlog items]] (state: Proposed)
    - [[KABSD-TSK-0057_prototype-local-embedding-index-writer-no-provider-dependency|KABSD-TSK-0057 Prototype local embedding index writer (no provider dependency)]] (state: Proposed)
  - [[KABSD-USR-0016_db-index-views-query-db-and-render-markdown-dashboards|KABSD-USR-0016 DB-index views: query DB and render Markdown dashboards]] (state: Done)
    - [[KABSD-TSK-0055_generate-markdown-views-from-sqlite-index-queries|KABSD-TSK-0055 Generate Markdown views from SQLite index queries]] (state: Done)
    - [[KABSD-TSK-0063_make-generate-view-use-sqlite-index-when-available-fallback-to-file-scan|KABSD-TSK-0063 Make generate_view use SQLite index when available (fallback to file scan)]] (state: Done)
    - [[KABSD-TSK-0064_unify-dashboard-generation-auto-use-sqlite-index-with-file-scan-fallback|KABSD-TSK-0064 Unify dashboard generation: auto use SQLite index with file-scan fallback]] (state: Done)
  - [[KABSD-USR-0017_query-the-sqlite-index-via-skill-scripts-read-only|KABSD-USR-0017 Query the SQLite index via skill scripts (read-only)]] (state: Done)
    - [[KABSD-TSK-0054_add-sqlite-index-query-cli-with-presets-and-safe-sql|KABSD-TSK-0054 Add sqlite index query CLI with presets and safe --sql]] (state: Done)
  - [[KABSD-TSK-0049_document-file-first-db-index-architecture-and-trade-offs|KABSD-TSK-0049 Document file-first + DB index architecture and trade-offs]] (state: Done)
  - [[KABSD-TSK-0050_document-index-config-artifact-paths-and-rebuild-workflow|KABSD-TSK-0050 Document index config, artifact paths, and rebuild workflow]] (state: Done)
  - [[KABSD-TSK-0051_extend-validate-userstories-to-cover-db-index-and-embeddings-stories|KABSD-TSK-0051 Extend validate_userstories to cover DB index and embeddings stories]] (state: Done)
- [[KABSD-FTR-0008_identifier-strategy-and-id-resolver-adr-0003|KABSD-FTR-0008 Identifier strategy and ID resolver (ADR-0003)]] (state: Proposed)
  - [[KABSD-TSK-0059_ulid-vs-uuidv7-comparison|KABSD-TSK-0059 ULID vs UUIDv7 comparison document]] (state: Done)
  - [[KABSD-TSK-0060_migration-plan-add-uid-to-existing-items|KABSD-TSK-0060 Migration plan: add uid to existing items]] (state: Done)
  - [[KABSD-TSK-0061_id-resolver-spec-and-design|KABSD-TSK-0061 ID resolver spec and design]] (state: Done)
  - [[KABSD-TSK-0062_collision-report-and-resolver-cli|KABSD-TSK-0062 Collision report and resolver CLI]] (state: Done)

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/items"
where parent = "KABSD-EPIC-0003"
sort priority asc
```

