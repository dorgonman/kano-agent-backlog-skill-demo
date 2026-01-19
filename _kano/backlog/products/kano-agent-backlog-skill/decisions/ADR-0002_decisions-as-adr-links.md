---
date: 2026-01-05
id: ADR-0002
related_items:
- KABSD-FTR-0001
status: Proposed
superseded_by: null
supersedes: null
title: 'Decision handling: ADRs stay in decisions/ with item links'
uid: 019bc5dc-68d6-70fe-9273-9dd9099e89fb
---

# Decision

Keep decisions as ADR documents under `_kano/backlog/decisions/` and link them
from related work items via the `decisions` frontmatter field and a `Links` entry.
Do not model ADRs as backlog work items for now.

# Context

We discussed whether decisions should be treated as work items. The current
backlog uses ADRs to capture durable rationale without turning them into
workflow tickets. We want to preserve clarity while avoiding ticket sprawl.

# Links

- Related: [[../items/feature/0000/KABSD-FTR-0001_local-backlog-system|KABSD-FTR-0001 Local-first backlog system]]

# Options Considered

1) Keep ADRs as separate docs under `decisions/` and link from items.
2) Treat decisions as a new work item type under `items/` with states.
3) Hybrid: keep ADRs under `decisions/` plus optional lightweight decision tickets.

# Pros / Cons

- Option 1: clear separation and low overhead; requires linking discipline.
- Option 2: full backlog visibility; risks turning decisions into ticket noise.
- Option 3: flexible; extra ceremony and more items to maintain.

# Consequences

- ADRs remain outside the work item state machine.
- Work items should record ADR IDs in `decisions: []` and `Links`.
- Dashboards may need a separate decision view if visibility is required.

# Follow-ups

- Update related items to link ADR-0002.