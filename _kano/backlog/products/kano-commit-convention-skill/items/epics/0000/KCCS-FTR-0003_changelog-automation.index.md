---
type: Index
for: KCCS-FTR-0003
title: "Changelog Automation Index"
updated: 2026-01-07
---

# MOC

- [[KCCS-USR-0005_implement-generate-changelog-py|KCCS-USR-0005 Implement generate_changelog.py]] (state: Proposed)
- [[KCCS-USR-0006_group-and-filter-changelog-entries|KCCS-USR-0006 Group and filter changelog entries]] (state: Proposed)
- [[KCCS-USR-0007_support-markdown-and-json-changelog-formats|KCCS-USR-0007 Support Markdown and JSON changelog formats]] (state: Proposed)

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/products/kano-commit-convention-skill/items"
where parent = "KCCS-FTR-0003"
sort priority asc
```

