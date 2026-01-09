---
type: Index
for: KABSD-FTR-0027
title: "kano-agent-backlog-dispatcher: complexity-aware, bid-driven task routing layer Index"
updated: 2026-01-10
---

# MOC

- [[KABSD-USR-0024_complexity-scoring-rubric-and-required-tier-derivation|KABSD-USR-0024 Complexity scoring rubric and required tier derivation]] (state: Proposed)
  - [[KABSD-TSK-0137_define-complexity-rubric-tiers-and-schema-fields|KABSD-TSK-0137 Define complexity rubric, tiers, and schema fields]] (state: Proposed)
  - [[KABSD-TSK-0138_prototype-scoring-cli-spec-only-with-audit-trail|KABSD-TSK-0138 Prototype scoring CLI (spec-only) with audit trail]] (state: Proposed)
- [[KABSD-USR-0025_bid-gating-protocol-submit-plan-before-work-starts|KABSD-USR-0025 Bid gating protocol: submit plan before work starts]] (state: Proposed)
  - [[KABSD-TSK-0139_define-bid-template-and-minimum-bid-acceptance-rules|KABSD-TSK-0139 Define bid template and minimum bid acceptance rules]] (state: Proposed)
  - [[KABSD-TSK-0140_design-bid-selection-policy-single-bid-vs-competitive|KABSD-TSK-0140 Design bid selection policy (single-bid vs competitive)]] (state: Proposed)
- [[KABSD-USR-0026_assignment-record-and-conflict-isolation-for-dispatched-work|KABSD-USR-0026 Assignment record and conflict isolation for dispatched work]] (state: Proposed)
  - [[KABSD-TSK-0141_define-assignment-records-and-coordination-integration-claim-lease|KABSD-TSK-0141 Define assignment records and coordination integration (claim/lease)]] (state: Proposed)
  - [[KABSD-TSK-0142_design-enforcement-policy-to-prevent-low-tier-agents-touching-high-risk-items|KABSD-TSK-0142 Design enforcement policy to prevent low-tier agents touching high-risk items]] (state: Proposed)
- [[KABSD-USR-0027_governance-and-outcome-metrics-for-posterior-tiering|KABSD-USR-0027 Governance and outcome metrics for posterior tiering]] (state: Proposed)
  - [[KABSD-TSK-0143_define-outcome-metrics-schema-and-reporting-for-dispatch-decisions|KABSD-TSK-0143 Define outcome metrics schema and reporting for dispatch decisions]] (state: Proposed)
  - [[KABSD-TSK-0144_evaluate-external-benchmark-priors-and-local-posterior-update-rules|KABSD-TSK-0144 Evaluate external benchmark priors and local posterior update rules]] (state: Proposed)

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/products/kano-agent-backlog-skill/items"
where parent = "KABSD-FTR-0027"
sort priority asc
```

