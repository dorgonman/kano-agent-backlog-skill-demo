---
id: KABSD-TSK-0122
uid: 019b9882-6a04-7caf-8ccd-6067a9747205
type: Task
title: "Design config schema for data backend abstraction (canonical vs derived)"
state: Proposed
priority: P1
parent: KABSD-FTR-0019
area: architecture
iteration: null
tags: ["config", "data-backend", "canonical", "derived"]
created: 2026-01-07
updated: 2026-01-07
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
---

# Context

For server/cloud modes and future extensibility, we need a config schema that abstracts data backends beyond just "files + optional index." The key distinction is:

- **CanonicalStore** (source of truth): LocalFile (markdown), or potentially SQLite (versioned in Git), or remote DB (write-through mode).
- **DerivedStore** (index/cache): SQLite/Postgres/MySQL as query accelerators; rebuildable from canonical.

Current config has `index.backend` but doesn't capture whether the backend is canonical or derived. If SQLite is the canonical store, it must be versioned; if it's derived, it can be gitignored and rebuilt.

# Goal

- Design a config schema that supports:
  - `data.canonical.backend`: `LocalFile` | `SQLite` | `Postgres` | `MySQL`
  - `data.canonical.path` or `data.canonical.connection_string`
  - `data.derived.backend`: `SQLite` | `Postgres` | `MySQL` | `None`
  - `data.derived.path` or `data.derived.connection_string`
- Clarify semantics: what happens when canonical is SQLite vs LocalFile.
- Define validation rules and backward compatibility with current `index.*` config.

# Non-Goals

- Implement the full abstraction layer; focus on schema design.
- Migrate existing data; only define the config contract.

# Approach

1. Propose a config schema (JSON snippet) with `data.canonical` and `data.derived` sections.
2. Document the invariants:
   - Canonical is always source of truth; writes go here first.
   - Derived can be rebuilt from canonical at any time.
   - If canonical is LocalFile, derived is optional index (current behavior).
   - If canonical is SQLite (versioned), derived could be Postgres for remote query acceleration.
3. **SQLite separation decision**: When both canonical and derived are SQLite, they MUST be separate files:
   - **Canonical SQLite**: versioned in Git (e.g., `data/canonical.db`), stable schema, write-focused.
   - **Derived SQLite**: gitignored (e.g., `_index/derived.db`), query-optimized, rebuildable.
   - Rationale: different version control policies, schema evolution, read/write isolation, future extensibility (easy swap to Postgres/MySQL).
4. Propose path conventions:
   - Canonical: `<backlog-root>/data/canonical.db` (or `items/` for LocalFile)
   - Derived: `<backlog-root>/_index/derived.db`
5. Define backward compatibility mapping from `index.*` to new schema.
6. List validation rules (e.g., can't have both canonical=Postgres and derived=None in local-first mode).

# Alternatives

- Keep `index.*` and add `canonical_backend` separately (less cohesive).
- Assume files are always canonical and DB is always derived (limits flexibility).
- **Merge canonical and derived into one SQLite file** (rejected):
  - Pros: simpler file management.
  - Cons: version control confusion (cache churn pollutes Git history), schema conflicts, cannot optimize independently, higher corruption risk, harder to migrate derived to Postgres/MySQL later.

# Acceptance Criteria

- A proposed config schema exists with clear semantics for canonical vs derived backends.
- Invariants and validation rules are documented.
- Backward compatibility strategy is described.
- Examples are provided for common scenarios:
  - LocalFile canonical + SQLite derived (current default)
  - SQLite canonical + Postgres derived (future cloud acceleration)
  - Postgres canonical + no derived (write-through mode; non-local-first)

# Risks / Dependencies

- Semantic confusion between canonical and derived; requires clear docs.
- SQLite-as-canonical versioning strategy (how to handle schema migrations in Git).
- Backward compatibility breakage if not carefully planned.

# Worklog

2026-01-07 20:50 [agent=copilot] Created to evaluate config schema for LocalFile/SQLite/Postgres/MySQL backends; distinguish source-of-truth vs index.
2026-01-07 21:00 [agent=copilot] Updated Approach: added SQLite separation decision (canonical vs derived must be separate files with different version control policies).
