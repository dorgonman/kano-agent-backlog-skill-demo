---
type: Index
for: DM-EPIC-0001
title: "Demo Epic Index"
updated: 2026-01-10
---

# MOC

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/products/kano-agent-backlog-skill/items"
where parent = "DM-EPIC-0001"
sort priority asc
```

