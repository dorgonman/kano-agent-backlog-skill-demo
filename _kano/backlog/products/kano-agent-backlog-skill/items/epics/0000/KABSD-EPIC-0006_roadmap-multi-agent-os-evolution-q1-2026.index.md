---
type: Index
for: KABSD-EPIC-0006
title: "Roadmap: Multi-Agent OS Evolution (Q1 2026) Index"
updated: 2026-01-07
---

# MOC

- [[KABSD-FTR-0015_execution-layer-workset-cache-promote|KABSD-FTR-0015 Execution Layer: Workset Cache + Promote]] (state: Proposed)
- [[KABSD-FTR-0016_coordination-layer-claim-lease-for-multi-agent|KABSD-FTR-0016 Coordination Layer: Claim/Lease for Multi-Agent]] (state: Proposed)
- [[KABSD-FTR-0017_traceability-commit-refs-worklog-backfill|KABSD-FTR-0017 Traceability: Commit Refs → Worklog Backfill]] (state: Done)
  - [[KABSD-USR-0018_vcs-adapter-abstraction-layer|KABSD-USR-0018 VCS Adapter Abstraction Layer]] (state: Done)
    - [[KABSD-TSK-0105_implement-git-vcs-adapter|KABSD-TSK-0105 Implement Git VCS Adapter]] (state: Done)
    - [[KABSD-TSK-0106_implement-perforce-vcs-adapter|KABSD-TSK-0106 Implement Perforce VCS Adapter]] (state: Done)
    - [[KABSD-TSK-0107_implement-svn-vcs-adapter|KABSD-TSK-0107 Implement SVN VCS Adapter]] (state: Done)
    - [[KABSD-TSK-0108_implement-query-commits-py-query-tool|KABSD-TSK-0108 Implement query_commits.py Query Tool]] (state: Done)
    - [[KABSD-TSK-0109_implement-commit-timeline-view-generator|KABSD-TSK-0109 Implement Commit Timeline View Generator]] (state: Done)
  - [[KABSD-TSK-0110_evaluate-vcs-query-cache-layer|KABSD-TSK-0110 Evaluate VCS Query Cache Layer]] (state: InProgress)
- [[KABSD-FTR-0020_multi-agent-collaboration-modes-local-single-repo-local-multi-repo-via-worktree-remote|KABSD-FTR-0020 Multi-agent collaboration modes (local single repo / local multi repo via worktree / remote)]] (state: Proposed)
  - [[KABSD-TSK-0118_design-local-multi-agent-collaboration-single-repo|KABSD-TSK-0118 Design local multi-agent collaboration: single repo]] (state: Proposed)
  - [[KABSD-TSK-0119_design-local-multi-agent-collaboration-multi-repo-via-git-worktree|KABSD-TSK-0119 Design local multi-agent collaboration: multi repo via Git worktree]] (state: Proposed)
  - [[KABSD-TSK-0120_design-remote-multi-agent-collaboration|KABSD-TSK-0120 Design remote multi-agent collaboration]] (state: Proposed)

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/products/kano-agent-backlog-skill/items"
where parent = "KABSD-EPIC-0006"
sort priority asc
```

