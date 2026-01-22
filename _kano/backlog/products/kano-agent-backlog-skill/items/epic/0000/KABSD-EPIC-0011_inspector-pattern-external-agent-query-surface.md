---
area: general
created: '2026-01-22'
decisions:
- ADR-0037
external:
  azure_id: null
  jira_key: null
id: KABSD-EPIC-0011
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: null
priority: P0
state: Proposed
tags:
- architecture
- inspector-pattern
- query-surface
title: 'Inspector Pattern: External Agent Query Surface'
type: Epic
uid: 019be32e-fe48-73e9-8507-8ccb904be5f1
updated: '2026-01-22'
---

# Context

**Origin**: GPT-5.2 feedback on backlog discipline and architecture (2026-01-22)

**Problem Statement**: 
Current backlog skill risks encoding "judgment" (health assessment, review suggestions, refactor recommendations) into core logic. This creates:
- Goodhart's Law risk: metrics become targets, lose meaning
- Tight coupling: expert logic hardcoded into skill core
- Limited extensibility: hard to swap assessment strategies
- Inconsistent evidence: conclusions without traceable sources

**Key Insight from GPT-5.2**:
> "Backlog skill's responsibility: provide all tools for agents to reliably acquire information, not hardcode judgment into core."

**Current State**:
- Skill has audit, snapshot, constellation primitives (good foundation)
- No formal "Inspector Pattern" contract for external agents
- Missing evidence-first reporting standards
- No clear separation between data layer and judgment layer

**Related Work**:
- 3+3 questions (health/ideas assessment) - currently proposed as feature
- Decision audit / write-back workflows - implemented but ad-hoc
- External agent integration - no formal contract

# Goal

**Establish Inspector Pattern architecture** where:

1. **Skill Core = Query Surface**: Provides deterministic, evidence-based data extraction
2. **External Agents = Experts**: Consume query surface, produce conclusions with evidence trails
3. **Evidence-First**: Every conclusion must cite file path + line range (or stable anchor) + workitem/ADR ID + derived artifact ref
4. **Replaceable Experts**: Any agent can implement Inspector Contract and produce comparable outputs

**Success Criteria**:
- Inspector Agent Contract defined and documented
- Query surface API implemented (audit, snapshot, constellation, workitem.query, doc.resolve, export.bundle)
- Evidence attachment standard enforced
- At least one reference inspector agent (health/ideas or review) implemented

# Non-Goals

- **NOT building daily/automated assessment**: Frequency is use-case specific (manual, CI, on-demand)
- **NOT hardcoding assessment logic**: Core stays deterministic data layer
- **NOT replacing human judgment**: Inspectors assist, don't decide
- **NOT creating new SoT**: Files remain canonical, inspectors are read-only

# Approach

## Principle A: Core = Data + Derived Artifacts (Deterministic)

**Core Responsibilities**:
- `audit` = Rules enforcement (deterministic)
- `snapshot` = Current state extraction (deterministic)
- `constellation` = Relationship graph (evidence-based)
- `index` = Search acceleration (FTS/embedding/graph)

**All deterministic, repeatable, no "expert opinion".**

## Principle B: External Agents = Experts (Replaceable)

**Expert Types** (all external to core):
- **Inspector Agent** (health/ideas): 3+3 questions, gap analysis, anti-patterns
- **Reviewer Agent**: Code review suggestions, best practices
- **Architect Agent**: Refactoring recommendations, design improvements
- **Security Agent**: Threat model, vulnerability assessment

**Key**: These are separate processes/agents, not core modules.

## Principle C: Evidence = First-Class Citizen

Every inspector output must include:
- **Source**: file path + line range (or stable anchor)
- **Context**: workitem/ADR ID
- **Derived ref**: audit finding ID / snapshot ID / constellation node
- **Timestamp**: when evidence was collected
- **Agent**: which inspector produced the conclusion

**No evidence = rejected or downgraded.**

## Inspector Agent Contract

**Query Surface API** (skill must provide):

