---
id: ADR-0037
uid: 019be334-a8b2-7f91-8d4a-5e8f9c3d1a42
title: "Inspector Pattern and Query Surface Architecture"
status: Accepted
date: 2026-01-22
related_items: ["KABSD-EPIC-0011", "KABSD-FTR-0055"]
supersedes: null
superseded_by: null
---

# Decision

**The kano-agent-backlog-skill will adopt an "Inspector Pattern" architecture where:**

1. **Skill Core = Query Surface**: Provides deterministic, evidence-based data extraction APIs
2. **External Agents = Inspectors**: Consume query surface, produce conclusions with evidence trails
3. **Evidence-First**: Every conclusion must cite traceable sources (file paths, line ranges, IDs)
4. **Read-Only Contract**: Inspectors query canonical SoT, never write to it directly

**This means**:
- All "expert judgment" (health assessment, review, refactor suggestions) lives in **external agents**
- Core skill provides only **deterministic data + derived artifacts** (audit, snapshot, constellation, indexes)
- Inspector agents are **replaceable** (any agent can implement the contract)
- All inspector outputs must include **evidence attachments** (no unsourced claims)

# Context

## Problem Statement

**Origin**: GPT-5.2 feedback on backlog discipline and architecture (2026-01-22)

Current risk: encoding "judgment" (health assessment, review suggestions, refactor recommendations) into core skill logic creates:

1. **Goodhart's Law risk**: Metrics become targets, lose meaning when hardcoded
2. **Tight coupling**: Expert logic hardcoded into skill core, hard to extend/replace
3. **Limited extensibility**: Can't swap assessment strategies without modifying core
4. **Inconsistent evidence**: Conclusions without traceable sources

## Key Insight from GPT-5.2

> "Backlog skill's responsibility: provide all tools for agents to reliably acquire information, not hardcode judgment into core."

**Analogy**: 
- Skill = Database with query API
- Inspector Agents = Analytics tools that consume the database
- Evidence = Structured citations (table/row/column refs)

## Current State

**What exists**:
- Audit primitives (rule checking, gap detection)
- Snapshot generation (state summaries)
- Constellation (relationship graphs)
- SQLite index for fast queries

**What's missing**:
- Formal Inspector Pattern contract
- Unified query surface with JSON output
- Evidence attachment standards
- Reference inspector implementation

## Related Work

- **3+3 questions** (health/ideas assessment): Proposed feature, now reframed as inspector agent
- **Decision audit/write-back**: Implemented ad-hoc, needs formalization
- **External agent integration**: No contract defined

# Architecture

## Principle A: Core = Data + Derived Artifacts (Deterministic)

**Core Responsibilities** (all deterministic, repeatable):

| Component | Purpose | Output |
|-----------|---------|--------|
| `audit.run()` | Rules enforcement (Ready gate, schema validation) | Findings with IDs, categories, severity |
| `snapshot.build()` | Current state extraction (item counts, distributions) | Timestamped state summary |
| `constellation.build()` | Relationship graph (parent/child, blocks, relates) | Graph with nodes, edges, metadata |
| `index` | Search acceleration (FTS, embedding, graph) | Query results with relevance scores |

**Key**: No "expert opinion" - only facts derived from canonical files.

## Principle B: External Agents = Inspectors (Replaceable)

**Inspector Types** (all external to core):

| Inspector | Purpose | Example Output |
|-----------|---------|----------------|
| **Health/Ideas** | 3+3 questions, gap analysis, anti-patterns | "5 items missing Context field (AF-001, AF-002...)" |
| **Reviewer** | Code review suggestions, best practices | "Consider extracting common logic (evidence: L45-67)" |
| **Architect** | Refactoring recommendations, design improvements | "Detected circular dependency (items: X, Y, Z)" |
| **Security** | Threat model, vulnerability assessment | "Exposed secrets in item TASK-042 (file: ..., L25)" |

**Key**: These are separate processes/agents, not core modules.

## Principle C: Evidence = First-Class Citizen

**Every inspector output MUST include**:

```json
{
  "finding_id": "F-001",
  "category": "health",
  "assessment": "Item missing required field",
  "evidence": [
    {
      "type": "item",
      "item_id": "KABSD-TSK-0042",
      "file": "_kano/backlog/items/task/0000/KABSD-TSK-0042.md",
      "line_range": [25, 30],
      "field": "Context",
      "issue": "Empty or missing"
    }
  ],
  "timestamp": "2026-01-22T08:51:00Z",
  "agent": "health-inspector-v1"
}
```

