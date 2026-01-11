# Kano Agent Backlog Skill: System Status & Protocol Draft

**Document Type**: Comprehensive Status Summary + Protocol Specification  
**Generated**: 2026-01-10  
**Version**: 0.0.2-alpha  
**Audience**: Contributors, integrators, and agent developers

---

## Executive Summary

**Kano Agent Backlog Skill** is a local-first, file-based backlog management system designed to turn ephemeral agent collaboration into durable engineering assets with an auditable decision trail. Instead of losing context in chat, it captures trade-offs, decisions, and acceptance criteria in structured Markdown files tracked in Git.

**Current Architecture**:
- **234 work items** across 2 products (kano-agent-backlog-skill, kano-commit-convention-skill)
  - 93 New | 0 Planned | 7 InProgress | 0 Review | 134 Done
- **Multi-product monorepo** layout supporting isolated backlogs under `_kano/backlog/products/<product>/`
- **Singular folder convention**: epic/, feature/, userstory/, task/, bug/ (not plurals)
- **Process profiles**: Azure Boards Agile (kano-agent-backlog-skill), Jira Default (kano-commit-convention-skill)
- **Local-first enforcement**: No server runtime implementation yet; SQLite indexes are optional and derived-only

**Key Differentiators**:
1. **File-first architecture**: Markdown files in Git are the single source of truth; databases are rebuildable indexes
2. **Ready gate enforcement**: Tasks/Bugs cannot start until Context, Goal, Approach, Acceptance Criteria, Risks/Dependencies are complete
3. **Append-only worklog**: Never rewrite history; all decisions and state changes are auditable
4. **Agent identity protocol**: Explicit `--agent <ID>` required; no placeholders allowed
5. **Hybrid identifiers**: Human-readable `id` (KABSD-TSK-0001) + globally unique `uid` (UUIDv7) for merge-safety

---

## 🎯 Top 3 Highest ROI Next Steps

### 1. **Complete CLI Modernization (KABSD-TSK-0083)** — P1, InProgress
**Impact**: Enables product-aware execution for all 30+ scripts, unblocking multi-product workflows.

**Why Now**:
- Currently blocking: KABSD-TSK-0092 (global embeddings), KABSD-TSK-0095 (index validation)
- Required for: All future automation (views, linting, indexing) in multi-product setup
- Low risk, high leverage (standard Python refactor)

**Acceptance**: All CLI scripts use `get_product_name()` from context.py; manual testing in both kano-agent-backlog-skill and kano-commit-convention-skill products passes.

**Effort**: 1 focused session (3-4 hours)

---

### 2. **Prototype Agent Compliance Verifier (KABSD-TSK-0035)** — P1, Ready
**Impact**: Automated validation of agent workflow adherence; reduces drift and enforces discipline.

**Why Now**:
- Directly addresses core value prop: "agents write code only after capturing what/why/how"
- Builds on existing Ready gate infrastructure (schema.md, workflow.md)
- Demonstrates governance capability for future multi-agent coordination
- Can catch violations early (e.g., missing worklogs, empty sections, wrong state transitions)

**Scope**: Python script checking:
- Ready gate completeness before InProgress transition
- Worklog presence for state changes and ADR creation
- Agent identity format (`[agent=<ID>]` vs forbidden placeholders)

**Acceptance**: Script runs on demo backlog and identifies 2+ real violations; fixes validate correctly.

**Effort**: 1.5 sessions (5-6 hours including test cases)

---

### 3. **Evaluate VCS Query Cache Layer (KABSD-TSK-0110)** — P2, InProgress
**Impact**: Unlocks traceability (commit refs → worklog backfill) and reduces repeated `git log` parsing overhead.

**Why Now**:
- Enables KABSD-FTR-0017 (Traceability) and KABSD-FTR-0020 (Multi-agent collaboration modes)
- Performance gain: O(1) cache reads vs O(N) file scans for frequent commit lookups
- Architectural foundation: Defines pattern for other derived indexes (embeddings, graph)
- Low coupling: Cache is optional and rebuildable (aligns with file-first principle)

