---
id: ADR-0003
title: "Identifier strategy: sortable IDs without centralized allocation"
status: Accepted
date: 2026-01-05
related_items: [KABSD-FTR-0001, KABSD-FTR-0007]
supersedes: null
superseded_by: null
---

# Decision

Keep the backlog **file-first** (Markdown files in repo as the source of truth) and avoid requiring a
centralized server for identifier allocation.

Adopt a **hybrid identifier strategy**:

- `uid` is the immutable primary key (globally unique). Pick **one**: ULID or UUIDv7 (TBD).
- `id` is a human-readable display ID (sortable, short), and **may collide** across machines/branches.
- Filenames must include `uidshort` to avoid git `add/add` conflicts when `id` collides.
- Any reference resolution using `id` must go through a resolver that can disambiguate.

# Context

A strictly increasing counter (ID from 0..N) is convenient for sorting and scanning, but in a
local-first workflow it becomes hard to guarantee uniqueness across machines/agents without either:

- a centralized allocator (service/server/lock), or
- coordination rules that prevent concurrent creation.

Using only UUIDs avoids collisions but loses the natural sortable sequence in filenames and dashboards.
We want to preserve "human-first" readability while keeping future options open for distributed collaboration.

# Requirements

- Multiple agents/machines can create items concurrently without a shared allocator.
- References should remain stable across renames/renumbers and across derived indexes (SQLite, embeddings).
- Agents should be able to answer "next / what to do next" and support triage using indexes.

# Options Considered

1) **Centralized ID allocator** (server or shared lock file)
2) **UUID-only IDs** (globally unique, not naturally ordered)
3) **Time-sortable unique IDs** (ULID / UUIDv7)
4) **Hybrid IDs**: keep sortable `id` + add immutable `uid`

# Pros / Cons

- Option 1: strongest uniqueness; introduces infrastructure and single-point-of-failure; violates local-first.
- Option 2: simplest uniqueness; hurts readability and natural ordering.
- Option 3: unique + sortable; still less human-friendly than short sequential IDs; ecosystem differences.
- Option 4: keeps human-friendly filenames while enabling reliable uniqueness for merging/indexing; adds complexity.

# Consequences

- The default workflow remains file-first and Obsidian-friendly.

## Work item frontmatter (minimum)

This is the target schema for distributed-safe identifiers (migration required; not implemented everywhere yet):

- Required:
  - `uid`: string (ULID or UUIDv7; immutable; unique)
  - `id`: string (display ID; sortable; allowed to collide)
  - `type`, `title`, `status/state`, `priority`, `created`, `updated`
- Recommended:
  - `tags`
  - `parent_uid` (references use `uid` to avoid ambiguity)
  - `links_uid` (same)
  - `aliases` (optional; for legacy IDs or future renumbering)

## Filename and path

To avoid git `add/add` conflicts when two branches create the same display `id`, filenames must be unique:

- Recommended format: `<id>__<uidshort>_<slug>.md`
- Example: `KANO-000123__01KE72EH4N_implement-backlog-indexing.md`

`uidshort` is a stable prefix (fixed length) derived from `uid`:

- ULID: prefix of the ULID (timestamp portion is convenient)
- UUIDv7: prefix of the hex string (length TBD, e.g. 8-12)

## Resolver semantics (reference handling)

Tools must implement `ResolveRef(ref)`:

- If `ref` is a full `uid` → unique match.
- If `ref` is a `uidshort` → resolve via index (`uidshort -> uid`). If multiple matches, list candidates.
- If `ref` is a display `id` (e.g. `KANO-000123`) → resolve via index (`id -> [uid...]`):
  - one match: return it
  - multiple matches: list candidates for human selection (type/status/title/path/created/updated).

Recommended human-friendly reference format to reduce ambiguity:

- `KANO-000123@01KE72EH4N` (display id + uidshort)

## Index implications

Derived indexes must support:

- `uid -> path`
- `uidshort -> uid`
- `id -> [uid...]` (note: potentially multiple)

## What-next behavior (agent workflow)

When asked "next / what to do next":

- Prefer continuing items in progress.
- Otherwise pick from ready items (e.g. 3-5), ordered by priority then recency/parent context.
- Output should include `id@uidshort`, title, type, status/state, priority, and a first actionable step.

# Open Questions / Follow-ups

- Choose ULID vs UUIDv7 (sorting, readability, library support, collision safety, short-prefix length).
- Migration plan for existing `id`-only items (add `uid`, update filenames, update parent/link references).
- Should we store both `parent` (id) and `parent_uid` during migration, or hard cutover to `uid`?
- Add a collision report (group by display `id`) and a resolver UI/CLI for disambiguation.