**No evidence = rejected or downgraded.**

## Inspector Agent Contract

### Query Surface API (Existing + Planned)

**Existing APIs (already implemented):**

| Ops Function | CLI Command | JSON Support | Notes |
|--------------|-------------|--------------|-------|
| `snapshot.generate_pack()` | `kano-backlog snapshot` | ✅ `pack.to_json()` | Returns EvidencePack with stubs, capabilities, health |
| `workitem.list_items()` | `kano-backlog item list` | ✅ `--format json` | Filters: type, state, parent, tags |
| `workitem.get_item()` | `kano-backlog workitem read` | ✅ `--format json` | Single item with full metadata |
| `workitem.validate_ready()` | `kano-backlog workitem validate` | ✅ `--format json` | Ready gate validation |
| `topic.decision_audit()` | `kano-backlog topic decision-audit` | ✅ `--format json` | Decision write-back audit |
| `topic.export_context()` | `kano-backlog topic export-context` | ✅ `--format json` | Topic context bundle |

**Planned APIs (to implement in KABSD-FTR-0055):**

| Ops Function | CLI Command | Status | Notes |
|--------------|-------------|--------|-------|
| `release_check.run_phase1/2()` | `kano-backlog release check` | ⚠️ Markdown only | Need `--format json` |
| Various health checks | `kano-backlog doctor` | ⚠️ Plain text | Need `--format json` |
| `constellation.build()` | `kano-backlog constellation build` | ❌ Missing | Relationship graph |
| `doc_resolve.resolve()` | `kano-backlog workitem resolve` | ❌ Missing | Structured excerpts |

**Evidence Schema (to standardize across all APIs):**

```python
@dataclass
class Evidence:
    """Traceable source for inspector findings."""
    type: str           # "item", "adr", "file", "audit_finding"
    id: str             # Item/ADR ID or finding ID
    file_path: str      # Relative path from backlog root
    line_range: Optional[Tuple[int, int]] = None  # Start, end lines
    excerpt: Optional[str] = None  # Text snippet
    timestamp: Optional[str] = None
```

### Inspector Output Contract

**Standard output schema**:

```json
{
  "inspector": "health-ideas-v1",
  "agent": "antigravity",
  "timestamp": "2026-01-22T08:51:00Z",
  "query_params": {
    "window": "7d",
    "filters": {}
  },
  "findings": [
    {
      "finding_id": "F-001",
      "category": "health",
      "question": "Are items well-formed?",
      "assessment": "5 tasks missing Context field",
      "severity": "warning",
      "evidence": [
        {
          "type": "audit_finding",
          "audit_finding_id": "AF-001",
          "item_id": "KABSD-TSK-0042",
          "file": "_kano/backlog/items/task/0000/KABSD-TSK-0042.md",
          "line_range": [25, 30],
          "field": "Context",
          "issue": "Empty"
        }
      ]
    }
  ],
  "summary": {
    "total_findings": 12,
    "by_severity": {"error": 0, "warning": 5, "info": 7}
  }
}
```

**Required fields**:
- `inspector`: Inspector identity (name + version)
- `agent`: Which agent ran the inspector
- `timestamp`: When inspection occurred
- `findings`: Array of findings, each with `evidence`
- `evidence`: Array of traceable sources with file paths + line ranges

## Integration Patterns

### Pattern 1: Manual Invocation

```bash
# Human asks agent to run inspector
User: "Check backlog health and show me the report"

# Agent executes
$ kano-backlog query snapshot --format json > snapshot.json
$ health-inspector --input snapshot.json --output report.json
$ cat report.json
```

### Pattern 2: CI Integration

```yaml
# .github/workflows/backlog-health.yml
- name: Check backlog health
  run: |
    kano-backlog query snapshot --format json > snapshot.json
    health-inspector --input snapshot.json --output report.json
    if grep -q '"severity": "error"' report.json; then exit 1; fi
```

### Pattern 3: Agent Self-Assessment

```
Agent: "I'm stuck. Let me consult the inspector..."
Agent: <runs inspector, gets findings>
Agent: "Inspector found 3 items blocking my work (evidence: ...)"
```

## Where Inspectors Live

**Options**:

