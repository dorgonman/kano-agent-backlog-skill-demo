---
id: KABSD-TSK-0131
uid: 019bac45-bf54-75a1-a87c-228d9140ad17
type: Task
title: "Plan cloud security posture, auth options, and no-auth warnings"
state: New
priority: P1
parent: KABSD-EPIC-0007
area: security
iteration: null
tags: ["cloud", "security", "auth", "warnings", "roadmap"]
created: 2026-01-08
updated: 2026-01-08
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: ["KABSD-EPIC-0005", "KABSD-EPIC-0006"]
  blocks: []
  blocked_by: []
decisions: []
---

# Context

Cloud deployment creates a real risk of accidental public exposure. A "no auth" mode can be helpful for trusted environments (e.g., private LAN) to reduce onboarding friction, but must not become an unsafe default when deployed publicly.

We need an explicit plan for authentication and access control options, plus prominent warnings and guidance when protections are not enabled.

# Goal

1. Produce a threat model appropriate for this project.
2. Evaluate authentication and access control options.
3. Define safe defaults and supported modes (including "no auth" explicitly).
4. Specify how and where warnings are shown when auth is disabled.

# Approach

1. Threat model:
   - Assets: backlog data, audit logs, indexing DBs, configuration
   - Actors: trusted user, internal agent, untrusted public internet users
   - Entry points: CLI/server endpoints (current and planned), file operations, any future web UI
   - Trust boundaries: local machine, LAN, internet, cloud identity provider
2. Option matrix (minimum viable to robust):
   - No auth (LAN only) + explicit warnings
   - Shared secret / API key
   - OAuth/OIDC (GitHub / Azure AD)
   - Network-level controls (IP allowlist, VPN, private endpoints)
   - Read-only vs read-write roles
3. UX and safety:
   - Define what "unsafe" means (e.g., binding to 0.0.0.0 without auth)
   - Decide warning placement (CLI output/banner, generated views, README)
   - Define configuration flags and their defaults (draft only; implementation in follow-up tasks)
4. Deliverables:
   - A short written plan + option matrix
   - A set of follow-up backlog items for implementation (Task/Feature)
   - Create ADR(s) only if a real architectural trade-off is selected

## Deployment Modes (draft)

Mode A: Local / LAN (no-auth supported)

- Default bind: 127.0.0.1 only.
- Allow 0.0.0.0 only with explicit unsafe flag(s).
- Startup prints prominent warning.
- HTTP root endpoint returns a warning banner/string.
- Baseline CORS/Origin restriction.
- Mutating endpoints protected by an additional "danger" confirmation flag and/or allowlist.

Mode B: Public / Remote multi-agent (auth required)

- Authentication is mandatory.
- Authorization is mandatory (scopes + product-level ACL).
- Mutating operations require audit logging.
- Abuse prevention is mandatory (rate limit, request size limit, timeouts).
- Secrets management is required for tokens/keys.

## Minimal Threat Model (ADR-ready)

Assets:

- Canonical backlog files (source of truth)
- Derived index / embedding / cache
- Claim/lease coordination state
- Audit logs
- Secrets (API keys, OIDC client secret, DB credentials)

Attack surfaces:

- Unauthorized read (data exfiltration)
- Unauthorized write (tampering, spam injection)
- Derived-store poisoning (decision contamination)
- Replay / brute force attempts
- SSRF / path traversal / arbitrary file read/write (if file ops exist)
- DoS (especially derived/search endpoints)

## Public-ready Security Capability Checklist (priority)

P0: Safe defaults

- Secure-by-default bind to localhost.
- Explicit unsafe mode required for public exposure without auth.
- Strict allowed-roots sandbox for file operations.
- Prefer keeping canonical writes local-first until public posture is proven.

P1: Authentication

- API key / bearer token (fast to ship)
- OAuth2/OIDC (public/multi-user)

P2: Authorization

- Scopes: read/write/admin/claim/ingest/embed
- Product-level ACL
- Admin-only high-risk operations (delete/renumber/rebuild)

P3: Audit

- Log all mutating operations: who/when/what, before/after hash.
- Append-only semantics.

P4: Abuse prevention

- Rate limit (per token / per IP)
- Request size limits, timeouts
- Optional reverse-proxy/WAF integration

## Warning Strategy (three layers)

1. Startup: console banner.
2. HTTP: root endpoint displays warning banner.
3. Config: auth mode requires explicit acknowledgement flag.

Example draft policy:

- auth.mode = "none" requires i_understand_risks = true, otherwise refuse to start.

## ADR Candidates (if/when trade-offs are selected)

- ADR: Deployment Modes & Secure Defaults
- ADR: Authentication Strategy (API Key vs OIDC)
- ADR: Authorization Model (Scopes + Product ACL)
- ADR: Audit Logging & Tamper Evidence
- ADR: Rate Limiting & Abuse Prevention
- ADR: Secrets Management
- ADR: Data Separation (canonical vs derived) for cloud

# Acceptance Criteria

- [ ] Threat model document (can be embedded in this Task or a linked doc).
- [ ] Option matrix with pros/cons and recommended default.
- [ ] Clear definition of supported modes: "no auth" (LAN only) and at least one authenticated mode.
- [ ] Proposed warning strategy, including exact warning text and where it will appear.
- [ ] Follow-up implementation items created (scoped to one session each).

# Risks / Dependencies

- Requires clarity on the deployment target (hosting model) to pick a primary auth approach.
- Risk of building an auth system too early; prioritize warnings and safe defaults first.
- Some auth options require external identity providers and key management.

# Worklog

2026-01-08 16:19 [agent=windsurf] Created to plan cloud security and avoid unsafe public exposure while preserving an explicit no-auth mode for trusted environments.
2026-01-08 16:49 [agent=windsurf] Added deployment modes requirements, threat model skeleton, prioritized capability checklist (P0-P4), warning strategy, and ADR candidates.