```python
# Audit API
audit.run(format=json|md) -> audit_report
  # Returns: findings with IDs, categories, severity, evidence

# Snapshot API
snapshot.build(window=None, since=None, format=json|md) -> snapshot
  # Returns: current state summary with item counts, state distribution, recent changes

# Constellation API
constellation.build(seed=item_id, depth=2, format=json|dot) -> graph
  # Returns: relationship graph with nodes, edges, metadata

# Workitem Query API
workitem.query(filters={}, format=json) -> [items]
  # Returns: filtered list of work items with full metadata

# Document Resolution API
doc.resolve(id=item_id|adr_id) -> {path, excerpts, anchors}
  # Returns: file path + structured excerpts with line numbers

# Export Bundle API (optional)
export.bundle(profile=inspector, format=json|tar) -> bundle
  # Returns: snapshot of all relevant files for inspector consumption
```

**Inspector Output Contract**:

```json
{
  "inspector": "health-ideas-v1",
  "agent": "antigravity",
  "timestamp": "2026-01-22T08:51:00Z",
  "findings": [
    {
      "category": "health",
      "question": "Are items well-formed?",
      "assessment": "...",
      "evidence": [
        {
          "type": "audit_finding",
          "finding_id": "AF-001",
          "item_id": "KABSD-TSK-0042",
          "file": "_kano/backlog/items/task/0000/KABSD-TSK-0042.md",
          "line_range": [25, 30],
          "issue": "Missing Acceptance Criteria"
        }
      ]
    }
  ]
}
```

## Implementation Phases

### Phase 1: Define Contract (ADR)
- Create ADR-00XX: Inspector Pattern and Query Surface
- Document required query APIs
- Define evidence attachment standard
- Define inspector output schema

### Phase 2: Implement Query Surface
- Implement missing query APIs (audit.run, snapshot.build, etc)
- Add JSON output format to all APIs
- Add evidence anchors (file paths, line ranges, stable IDs)

### Phase 3: Reference Inspector
- Build one reference inspector (health/ideas or reviewer)
- Validate contract through real usage
- Document integration patterns

### Phase 4: Documentation & Tooling
- Update AGENTS.md with inspector pattern guidance
- Add inspector examples to SKILL.md
- Create inspector scaffolding tool

# Alternatives

## Alternative A: Keep Assessment Logic in Core
**Rejected**: Creates tight coupling, Goodhart's Law risk, hard to extend.

## Alternative B: Build Generic "LLM Judge" Framework
**Deferred**: Too abstract. Start with concrete inspector contract, generalize later if needed.

## Alternative C: Use External Tool (Jira, Linear, etc)
**Rejected**: Violates local-first principle. External tools can consume inspector outputs via adapters.

# Acceptance Criteria

- [ ] ADR-00XX created documenting Inspector Pattern principles
- [ ] Query Surface API specification defined (audit, snapshot, constellation, workitem.query, doc.resolve)
- [ ] Evidence attachment standard documented with examples
- [ ] Inspector Agent Contract documented (input/output schemas)
- [ ] At least one query API implemented with JSON output format
- [ ] Reference inspector agent prototype created (health/ideas or reviewer)
- [ ] AGENTS.md updated with inspector pattern guidance
- [ ] Integration examples documented in SKILL.md

# Risks / Dependencies

**Risks**:
- **Scope creep**: Inspector pattern could expand to full plugin system
  - Mitigation: Start narrow (query surface only), defer hooks/plugins
- **Performance**: Query APIs might be slow for large backlogs
  - Mitigation: Use existing index infrastructure, add pagination
- **Adoption**: External agents might not use inspector contract
  - Mitigation: Provide reference implementation, clear examples

**Dependencies**:
- Existing audit/snapshot/constellation primitives (partially implemented)
- SQLite index infrastructure (experimental but usable)
- JSON serialization for all core models

**Blockers**:
- None currently identified

# Worklog

2026-01-22 08:51 [agent=antigravity] Created item
2026-01-22 08:51 [agent=antigravity] Filled in Context, Goal, Approach, Acceptance Criteria based on GPT-5.2 feedback about inspector pattern and query surface architecture
2026-01-22 08:56 [agent=antigravity] [model=unknown] Created ADR-0037 documenting Inspector Pattern architecture. Updated AGENTS.md and ADR-0013 with cross-references.
2026-01-22 11:15 [agent=antigravity] [model=unknown] Revised ADR-0037 to document existing API inventory and align with current architecture. Changed from abstract API design to building on existing snapshot/workitem/topic modules.