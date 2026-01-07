---
type: Index
for: KABSD-FTR-0022
title: "Backlog Quality Linter (Agent Discipline) Index"
updated: 2026-01-07
---

# MOC

- [[KABSD-USR-0019_implement-language-guard-for-english-enforcement|KABSD-USR-0019 Implement Language Guard for English enforcement]] (state: Proposed)
- [[KABSD-USR-0020_check-link-symmetry-and-reference-integrity|KABSD-USR-0020 Check link symmetry and reference integrity]] (state: Proposed)
- [[KABSD-USR-0021_validate-section-completeness-in-backlog-items|KABSD-USR-0021 Validate section completeness in backlog items]] (state: Proposed)
- [[KABSD-USR-0022_provide-ci-integration-for-backlog-quality-linting|KABSD-USR-0022 Provide CI integration for backlog quality linting]] (state: Proposed)

## Auto list (Dataview)

```dataview
table id, state, priority
from "_kano/backlog/products/kano-agent-backlog-skill/items"
where parent = "KABSD-FTR-0022"
sort priority asc
```