**Key Decisions**:
- Storage: SQLite table under `_kano/backlog/_index/vcs_cache.sqlite3` (not tracked in Git)
- Invalidation: Timestamp-based TTL + manual rebuild command
- Scope: commit hash → (author, date, message, files) for fast lookups

**Acceptance**: Prototype script demonstrates 10x speedup on demo backlog (30+ commits); cache rebuild completes in <1 second.

**Effort**: 1 session (3-4 hours including ADR)

---

## System Status Snapshot

### Backlog Overview

| Metric | Count | Notes |
|--------|-------|-------|
| **Total Items** | 234 | Across 2 products |
| **New** | 93 | Not started; many are P3 roadmap items |
| **Planned** | 0 | No items waiting in staging |
| **InProgress** | 7 | Active work (2 Epics, 2 Features, 1 UserStory, 2 Tasks) |
| **Review** | 0 | No items awaiting review |
| **Done** | 134 | Completed work; includes Milestone 0.0.1 |
| **Epics** | 7 total | 3 New, 2 InProgress, 2 Done |
| **Features** | 27 total | 13 New, 2 InProgress, 12 Done |
| **UserStories** | 27 total | 16 New, 1 InProgress, 10 Done |
| **Tasks** | 173 total | 61 New, 2 InProgress, 110 Done |

### InProgress Work Detail

#### Epics
- **KABSD-EPIC-0003**: Milestone 0.0.2 (Indexing + Resolver)
- **KABSD-EPIC-0004**: Roadmap (general planning container)

#### Features
- **KABSD-FTR-0009**: Backlog Artifact System (attachments, shared artifacts)
- **KABSD-FTR-0011**: Multi-product platform intelligence and governance (global indexes, analytics)

#### UserStories
- **KABSD-USR-0023**: Automated backlog realignment tool (process profile migration)

#### Tasks
- **KABSD-TSK-0083**: Update CLI scripts for product-aware execution (P1, blocked by KABSD-TSK-0082@019b93bb)
- **KABSD-TSK-0110**: Evaluate VCS Query Cache Layer (P2)

### Recent Completions (Last 7 Days)

- **KABSD-TSK-0130**: Create prerequisite installer (`install_prereqs.py`) [P1, Bug]
- **KABSD-TSK-0149**: Generate developer persona report [P2, Task]
- **KABSD-TSK-0148**: Generate QA/tester persona report [P2, Task]
- **KABSD-TSK-0147**: Generate technical lead persona report [P2, Task]
- **KABSD-TSK-0146**: Generate product manager persona report [P2, Task]
- **KABSD-TSK-0143**: Define outcome metrics schema for dispatch decisions [P2, Task]
- **KABSD-TSK-0115**: Add agent=windsurf for consistency [P3, Bug]

### Architecture Highlights

#### Multi-Product Layout
```
_kano/backlog/
├── _shared/              # Cross-product artifacts (planned)
├── products/
│   ├── kano-agent-backlog-skill/
│   │   ├── _config/      # Product-specific config
│   │   ├── _index/       # Derived SQLite indexes
│   │   ├── _meta/        # Schema, conventions
│   │   ├── items/        # Work items (epic/, feature/, userstory/, task/, bug/)
│   │   ├── decisions/    # ADRs
│   │   └── views/        # Generated dashboards
│   └── kano-commit-convention-skill/
│       └── (same structure)
```

#### Process Profiles
- **kano-agent-backlog-skill**: Azure Boards Agile (Epic → Feature → UserStory → Task/Bug)
- **kano-commit-convention-skill**: Jira Default (Epic → Story → Subtask)

#### Technology Stack
- **Python 3.8+**: All automation scripts
- **SQLite**: Optional derived indexes (rebuildable from files)
- **Markdown + YAML**: Work item format (frontmatter + body)
- **Git**: Version control and canonical storage
- **Obsidian**: Compatible views (wikilinks, dataview queries)

