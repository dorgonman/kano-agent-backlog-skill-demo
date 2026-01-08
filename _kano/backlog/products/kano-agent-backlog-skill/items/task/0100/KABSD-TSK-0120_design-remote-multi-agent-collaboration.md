---
id: KABSD-TSK-0120
uid: 019b985b-2447-7067-b019-7bfb3f465322
type: Task
title: "Design remote multi-agent collaboration"
state: Done
priority: P2
parent: KABSD-FTR-0020
area: collaboration
iteration: null
tags: ["multi-agent", "remote"]
created: 2026-01-07
updated: 2026-01-08
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

Remote multi-agent collaboration introduces synchronization, consistency, and security considerations. We need a model that preserves local-first/SSOT principles while enabling remote claim/lease, coordination, and derived data queries.

This mode assumes a server facade exists (HTTP/MCP) that brokers reads/writes to the canonical store.

# Goal

- Define remote collaboration workflows, consistency guarantees, and boundaries.
- Specify how claims/leases operate remotely and how conflicts are detected/avoided.
- Outline minimal transport options (HTTP/MCP) and safe write policies.

# Non-Goals

- Build the full remote server implementation.
- Solve internet-facing routing and zero-trust in one step.

# Approach

1. Describe remote claim/lease semantics and audit requirements.
2. Define SSOT and write-through rules (files remain canonical; DB as cache/index).
3. Propose minimal transport and auth expectations for local dev containers.
4. Call out sync/merge cadence, and failure modes (network splits).

## Remote Mode Model

### Consistency Boundaries (MVP)

- SSOT remains canonical markdown in the server’s backing store (or a single authoritative repo checkout).
- Derived DB is a cache/index only; it is rebuildable at any time.
- Writes are serialized per item by server-side lease enforcement.
- Reads may be eventually consistent with respect to derived index refresh (acceptable for MVP).

### Claim/Lease Semantics

Lease is enforced by the server and recorded in the item for auditability.

- Acquire lease: `lease.acquire(item_id, agent, ttl_seconds)`
- Renew lease: `lease.renew(lease_id)`
- Release lease: `lease.release(lease_id)`

Rules:

- One active lease per item.
- Lease has TTL; if not renewed, it expires.
- Server records claim/release as Worklog entries and/or in a dedicated lease registry (derived).

### Conflict Detection

Remote write operations include a precondition token so the server can reject stale writes.

- Use one of:
  - `updated` timestamp compare (simple)
  - file hash/ETag compare (preferred)

If precondition fails:

- Return conflict with current item snapshot.
- Client must re-read, reconcile, and retry.

### Safe Write Policies

To reduce split-brain and corruption risk:

- No direct arbitrary filesystem writes from remote clients.
- All writes are constrained to core operations:
  - create item
  - update item fields
  - transition state
  - append worklog
- Optionally allow `force` only for admin role.
- Sandbox isolation (if enabled) restricts writes to authorized sandboxes only.

### Failure Modes & Mitigations

- Network split / client offline: leases expire; offline clients must re-acquire before writing.
- Server crash: leases stored durably (derived DB or file) or conservatively treated as expired on restart.
- Concurrent edits: prevented by lease + precondition token.

## Invariants

- Canonical files stay the SSOT.
- Worklog is append-only; remote operations must never rewrite history.
- Every remote write is audited (agent attribution + timestamp + operation metadata).

# Alternatives

- Make DB the master (violates local-first principle).

# Acceptance Criteria
- Written remote workflow exists with consistency boundaries.
- Claim/lease and conflict avoidance are documented for remote mode.
- Minimal transport expectations are defined for MVP.

# Risks / Dependencies

- Split-brain risk if writes are not constrained.
- Auth/log redaction must be addressed early.
- Coordination layer and server facades must align.

# Worklog

2026-01-07 20:07 [agent=copilot] Created to define remote workflows, synchronization, claim/lease, and consistency guarantees.
2026-01-08 00:10 [agent=copilot] Documented remote consistency boundaries, server-enforced leases, conflict detection, and safe write policies.
2026-01-08 07:24 [agent=copilot] Documented remote collaboration model: consistency boundaries, server-enforced leases with TTL, conflict detection, safe write policies, and invariants
