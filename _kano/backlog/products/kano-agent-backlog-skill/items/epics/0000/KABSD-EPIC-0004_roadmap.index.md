---
type: Index
for: KABSD-EPIC-0004
title: "Roadmap Index"
updated: 2026-01-07
---

# MOC

- [[KABSD-FTR-0012_optional-cloud-acceleration-postgresql-mysql-fastapi-openapi-swagger-ui|KABSD-FTR-0012 Optional cloud acceleration (PostgreSQL/MySQL + FastAPI + OpenAPI/Swagger UI)]] (state: Proposed)
- [[KABSD-FTR-0013_add-derived-index-cache-layer-and-peragent-workset-cache-ttl|KABSD-FTR-0013 Add derived index/cache layer and per‑Agent workset cache (TTL)]] (state: Proposed)
- [[KABSD-FTR-0014_maintain-git-files-as-the-single-source-of-truth-and-sync-cloud-cache|KABSD-FTR-0014 Maintain Git/files as the single source of truth and sync cloud cache]] (state: Proposed)
- [[KABSD-FTR-0018_server-mode-mcp-http-docker-data-backend-separation|KABSD-FTR-0018 Server mode (MCP/HTTP) + Docker + data backend separation]] (state: Proposed)
  - [[KABSD-TSK-0112_evaluate-server-interface-mcp-vs-http|KABSD-TSK-0112 Evaluate server interface: MCP vs HTTP]] (state: Proposed)
  - [[KABSD-TSK-0113_evaluate-docker-packaging-and-runtime-split-server-vs-data|KABSD-TSK-0113 Evaluate Docker packaging and runtime split (server vs data)]] (state: Proposed)
  - [[KABSD-TSK-0114_evaluate-data-backends-local-files-sqlite-postgresql-mysql|KABSD-TSK-0114 Evaluate data backends: local files, SQLite, PostgreSQL/MySQL]] (state: Proposed)
- [[KABSD-FTR-0019_refactor-kano-backlog-core-cli-server-gui-facades|KABSD-FTR-0019 Refactor: kano-backlog-core + CLI/Server/GUI facades]] (state: Proposed)
  - [[KABSD-TSK-0115_define-core-interfaces-and-module-boundaries|KABSD-TSK-0115 Define core interfaces and module boundaries]] (state: Proposed)
  - [[KABSD-TSK-0116_plan-cli-migration-to-thin-wrappers|KABSD-TSK-0116 Plan CLI migration to thin wrappers]] (state: Proposed)
  - [[KABSD-TSK-0117_design-server-facade-layering-http-mcp|KABSD-TSK-0117 Design server facade layering (HTTP/MCP)]] (state: Proposed)
- [[KABSD-FTR-0021_vcs-merge-workflows-and-conflict-resolution-git-svn-perforce|KABSD-FTR-0021 VCS merge workflows and conflict resolution (Git/SVN/Perforce)]] (state: Proposed)
- [[KABSD-FTR-0022_backlog-quality-linter-agent-discipline|KABSD-FTR-0022 Backlog Quality Linter (Agent Discipline)]] (state: Proposed)

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/products/kano-agent-backlog-skill/items"
where parent = "KABSD-EPIC-0004"
sort priority asc
```