#### ID System (ADR-0003)
- **Display ID**: `KABSD-TSK-0001` (human-readable, sortable, may collide across repos)
- **Unique ID**: `019b8f52-9fdc-7676-ac2a-0212eed7d168` (UUIDv7, globally unique)
- **Collision-safe refs**: `KABSD-TSK-0001@019b8f52` (short uid suffix for cross-product links)
- **Filename**: `KABSD-TSK-0001_<slug>.md` (stable, ASCII slug)

#### Indexing Strategy (ADR-0004)
- **Source of Truth**: Markdown files in Git
- **Derived Indexes**: SQLite (`_kano/backlog/products/<product>/_index/backlog.sqlite3`)
- **Sync Direction**: STRICTLY one-way (File → DB)
- **Rebuild**: Always possible from files; no state loss if DB is deleted
- **Optional**: DB index is not required for basic workflow (file-first remains default)

---

## 📋 Protocol Draft: Core Concepts and Principles

### 1. Local-First Architecture

**Principle**: Files are the single source of truth; databases are derived indexes.

**Invariants**:
- All work items, ADRs, and metadata are stored as Markdown files in Git
- SQLite/FTS/embeddings are **optional** accelerators, never the system of record
- Any derived index can be deleted and rebuilt from files without data loss
- Offline-first: Core workflow (create, update, validate) works without network or database

**Rationale**: Git-native storage ensures diff, merge, blame, and portability work out-of-the-box. No server dependency for basic collaboration.

**Trade-offs**:
- ✅ Zero infrastructure dependency (no database server)
- ✅ Text-based diffs and conflict resolution
- ⚠️ Full-text search requires scanning files (O(N)) unless index is enabled
- ⚠️ Cross-product aggregation needs manual scripts or global index

---

### 2. Naming Conventions

#### Folder Structure
- **Singular forms only**: `epic/`, `feature/`, `userstory/`, `task/`, `bug/`
- **Bucket by 100**: Items stored in `items/<type>/<bucket>/` where bucket is `0000`, `0100`, `0200`, etc.
  - Example: `KABSD-TSK-0147` → `items/task/0100/KABSD-TSK-0147_...md`

#### ID Prefix Derivation
**Algorithm**:
1. Source: `PROJECT_NAME` from config or repo name
2. Split on non-alphanumeric and camelCase boundaries
3. Take first letter of each segment
4. If <2 letters, add next consonant (skip A/E/I/O/U)
5. Uppercase result

**Examples**:
- `kano-agent-backlog-skill-demo` → **KABSD**
- `my-backlog` → **MB**
- `ProjectAlpha` → **PA**

#### Filename Format
```
<ID>_<slug>.md
```
- **ID**: Display ID (e.g., `KABSD-TSK-0001`)
- **Slug**: ASCII, hyphen-separated, lowercase
- **Stability**: Filenames never change after creation

**Epic MOC**: Adjacent `<ID>_<slug>.index.md` for Map of Content

---

### 3. Hierarchy and Parent Rules

**Default Hierarchy** (Azure Boards Agile):
```
Epic
 ├─ Feature
 │   ├─ UserStory
 │   │   ├─ Task
 │   │   └─ Bug
 │   └─ Bug (direct)
 └─ (no parent)
```

**Parent Constraints**:
- Parent must be from the **same product** (intra-product only)
- Cross-product relationships use `links.relates` / `links.blocks` / `links.blocked_by`
- Sub-tasks allowed: Task → Task (optional)

**Validation**: `workitem_update_state.py` aborts if parent is unresolved or ambiguous within product.

---

### 4. Workflow Gates and State Transitions

#### Ready Gate (Required Before InProgress)
**Non-empty sections**:
1. **Context**: Why this work exists
2. **Goal**: What success looks like
3. **Approach**: How to implement
4. **Acceptance Criteria**: How to verify completion
5. **Risks / Dependencies**: What could block or break

**Enforcement**: Scripts check completeness; agents must not start work until Ready.

**Rationale**: Prevents half-planned tickets; forces upfront thinking; reduces scope creep.

#### State Lifecycle
```
Proposed → Planned → Ready → InProgress → Review → Done
                                    ↓
                                 Dropped
```

**State Ownership**:
- Agent decides when to move to InProgress or Done
- Humans observe and can add context via Worklog

