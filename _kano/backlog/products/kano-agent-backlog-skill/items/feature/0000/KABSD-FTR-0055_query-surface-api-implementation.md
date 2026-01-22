---
area: general
created: '2026-01-22'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-FTR-0055
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-EPIC-0011
priority: P0
state: Proposed
tags:
- inspector-pattern
- api
- query-surface
title: Query Surface API Implementation
type: Feature
uid: 019be330-1e3d-7612-8571-a74df6a5b02c
updated: '2026-01-22'
---

# Context

**Parent Epic**: KABSD-EPIC-0011 (Inspector Pattern: External Agent Query Surface)

**Problem**: External inspector agents need a reliable, deterministic API to query backlog state without hardcoding knowledge of file formats or directory structures.

**Current State (Inventory of Existing APIs)**:

| Component | Ops Function | CLI Command | JSON Output | Status |
|-----------|--------------|-------------|-------------|--------|
| **Snapshot** | `snapshot.generate_pack()` → `EvidencePack` | `kano-backlog snapshot` | ✅ `pack.to_json()` | **Implemented** |
| **Audit** | `release_check.run_phase1/2()` → `PhaseReport` | `kano-backlog release check` | ⚠️ Markdown only | **Partial** |
| **Doctor** | Various health checks | `kano-backlog doctor` | ⚠️ Plain text | **Partial** |
| **Workitem List** | `workitem.list_items()` → `List[BacklogItem]` | `kano-backlog item list` | ✅ `--format json` | **Implemented** |
| **Workitem Read** | `workitem.get_item()` → `BacklogItem` | `kano-backlog workitem read` | ✅ `--format json` | **Implemented** |
| **Workitem Validate** | `workitem.validate_ready()` → `ValidationResult` | `kano-backlog workitem validate` | ✅ `--format json` | **Implemented** |
| **Topic Decision-Audit** | `topic.decision_audit()` | `kano-backlog topic decision-audit` | ✅ `--format json` | **Implemented** |
| **Topic Export** | `topic.export_context()` | `kano-backlog topic export-context` | ✅ `--format json` | **Implemented** |
| **Constellation** | Not implemented | Not implemented | N/A | **Missing** |
| **Doc Resolve** | Not implemented | Not implemented | N/A | **Missing** |

**Gap Analysis**:
1. Evidence attachments (file paths, line ranges) are inconsistent across APIs
2. Constellation (relationship graph) not implemented
3. Doc.resolve (structured excerpts) not implemented
4. No unified Evidence schema for cross-API consistency

# Goal

**Enhance existing Query Surface APIs** for inspector agent consumption:

1. **Standardize evidence format** across all existing query APIs
2. **Add JSON output** to audit/doctor commands (currently plain text)
3. **Implement constellation** (relationship graph with parent/child/blocks/relates)
4. **Implement doc.resolve** (parse item, extract structured sections with line numbers)
5. **Define unified Evidence schema** (file_path, line_range, item_id, timestamp)

**Build on existing patterns** - don't create new module structure:
- Ops functions in `kano_backlog_ops/*.py`
- CLI commands in `kano_backlog_cli/commands/*.py`
- Models in `kano_backlog_core/models.py`

# Non-Goals

- NOT creating a new `query` subcommand group (use existing command structure)
- NOT replacing existing APIs (enhance them with evidence fields)
- NOT building inspector agents (separate feature KABSD-FTR-0056)
- NOT changing file-first architecture (query APIs are read-only views)

# Approach

## Phase 1: Evidence Schema (Low Effort)

Define standard evidence attachment schema in `kano_backlog_core/models.py`:

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

## Phase 2: Enhance Existing APIs (Medium Effort)

### 2a. Add JSON to audit/doctor (release_check.py, doctor.py)
- Add `--format json` option to `kano-backlog doctor`
- Add `--format json` option to `kano-backlog release check`
- Return structured report with evidence attachments

### 2b. Add evidence fields to snapshot (snapshot.py)
- `EvidencePack` already has structure, enhance with:
  - `StubEntry`: already has file + line (good!)
  - `CapabilityEvidence`: add file_path reference
  - `HealthCheck`: add evidence list

### 2c. Add evidence to workitem results (workitem.py)
- `list_items()`: Add file_path to each returned BacklogItem
- `validate_ready()`: Add line_range for missing sections
- Already partially done (`item.file_path` exists)

## Phase 3: Implement Missing APIs (Medium Effort)

### 3a. Constellation (relationship graph)
- New function: `constellation.build(seed_id, depth=2)` in `kano_backlog_ops/constellation.py`
- Traverse parent/child/blocks/relates links
- Return structured graph (nodes, edges, metadata)
- CLI: `kano-backlog constellation build --seed KABSD-TSK-0042 --depth 2 --format json`

### 3b. Doc Resolve (structured excerpts)
- New function: `doc_resolve.resolve(item_id)` in `kano_backlog_ops/doc_resolve.py`
- Parse markdown, extract sections with line numbers
- Return structured document with anchors
- CLI: `kano-backlog workitem resolve --id KABSD-TSK-0042 --format json`

## Phase 4: Documentation (Low Effort)

- Update SKILL.md with Inspector Pattern usage
- Add examples in `references/inspector-integration.md`
- Document evidence schema contract

# Alternatives

## Alternative A: Create new `query` subcommand group
**Rejected**: Adds unnecessary abstraction layer. Existing command structure is sufficient. Inspectors can call existing commands with `--format json`.

## Alternative B: Create unified query.py module
**Rejected**: Would duplicate existing ops functions. Better to enhance existing modules with evidence support.

## Alternative C: GraphQL/REST API
**Deferred**: CLI with JSON output is sufficient for MVP. Can add HTTP layer later if needed.

# Acceptance Criteria

- [ ] Evidence schema defined in `kano_backlog_core/models.py`
- [ ] `kano-backlog doctor` supports `--format json` with structured output
- [ ] `kano-backlog release check` supports `--format json` with structured output
- [ ] `EvidencePack` enhanced with consistent evidence attachments
- [ ] `constellation.build()` implemented with JSON output
- [ ] `kano-backlog constellation build` CLI command added
- [ ] `doc_resolve.resolve()` implemented with structured excerpts
- [ ] `kano-backlog workitem resolve` CLI command added
- [ ] All APIs include file_path + line_range in evidence
- [ ] Documentation updated (SKILL.md, references/)

# Risks / Dependencies

**Dependencies**:
- Existing ops functions in `kano_backlog_ops/` (stable)
- BacklogItem model in `kano_backlog_core/models.py` (stable)
- CLI structure in `kano_backlog_cli/` (stable)
- SQLite index for constellation traversal (experimental but usable)

**Risks**:
- Constellation performance for large backlogs with deep traversal
  - Mitigation: Default depth=2, use index for parent/child lookup
- Evidence schema evolution
  - Mitigation: Start minimal, version the schema

# Worklog

2026-01-22 08:52 [agent=antigravity] Created item
2026-01-22 08:52 [agent=antigravity] Filled in Context, Goal, Approach, Acceptance Criteria for query surface API implementation
2026-01-22 11:15 [agent=antigravity] [model=unknown] Revised to align with existing architecture. Inventoried existing APIs (snapshot, workitem, topic). Changed approach from creating new query module to enhancing existing ops with evidence schema. Removed export.bundle (topic export-context covers this).