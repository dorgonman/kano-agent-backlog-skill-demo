---
type: Index
for: KABSD-FTR-0025
title: "Unified CLI for All Backlog Operations Index"
updated: 2026-01-10
---

# MOC

- [[KABSD-TSK-0132_implement-kano-item-create-subcommand|KABSD-TSK-0132 Implement `kano item create` subcommand]] (state: Proposed)
- [[KABSD-TSK-0133_implement-kano-item-update-state-subcommand|KABSD-TSK-0133 Implement `kano item update-state` subcommand]] (state: Proposed)
- [[KABSD-TSK-0134_implement-kano-item-validate-subcommand|KABSD-TSK-0134 Implement `kano item validate` subcommand]] (state: Proposed)
- [[KABSD-TSK-0135_implement-kano-view-refresh-subcommand|KABSD-TSK-0135 Implement `kano view refresh` subcommand]] (state: Proposed)
- [[KABSD-BUG-0001_workitem-update-state-crashes-args-model-attribute-missing|KABSD-BUG-0001 workitem_update_state crashes: args.model attribute missing]] (state: Proposed)

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/products/kano-agent-backlog-skill/items"
where parent = "KABSD-FTR-0025"
sort priority asc
```

