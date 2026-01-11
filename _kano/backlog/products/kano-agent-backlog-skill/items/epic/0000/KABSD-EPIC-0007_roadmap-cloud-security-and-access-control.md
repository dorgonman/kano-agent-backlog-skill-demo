---
id: KABSD-EPIC-0007
uid: 019bac45-bf60-76c5-a35a-c1f593708a3b
type: Epic
title: "Roadmap: Cloud security & access control"
state: Proposed
priority: P1
parent: null
area: security
iteration: null
tags: ["roadmap", "cloud", "security", "auth"]
created: 2026-01-08
updated: 2026-01-08
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: ["KABSD-EPIC-0004", "KABSD-EPIC-0005", "KABSD-EPIC-0006"]
  blocks: []
  blocked_by: []
decisions: []
---

# Context

Moving from local-first usage to cloud deployment introduces security as a critical concern. Running without any safeguards may be acceptable for a private LAN / trusted environment, but becomes a serious risk when exposed to the public internet.

**Multi-Repo Coordination Challenge**: The rise of AI agent tooling has revealed a fundamental limitation in distributed repository architectures. Agent sessions (e.g., GitHub Mobile's "New Agent Session") are inherently **repo-scoped**, creating coordination friction:

- Cross-repo work requires multiple agent sessions and separate PRs
- Decision context and planning artifacts get scattered across repositories
- Atomic changes spanning multiple services become fragmented workflows
- Agent collaboration requires complex orchestration protocols

**Cloud Backlog as Coordination Layer**: A shared cloud backlog system can serve as the **coordination substrate** for multi-repo agent collaboration, providing:

- Unified planning and decision artifacts across repository boundaries
- Cross-repo dependency tracking and atomic work item management
- Shared context graphs for agent handoffs and collaboration
- Centralized audit trail for distributed changes

This Epic addresses both the security requirements for cloud deployment AND the architectural foundation for multi-repo agent coordination.

We want to keep onboarding friction low (e.g., an explicit "no auth" mode for local networks), while ensuring that any public exposure is intentionally protected and that users are warned when protections are not enabled.

# Goal

1. Define a security posture for cloud deployment (baseline controls and recommended defaults).
2. Explore and document access control and authentication options.
3. Provide an explicit and well-documented "no auth" option for trusted environments.
4. Ensure there are prominent warnings when running without authentication.
5. Record key trade-offs and decisions in durable artifacts (including ADRs if needed).

# Non-Goals

- Implementing a full authentication system in this Epic directly. Implementation should be tracked via Features/Tasks created under this Epic.

# Approach

1. Threat model and scope definition (assets, actors, trust boundaries, data sensitivity).
2. Options exploration:
   - Local-only / private network usage (no auth)
   - Shared secret / API key
   - OAuth/OIDC (e.g., GitHub, Azure AD)
   - Network controls (IP allowlist, VPN, private endpoints)
   - Repository-backed permissions vs service-level permissions
3. Decide default modes and user experience:
   - Default mode in cloud deployment
   - What constitutes "unsafe" exposure
   - How warnings are presented (CLI/banner/docs)
4. Capture decisions and follow-up work as Features/Tasks.

## Deployment Modes

Mode A: Local / LAN (no-auth supported)

- Secure-by-default: listen on 127.0.0.1 only.
- Explicit unsafe flags required for 0.0.0.0 without auth.
- Prominent warnings on startup and in HTTP responses.
- Baseline browser safety controls (CORS/Origin) to reduce drive-by abuse.

Mode B: Public / Remote multi-agent (auth required)

- Authentication, authorization, audit logging, abuse prevention, and secrets management.
- Additional controls are required beyond auth, especially for mutating operations and derived-store poisoning.

## Minimal Threat Model (ADR-ready)

Assets:

- Canonical backlog files (source of truth)
- Derived index / embedding / cache
- Claim/lease coordination state
- Audit logs (decision trail)
- Secrets (API keys, OIDC client secret, DB credentials)

Attack surfaces:

- Unauthorized read (data exfiltration)
- Unauthorized write (tampering, spam injection)
- Derived-store poisoning (decision contamination)
- Replay / brute force attempts
- SSRF / path traversal / arbitrary file read/write (if file ops exist)
- DoS (e.g., embedding/search endpoints)

## Public-ready Security Capability List (priority)

P0: Safe defaults

- Default bind to localhost; explicit unsafe mode required otherwise.
- Strict allowed-roots sandbox for any file operations.
- Prefer keeping canonical writes local-first until security posture is solid.

P1: Authentication

- API key / bearer token (fast path)
- OAuth2/OIDC (public/multi-user path)

P2: Authorization

- Scopes (read/write/admin/claim/ingest/embed)
- Product-level ACL
- Admin-only high-risk operations (delete/renumber/rebuild)

P3: Audit

- Log all mutating operations: who/when/what + before/after hash.
- Append-only semantics for audit trail.

P4: Abuse protection

- Rate limiting (per token / per IP)
- Request size limits, timeouts
- Optional reverse-proxy/WAF integration

## Cloud Strategy (local-first aligned)

- Treat cloud as a shared derived store + coordinator (claim/lease, shared index/cache).
- Keep canonical backlog files local and git-backed (or one-way ingest into derived only).
- This reduces blast radius if public deployment is compromised.

# Alternatives

- Keep the system local-only and avoid cloud exposure.
- Rely entirely on network perimeter security.

# Acceptance Criteria

- [ ] A documented set of security requirements for cloud deployment.
- [ ] A shortlist of viable auth/access control approaches with pros/cons.
- [ ] A plan for a "no auth" mode with prominent warnings and safe usage guidance.
- [ ] Follow-up backlog items created for implementation work.

# Risks / Dependencies

- Security scope creep can expand rapidly; must prioritize baseline controls first.
- Auth requirements may depend on hosting/deployment choices (provider, network topology).
- Misconfiguration risk: users may expose services publicly without realizing it.

# Worklog

2026-01-08 16:19 [agent=windsurf] Created as a major roadmap item to plan cloud security, including no-auth local mode and prominent warnings when authentication is not enabled.
2026-01-08 16:45 [agent=windsurf] Expanded scope with explicit deployment modes (Local/LAN no-auth vs Public/auth), minimal threat model, prioritized security capability list, and canonical-vs-derived cloud strategy.