1. **Separate skill**: `kano-inspector-health-ideas-skill/` (recommended)
   - Pro: Replaceable, versionable, independent lifecycle
   - Con: Extra installation step

2. **Reference implementation in core skill**: `examples/inspectors/health.py`
   - Pro: Batteries-included for demos
   - Con: Risk of coupling if not disciplined

3. **External repository**: Community-maintained inspectors
   - Pro: Maximum flexibility
   - Con: Discovery problem

**Recommendation**: Start with (2) for reference, encourage (1) for production use.

# Consequences

## For Skill Developers

1. **Must separate data from judgment**:
   - ✅ Good: `audit.run()` returns list of "missing Context field" findings
   - ❌ Bad: `audit.run()` returns "backlog health is poor" conclusion

2. **Must provide evidence attachments**:
   - All query APIs return structured data with file paths, line ranges, IDs
   - No APIs that return "summary strings" without evidence

3. **Must document query surface**:
   - Inspector contract is a public API, needs versioning and docs

## For Inspector Agents

1. **Must consume query surface, not parse files directly**:
   - ✅ Good: Call `workitem.query(filters={...})` API
   - ❌ Bad: Parse `_kano/backlog/items/**/*.md` directly

2. **Must attach evidence to all findings**:
   - Every conclusion cites file path + line range (or stable anchor)
   - No "I think X" without "because I saw Y at Z"

3. **Are replaceable**:
   - Any agent can implement inspector contract
   - Multiple inspectors can coexist (health, review, security, etc)

## For End Users (Humans)

1. **Inspector frequency is use-case specific**:
   - NOT "run daily" (avoid Goodhart's Law)
   - Run when: manual request, CI gate, agent stuck, pre-release audit

2. **Inspector outputs are recommendations, not commands**:
   - Human decides which findings to act on
   - Agent may propose fixes but doesn't auto-apply

3. **Evidence trail enables trust**:
   - Every finding cites sources
   - Human can verify inspector claims

# Migration Strategy

## Phase 1: Define Contract (ADR + Documentation)
- [x] Create this ADR
- [ ] Document query surface API spec
- [ ] Document inspector output schema
- [ ] Update ADR-0013 (Module Boundaries) with inspector pattern section

## Phase 2: Implement Query Surface (KABSD-FTR-0055)
- [ ] Add JSON output to existing audit/snapshot/constellation
- [ ] Implement `workitem.query` API
- [ ] Implement `doc.resolve` API
- [ ] Implement `export.bundle` API
- [ ] Add CLI commands under `kano-backlog query`

## Phase 3: Reference Inspector (KABSD-FTR-0056)
- [ ] Build health/ideas inspector as reference implementation
- [ ] Validate inspector contract through real usage
- [ ] Document integration patterns

## Phase 4: Documentation & Tooling
- [ ] Update AGENTS.md with inspector pattern guidance
- [ ] Add inspector examples to SKILL.md
- [ ] Create inspector scaffolding tool (optional)

# Alternatives Considered

## Alternative A: Keep Assessment Logic in Core

**Approach**: Encode health checks, review logic, etc directly in skill core.

**Rejected because**:
- Creates tight coupling (hard to extend/replace)
- Goodhart's Law risk (metrics become targets when hardcoded)
- No separation of concerns (data vs judgment)

## Alternative B: Build Generic "LLM Judge" Framework

**Approach**: Create abstract framework for LLM-based assessment.

**Deferred because**:
- Too abstract for initial implementation
- Start concrete (inspector contract), generalize later if needed
- Risk of over-engineering

## Alternative C: Use External Tool (Jira, Linear, etc)

**Approach**: Export to external PM tool, use their analytics/dashboards.

**Rejected because**:
- Violates local-first principle
- External tools can consume inspector outputs via adapters (future work)
- We control the query surface, not the external tool

# Related

- [[KABSD-EPIC-0011]]: Inspector Pattern: External Agent Query Surface (parent epic)
- [[KABSD-FTR-0055]]: Query Surface API Implementation
- [[KABSD-FTR-0056]]: Inspector Agent Reference Implementation
- [[ADR-0013]]: Codebase Architecture and Module Boundaries (will add inspector pattern section)
- [[ADR-0004]]: File-First Architecture with SQLite Index (complements this ADR)

# Status

**Accepted** (2026-01-22)

This ADR establishes the architectural direction. Implementation will occur in phases via linked feature work items.