#### Parent State Sync (Forward-Only)
**Rules**:
- Child state changes can auto-advance parent (never downgrade)
- Ready/Planned children → parent Planned (not Ready)
- Any InProgress/Review/Blocked child → parent InProgress
- All Done → parent Done; all Dropped → parent Dropped; mix → parent Done

**Rationale**: Prevents parent/child drift; reflects real status bottom-up.

**Override**: Use `--no-sync-parent` flag when manual re-planning is needed.

---

### 5. Append-Only Worklog

**Principle**: Never rewrite history; append new entries only.

**Append Triggers**:
- State change (Proposed → Planned → Ready → InProgress → Done)
- Load-bearing decision made
- Scope/approach change
- ADR created and linked

**Format**:
```markdown
## Worklog

- [2026-01-10, agent=windsurf] Created from discussion: [link to context]
- [2026-01-11, agent=antigravity] Moved to Ready; all sections complete
- [2026-01-12, agent=windsurf] Moved to InProgress; owner set to windsurf
- [2026-01-13, agent=windsurf] Linked ADR-0015 for identifier strategy decision
- [2026-01-14, agent=windsurf] Moved to Done; verified acceptance criteria
```

**Validation**: Scripts check for `[agent=<ID>]` format; reject placeholders (`auto`, `user`, `assistant`).

---

### 6. Agent Identity Protocol

**Non-Negotiable**: All worklog entries and audit logs must include explicit agent identity.

**Format**: `[agent=<ID>]` where ID is the real product name.

**Valid Examples**:
- `[agent=cursor]`
- `[agent=copilot]`
- `[agent=windsurf]`
- `[agent=antigravity]`

**Forbidden Placeholders**:
- ❌ `auto`, `user`, `assistant`, `<AGENT_NAME>`, `$AGENT_NAME`, `[YOUR_AGENT_NAME]`

**Enforcement**: Scripts require `--agent <ID>` flag; no default value exists.

**Rationale**: Auditability requires knowing which agent made each decision; placeholders defeat the purpose.

---

### 7. File Operations and Audit Trail

**Principle**: All backlog/skill artifact operations must go through skill scripts to capture audit logs.

**Allowed Paths**:
- `_kano/backlog/` (canonical backlog)
- `_kano/backlog_sandbox/` (tests only)

**Script Categories**:
- `scripts/backlog/*`: Work item CRUD, state updates, validation
- `scripts/fs/*`: File operations (read, write, move, trash)
- `scripts/indexing/*`: SQLite/FTS/embedding index management
- `scripts/logging/*`: Audit log utilities

**Audit Log Schema** (JSONL):
```json
{
  "timestamp": "2026-01-10T14:36:22Z",
  "agent": "windsurf",
  "action": "workitem_update_state",
  "args": {"id": "KABSD-TSK-0083", "state": "InProgress"},
  "result": "success",
  "duration_ms": 124
}
```

**Redaction**: Secrets and sensitive data are stripped before logging.

---

### 8. Scope Change Discipline

**Anti-Pattern**: Rewriting a ticket into a different task.

**Correct Approach**:
1. Create new linked item (`links.relates`)
2. Append Worklog entry explaining the split
3. Keep original ticket scoped to original goal

**Rationale**: Preserves history; prevents scope creep; maintains traceability.

**Example**:
- Original: `KABSD-TSK-0100` "Add helper function X"
- Split: `KABSD-TSK-0101` "Refactor module Y" (linked via `relates`)
- Worklog: `[2026-01-10, agent=windsurf] Scope split: Y refactor extracted to KABSD-TSK-0101`

---

### 9. Conflict Prevention (Owner Locking)

**Principle**: Items in InProgress are locked to their owner.

**Rules**:
- Moving to InProgress auto-assigns current agent as owner (if unset)
- Other agents cannot modify InProgress items unless:
  - Owner changes owner field
  - Owner moves item to Review/Planned/Dropped

**Rationale**: Prevents concurrent edits; reduces merge conflicts; clear ownership.

**Future**: Claim/Lease protocol (KABSD-FTR-0016) for multi-agent coordination.

