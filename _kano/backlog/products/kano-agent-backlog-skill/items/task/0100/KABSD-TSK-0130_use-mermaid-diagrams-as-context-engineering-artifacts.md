---
id: KABSD-TSK-0130
uid: 019bac45-bf54-75a1-a87c-228cfcd7bd49
type: Task
title: "Consider Mermaid diagrams as context-engineering artifacts for agent attention"
state: Done
priority: P2
parent: KABSD-EPIC-0006
area: documentation
iteration: null
tags: ["context-engineering", "mermaid", "diagrams", "agent", "documentation"]
created: 2026-01-08
updated: 2026-01-08
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: ["KABSD-EPIC-0005"]
  blocks: []
  blocked_by: []
decisions: []
---

# Context

This backlog skill is effectively doing context engineering: it turns collaboration into durable artifacts that guide future implementation decisions.

A recurring issue in agentic execution is attention drift: when context is large, agents may miss key architecture constraints, boundaries, or flows.

Mermaid diagrams (UML-ish, architecture diagrams, sequence diagrams, flowcharts) could serve as compact, high-signal context artifacts embedded directly in backlog items or companion docs.

# Goal

Decide whether and how we should encourage/require diagrams (Mermaid) as part of backlog items to improve agent attention and implementation alignment.

# Approach

1. Define which diagram types are most useful for this repo:
   - Architecture overview (components + boundaries)
   - Sequence diagram for critical flows (CLI -> scripts -> files/index)
   - State machine / lifecycle diagrams for work item state
   - Dependency graph conventions (blocks/blocked_by)
2. Define where diagrams should live:
   - Inline in items (recommended)
   - Separate docs referenced from items
   - Generated views under `_kano/backlog/views/`
  2.1 Decide default storage convention:
   - Product-local by default (store under the product that owns/drives the work)
   - Use `.md` files containing Mermaid blocks (primary audience: agents; also readable by humans)
3. Define quality bars:
   - Must be readable in plain Markdown
   - Must avoid over-detail; focus on attention-critical constraints
   - Must stay consistent with terminology (Project vs Product)
4. Decide policy:
   - Optional guideline (default)
   - Required for Epics/Features only
   - Required when certain tags are present (e.g. `architecture`)
5. Capture a short Mermaid template library for common patterns.

# Acceptance Criteria

- [x] A documented recommendation for when to include Mermaid diagrams in backlog items.
- [x] At least 2 concrete Mermaid templates (architecture + sequence) usable via copy/paste.
- [x] Clear guidance on where to store diagrams and how to keep them updated.
- [x] Follow-up tasks identified if tool/script support is needed (e.g. validation, view generation).

# Risks / Dependencies

- Diagrams can become stale; need a lightweight maintenance strategy.
- Over-requiring diagrams may slow iteration.
- Rendering differences across tools (Obsidian/GitHub/Markdown viewers) may affect readability.
- Depends on consistent terminology decisions (see Project vs Product task).

# Worklog

2026-01-08 12:18 [agent=windsurf] Created to discuss using Mermaid diagrams as high-signal context artifacts for agent attention in future implementation.
2026-01-08 13:27 [agent=windsurf] User decisions: policy Option A; diagrams live under a shared artifacts folder (so multiple items can reference); initial templates = architecture overview + sequence diagram. Open question: whether to add diagram tooling/automation into the skill vs keep as guidance/templates only.
2026-01-08 13:31 [agent=windsurf] User decision refinement: default diagram storage is product-local (store under the product that owns/drives the work). For cross-product collaboration/boundary diagrams, decide case-by-case; storing under the initiating side is acceptable for now.
2026-01-09 14:42 [agent=copilot] Implemented TSK-0130: Created mermaid-guidance.md with policy (recommend for architecture/workflow/integration/decision tags), storage convention (product-local artifacts/), 2 templates (layered architecture + sequence), quality bars (focused, readable in 30s, consistent terminology), and implementation checklist. Diagrams to be applied to FTR-0019/FTR-0020 design docs. Follow-ups: diagram validation tooling.
2026-01-09 11:36 [agent=windsurf] Established shared artifacts convention for cross-product items and copied mermaid guidance to `_kano/backlog/_shared/artifacts/KABSD-TSK-0130/mermaid-guidance.md`.
