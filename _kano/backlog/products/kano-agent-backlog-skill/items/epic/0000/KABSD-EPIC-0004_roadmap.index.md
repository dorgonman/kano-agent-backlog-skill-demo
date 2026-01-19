---
type: Index
for: KABSD-EPIC-0004
title: "Roadmap Index"
updated: 2026-01-09
---

# MOC

- [[KABSD-FTR-0012_optional-cloud-acceleration-postgresql-mysql-fastapi-openapi-swagger-ui|KABSD-FTR-0012 Optional cloud acceleration (PostgreSQL/MySQL + FastAPI + OpenAPI/Swagger UI)]] (state: Proposed)
- [[KABSD-FTR-0013_add-derived-index-cache-layer-and-peragent-workset-cache-ttl|KABSD-FTR-0013 Add derived index/cache layer and per‑Agent workset cache (TTL)]] (state: Proposed)
- [[KABSD-FTR-0014_maintain-git-files-as-the-single-source-of-truth-and-sync-cloud-cache|KABSD-FTR-0014 Maintain Git/files as the single source of truth and sync cloud cache]] (state: Proposed)
- [[KABSD-FTR-0018_server-mode-mcp-http-docker-data-backend-separation|KABSD-FTR-0018 Server mode (MCP/HTTP) + Docker + data backend separation]] (state: Proposed)
  - [[KABSD-TSK-0112_evaluate-server-interface-mcp-vs-http|KABSD-TSK-0112 Evaluate server interface: MCP vs HTTP]] (state: Proposed)
  - [[KABSD-TSK-0113_evaluate-docker-packaging-and-runtime-split-server-vs-data|KABSD-TSK-0113 Evaluate Docker packaging and runtime split (server vs data)]] (state: Proposed)
  - [[KABSD-TSK-0114_evaluate-data-backends-local-files-sqlite-postgresql-mysql|KABSD-TSK-0114 Evaluate data backends: local files, SQLite, PostgreSQL/MySQL]] (state: Proposed)
- [[KABSD-FTR-0019_refactor-kano-backlog-core-cli-server-gui-facades|KABSD-FTR-0019 Refactor: kano-backlog-core + CLI/Server/GUI facades]] (state: Done)
  - [[KABSD-TSK-0001_project-backlog-skill|KABSD-TSK-0001 Implement kano-backlog-core Phase 3: State and Audit modules]] (state: Done)
  - [[KABSD-TSK-0115_define-core-interfaces-and-module-boundaries|KABSD-TSK-0115 Define core interfaces and module boundaries]] (state: Done)
  - [[KABSD-TSK-0116_plan-cli-migration-to-thin-wrappers|KABSD-TSK-0116 Plan CLI migration to thin wrappers]] (state: Done)
  - [[KABSD-TSK-0117_design-server-facade-layering-http-mcp|KABSD-TSK-0117 Design server facade layering (HTTP/MCP)]] (state: Done)
  - [[KABSD-TSK-0121_design-config-schema-for-data-backend-abstraction-canonical-vs-derived|KABSD-TSK-0121 Design config schema for data backend abstraction (canonical vs derived)]] (state: Proposed)
  - [[KABSD-TSK-0122_design-config-schema-for-data-backend-abstraction-canonical-vs-derived|KABSD-TSK-0122 Design config schema for data backend abstraction (canonical vs derived)]] (state: Proposed)
  - [[KABSD-TSK-0125_implement-kano-backlog-core-config-and-canonical-modules|KABSD-TSK-0125 Implement kano-backlog-core: Config and Canonical modules]] (state: Done)
  - [[KABSD-TSK-0127_implement-kano-backlog-core-phase-2-derived-and-refs-modules|KABSD-TSK-0127 Implement kano-backlog-core Phase 2: Derived and Refs modules]] (state: Done)
- [[KABSD-FTR-0023_graph-assisted-rag-planning-and-minimal-implementation|KABSD-FTR-0021 Graph-assisted RAG planning and minimal implementation]] (state: Proposed)
- [[KABSD-FTR-0022_backlog-quality-linter-agent-discipline|KABSD-FTR-0022 Backlog Quality Linter (Agent Discipline)]] (state: Done)
  - [[KABSD-USR-0019_implement-language-guard-for-english-enforcement|KABSD-USR-0019 Implement Language Guard for English enforcement]] (state: Proposed)
  - [[KABSD-USR-0020_check-link-symmetry-and-reference-integrity|KABSD-USR-0020 Check link symmetry and reference integrity]] (state: Proposed)
  - [[KABSD-USR-0021_validate-section-completeness-in-backlog-items|KABSD-USR-0021 Validate section completeness in backlog items]] (state: Proposed)
  - [[KABSD-USR-0022_provide-ci-integration-for-backlog-quality-linting|KABSD-USR-0022 Provide CI integration for backlog quality linting]] (state: Proposed)
  - [[KABSD-TSK-0123_remediate-non-english-content-in-backlog-adrs-items-to-english|KABSD-TSK-0123 Remediate non-English content in backlog (ADRs/items) to English]] (state: Done)
- [[KABSD-FTR-0023_graph-assisted-rag-planning-and-minimal-implementation|KABSD-FTR-0023 Graph-assisted RAG planning and minimal implementation]] (state: Proposed)
- [[KABSD-FTR-0024_global-config-layers-and-uri-compilation|KABSD-FTR-0024 Global config layers and URI compilation]] (state: Proposed)

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/products/kano-agent-backlog-skill/items"
where parent = "KABSD-EPIC-0004"
sort priority asc
```