---

### 10. Process Profiles and Customization

**Principle**: Work item types, states, and transitions are defined by pluggable process profiles.

**Built-in Profiles**:
- `builtin/azure-boards-agile`: Epic → Feature → UserStory → Task/Bug
- `builtin/jira-default`: Epic → Story → Subtask

**Selection**: Config file `_kano/backlog/_config/config.json`:
```json
{
  "process": {
    "profile": "builtin/azure-boards-agile",
    "path": null
  }
}
```

**Custom Profiles**: Place JSON file anywhere; set `process.path` to absolute path.

**Migration**: `realign.py` script migrates items between profiles (type mapping + folder moves).

---

### 11. Ready Items: Sizing and Volume Control

**Sizing Guideline**: Tasks/Bugs should fit in **one focused session** (3-6 hours).

**Volume Control**:
- Only open items for actual code/design changes
- Avoid ADRs unless there's a real architectural trade-off
- Record non-load-bearing discussions in existing Worklogs (not new tickets)

**Rationale**: Prevents ticket spam; keeps backlog navigable; reduces overhead.

**Ticketing Threshold** (agent-decided):
- **Open new item** when you will change code/docs/views/scripts
- **Open ADR** when a real trade-off or direction change is decided
- **Use existing Worklog** for clarifications or minor context

---

### 12. Immutable Fields and Stability

**Immutable After Creation**:
- `id`: Display ID (e.g., `KABSD-TSK-0001`)
- `uid`: Globally unique ID (UUIDv7)
- `type`: Epic / Feature / UserStory / Task / Bug
- `created`: Timestamp (ISO 8601)

**Mutable**:
- `state`: Workflow progression
- `updated`: Auto-updated on any change
- `owner`: Can change during handoff
- `priority`: Can be reprioritized (P1/P2/P3)
- `parent`: Can change (but must remain intra-product)

**Filename Stability**: Once created, filename never changes (even if title updates).

**Rationale**: Git history and wikilinks remain valid; no broken references.

---

### 13. References and Collision Safety

#### Intra-Product References
**Format**: `KABSD-TSK-0001` (display ID only)  
**Context**: Same product; unique within product  
**Use**: `parent` field, wikilinks, worklogs

#### Cross-Product References
**Format**: `KABSD-TSK-0001@019b8f52` (display ID + short uid)  
**Context**: Across products where collisions are possible  
**Use**: `links.*` fields, cross-product traceability

**Resolver Behavior**:
- Scripts resolve `id` within current product
- If ambiguous, abort with guidance to use `id@uidshort` or full `uid`

**Rationale**: Balances human readability (short IDs) with uniqueness (uid suffix).

---

### 14. Temporary Constraint: Local-First First, No Server Yet

**Status**: **Active** (until explicitly removed by human)

**Allowed**:
- File-based canonical data design, validation, migration tooling
- Local indexing/search (SQLite/FTS/embeddings)
- CLI scripts, automation, developer tooling
- Documentation, ADRs, threat models for future server support
- **Spec-only** design of server interfaces (MCP/HTTP schemas)

**Hard Stop**:
- ❌ HTTP server, REST API, gRPC service
- ❌ MCP server (any transport)
- ❌ Web UI depending on running server
- ❌ Docker/K8s deployment for server component
- ❌ Runtime auth/authz implementation

**Spec-Only Output**:
1. ADR and/or design doc
2. Roadmap ticket proposal
3. Clear note that implementation is deferred

**Rationale**: Focus on local-first stability and usability before expanding to cloud/multi-remote.

---

## Configuration System

### Config Layers (Precedence)

1. **Environment variables** (highest)
   - `KANO_BACKLOG_CONFIG_PATH`: Override config file path
   - `KANO_AUDIT_LOG_DISABLED`: Disable audit logging
   - `KANO_AUDIT_LOG_ROOT`: Custom log directory

2. **Config file**: `_kano/backlog/_config/config.json`

