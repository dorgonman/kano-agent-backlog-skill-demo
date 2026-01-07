---
type: Index
for: KABSD-FTR-0017
title: "Traceability: Commit Refs → Worklog Backfill Index"
updated: 2026-01-07
---

# MOC

- [[KABSD-USR-0018_vcs-adapter-abstraction-layer|KABSD-USR-0018 VCS Adapter Abstraction Layer]] (state: Done)
  - [[KABSD-TSK-0105_implement-git-vcs-adapter|KABSD-TSK-0105 Implement Git VCS Adapter]] (state: Done)
  - [[KABSD-TSK-0106_implement-perforce-vcs-adapter|KABSD-TSK-0106 Implement Perforce VCS Adapter]] (state: Done)
  - [[KABSD-TSK-0107_implement-svn-vcs-adapter|KABSD-TSK-0107 Implement SVN VCS Adapter]] (state: Done)
  - [[KABSD-TSK-0108_implement-query-commits-py-query-tool|KABSD-TSK-0108 Implement query_commits.py Query Tool]] (state: Done)
  - [[KABSD-TSK-0109_implement-commit-timeline-view-generator|KABSD-TSK-0109 Implement Commit Timeline View Generator]] (state: Done)
- [[KABSD-TSK-0110_evaluate-vcs-query-cache-layer|KABSD-TSK-0110 Evaluate VCS Query Cache Layer]] (state: Proposed)

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/products/kano-agent-backlog-skill/items"
where parent = "KABSD-FTR-0017"
sort priority asc
```

