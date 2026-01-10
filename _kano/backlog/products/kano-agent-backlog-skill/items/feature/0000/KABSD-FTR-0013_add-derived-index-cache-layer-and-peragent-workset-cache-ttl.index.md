---
type: Index
for: KABSD-FTR-0013
title: "Add derived index/cache layer and per‑Agent workset cache (TTL) Index"
updated: 2026-01-10
---

# MOC

- [[KABSD-TSK-0132_clarify-workset-graphrag-context-graph-responsibilities|KABSD-TSK-0132 Clarify & Spec — Workset vs GraphRAG / Context Graph Responsibilities (No Conflict)]] (state: Done)
- [[KABSD-TSK-0151_accept-adr-0011-and-adr-0012-for-workset-architecture|KABSD-TSK-0151 Accept ADR-0011 and ADR-0012 for Workset Architecture]] (state: Done)
- [[KABSD-TSK-0152_resolve-workset-directory-layout-inconsistency|KABSD-TSK-0152 Resolve workset directory layout inconsistency]] (state: Done)
- [[KABSD-TSK-0153_verify-canonical-schema-sql-existence-and-consistency|KABSD-TSK-0153 Verify canonical_schema.sql existence and consistency]] (state: Done)
- [[KABSD-TSK-0154_implement-canonical-sqlite-index-builder|KABSD-TSK-0154 Implement canonical SQLite index builder]] (state: Proposed)

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/products/kano-agent-backlog-skill/items"
where parent = "KABSD-FTR-0013"
sort priority asc
```