3. **Defaults** (lowest):
```json
{
  "log": { "verbosity": "info", "debug": false },
  "process": { "profile": "builtin/azure-boards-agile", "path": null },
  "sandbox": { "root": "_kano/backlog_sandbox" },
  "index": { "enabled": false, "backend": "sqlite", "path": null, "mode": "rebuild" }
}
```

### Process Profile Schema

**Location**: `skills/kano-agent-backlog-skill/references/processes/<profile>.json`

**Required Fields**:
- `name`: Profile display name
- `types`: List of work item types (Epic, Feature, UserStory, Task, Bug, etc.)
  - Each type: `{ "name": "...", "slug": "...", "description": "..." }`
- `states`: List of workflow states (Proposed, Planned, Ready, InProgress, Review, Done, Dropped)
- `transitions`: Allowed state changes
- `parent_rules`: Parent-child type relationships

**Example**:
```json
{
  "name": "Azure Boards Agile",
  "types": [
    { "name": "Epic", "slug": "epic", "description": "Large milestone" },
    { "name": "Feature", "slug": "feature", "description": "Capability" }
  ],
  "states": ["Proposed", "Planned", "Ready", "InProgress", "Review", "Done", "Dropped"],
  "parent_rules": {
    "Epic": null,
    "Feature": "Epic",
    "UserStory": "Feature",
    "Task": "UserStory",
    "Bug": ["Feature", "UserStory"]
  }
}
```

---

## Derived Indexes and Performance

### SQLite Index (Optional)

**Purpose**: Accelerate queries (find by state, parent, tags) from O(N) file scans to O(log N) SQL.

**Storage**: `_kano/backlog/products/<product>/_index/backlog.sqlite3` (not tracked in Git)

**Tables**:
- `items`: Frontmatter metadata (id, uid, type, state, parent, priority, owner, created, updated)
- `tags`: Many-to-many tag relationships
- `links`: Dependency graph (relates, blocks, blocked_by)
- `decisions`: ADR linkage

**Rebuild**: `python scripts/indexing/index_db.py --rebuild`

**Sync**: One-way (File → DB); DB is never written directly.

**Trade-offs**:
- ✅ 10-100x faster queries for large backlogs (1000+ items)
- ⚠️ Adds rebuild step (1-5 seconds for 1000 items)
- ⚠️ Not portable (each contributor rebuilds locally)

---

### Full-Text Search (Planned)

**Purpose**: Semantic search across Context, Goal, Approach, Worklog.

**Storage**: SQLite FTS5 virtual table

**Usage**: `scripts/indexing/search.py "local-first architecture"`

---

### Embeddings (Planned)

**Purpose**: Vector similarity search for related items.

**Storage**: SQLite with vector extension or separate `.npy` files

**Model**: OpenAI `text-embedding-3-small` or local Sentence-BERT

**Blocked by**: KABSD-TSK-0124 (embedding model selection)

---

## Automation Scripts Reference

### Bootstrap
- `bootstrap_init_backlog.py`: Initialize backlog scaffold
- `bootstrap_seed_demo.py`: Seed demo data

### Work Item Management
- `workitem_create.py`: Create new item (Epic/Feature/UserStory/Task/Bug)
- `workitem_update_state.py`: Change state + append worklog + sync parent
- `workitem_validate.py`: Check Ready gate, parent refs, worklog format
- `workitem_attach_artifact.py`: Attach file artifact to item

### Views
- `view_generate.py`: Generate plain Markdown dashboards from files/DB
- `view_refresh.py`: Batch-refresh all configured views

### Indexing
- `index_db.py`: Rebuild SQLite index from files
- `index_embeddings.py`: Generate embeddings for all items
- `index_validate.py`: Check index consistency with files

### VCS Integration
- `vcs_query.py`: Query commit history (planned cache layer)
- `vcs_backfill_worklog.py`: Extract commit refs and backfill worklogs

### Migration
- `migrate_process.py`: Migrate items between process profiles
- `migrate_schema.py`: Apply schema version upgrades

### File System
- `fs_read.py`: Read file with audit logging
- `fs_write.py`: Write file with audit logging
- `fs_trash.py`: Move to trash bin (not delete)

---

## ADR Summary (Key Architectural Decisions)

### ADR-0001: Backlog structure and Obsidian MOC
- Use per-type folders (epic/, feature/, userstory/, task/, bug/)
- Create Epic MOCs (`<ID>.index.md`) for navigation
- Register MOCs in `_meta/indexes.md`

### ADR-0003: Identifier strategy for local-first backlog
- Hybrid IDs: human-readable `id` + globally unique `uid` (UUIDv7)
- Collision-safe refs: `id@uidshort` for cross-product links
- Filename stability: never changes after creation

### ADR-0004: File-first architecture with SQLite index
- Markdown files in Git are source of truth
- SQLite is derived index (rebuildable, not tracked)
- Sync direction: STRICTLY one-way (File → DB)
- Offline-first: core workflow works without database

### ADR-0009: Local-first embedding search strategic evaluation
- Evaluate local embedding models (Sentence-BERT, OpenAI API)
- Storage: SQLite with vector extension or numpy files
- Trade-offs: cost, privacy, performance, portability

### ADR-0011: Graph-assisted retrieval and context graph
- Use FTS/embeddings for seed nodes
- Expand via structured relationships (parent, blocks, ADRs)
- Weak graph first: no LLM entity extraction yet
- Keep everything derived/rebuildable from Markdown

---

## Testing Strategy (Planned)

### Unit Tests
- **Scope**: Individual scripts (create, update, validate)
- **Isolation**: Use `_kano/backlog_sandbox/` for test fixtures
- **Coverage**: Frontmatter parsing, state transitions, parent sync

### Integration Tests
- **Scope**: Multi-script workflows (create → update → validate → view)
- **Fixtures**: Real backlog items from demo
- **Validation**: Check worklogs, index consistency, parent propagation

### Compliance Tests
- **Scope**: Agent workflow adherence (Ready gate, worklog format, agent identity)
- **Automation**: KABSD-TSK-0035 (agent compliance verifier)

---

## Future Roadmap (Not Committed)

### Q1 2026 (Planning Phase)
- **KABSD-EPIC-0005/0006**: Multi-Agent OS Evolution (worksets, claim/lease, bid protocol)
- **KABSD-EPIC-0007**: Cloud security & access control (auth, rate limiting, tenant isolation)
- **KABSD-FTR-0018**: Server mode evaluation (MCP vs HTTP, Docker, data backend separation)

### High-Value Features (No Timeline)
- **Graph-assisted RAG**: Context expansion via parent/ADR/dependency graph
- **Global embeddings**: Cross-product semantic search
- **VCS traceability**: Commit refs → worklog backfill
- **Multi-agent coordination**: Claim/lease protocol, conflict isolation
- **Quality linter**: Automated backlog discipline enforcement

### Deferred (Spec-Only)
- **MCP/HTTP server**: Design complete; implementation blocked by Local-First Clause
- **PostgreSQL/MySQL backend**: Evaluation complete; implementation deferred
- **Web UI**: Mockups only; no runtime dependency

---

## Contributing

**Core Principle**: Don't turn this into another Jira. Keep it lightweight and human-friendly.

**Contribution Areas**:
- Process profiles for other workflows (Scrum, CMMI, Kanban)
- Improved validation scripts (language guard, link symmetry)
- Performance optimizations (indexing, caching)
- Documentation improvements (persona guides, ADR templates)

**Before Contributing**:
1. Create backlog item (Task/Bug) with full Ready gate
2. Append worklog for all decisions
3. Link ADR if architectural trade-off exists
4. Submit PR with `KABSD-TSK-XXXX: <summary>` commit format

---

## License

MIT

---

## References

- **Skill Entrypoint**: `skills/kano-agent-backlog-skill/SKILL.md`
- **Schema**: `skills/kano-agent-backlog-skill/references/schema.md`
- **Workflow SOP**: `skills/kano-agent-backlog-skill/references/workflow.md`
- **Process Profiles**: `skills/kano-agent-backlog-skill/references/processes/`
- **Demo Backlog**: `_kano/backlog/products/kano-agent-backlog-skill/`
- **GitHub**: (Repository URL if public)

---

**End of Document**
