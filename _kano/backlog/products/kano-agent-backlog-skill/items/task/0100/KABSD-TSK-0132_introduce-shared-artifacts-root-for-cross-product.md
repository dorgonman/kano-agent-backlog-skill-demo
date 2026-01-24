---
id: KABSD-TSK-0299
uid: 019bac45-bf55-72d5-af0c-bebbfcb44d31
type: Task
title: "Introduce _shared/artifacts root for cross-product artifacts"
state: InProgress
priority: P1
parent: KABSD-FTR-0009
area: infra
iteration: null
tags: ["artifacts", "shared", "multi-product", "structure"]
created: 2026-01-09
updated: 2026-01-12
owner: codex-cli
external:
  azure_id: null
  jira_key: null
links:
  relates: ["ADR-0006", "KABSD-TSK-0130"]
  blocks: []
  blocked_by: []
decisions: []
---

# Context

We currently have artifacts appearing under `_kano/backlog/artifacts/`, but cross-product artifacts should live under a shared platform-level location so they are not tied to a single product and can be reused across products.

We also already have a platform-level `_shared/` concept (ADR-0006). We want to extend it with a consistent shared artifact root:

- Target: `_kano/backlog/_shared/artifacts/`

This task focuses on folder conventions, migration strategy, and link/script adjustments.

# Goal

1. Define the canonical shared artifacts root for cross-product work.
2. Provide a safe migration plan from legacy `_kano/backlog/artifacts/` into `_kano/backlog/_shared/artifacts/`.
3. Ensure backlog items and helper scripts can reference shared artifacts with stable, readable links.

# Approach

1. Define storage rules:
   - Product-local artifacts remain under `products/<product>/artifacts/`.
   - Cross-product artifacts live under `_kano/backlog/_shared/artifacts/`.
   - Per-item subfolders use the item ID: `_kano/backlog/_shared/artifacts/<ItemID>/`.
   - Classification rule (initial): only migrate artifacts that are truly cross-product; selection is manual/by-convention for now.
2. Migration plan (non-destructive first):
   - Create `_kano/backlog/_shared/artifacts/`.
   - Identify existing directories under `_kano/backlog/artifacts/`.
   - Move or copy cross-product artifacts into `_shared/artifacts/`.
   - Update markdown links to point to the new location.
   - Keep a compatibility phase (do not delete legacy paths until links are verified).
3. Script updates (follow-up implementation under this task):
   - Extend `workitem_attach_artifact.py` to support attaching to shared artifacts (e.g. a `--shared` flag) or a documented manual workflow.
   - Update documentation/examples that currently point to `_kano/backlog/artifacts/`.

# Acceptance Criteria

- [x] `_kano/backlog/_shared/artifacts/` convention is documented and referenced from relevant docs.
- [x] A migration checklist exists for moving from `_kano/backlog/artifacts/` to `_shared/artifacts/`.
- [x] At least one example item successfully links to a shared artifact under `_shared/artifacts/<ItemID>/`.
- [x] Follow-up changes needed in scripts/docs are listed (and opened as separate tasks if they require code changes beyond this session).

# Risks / Dependencies

- Risk: link breakage across many items if migration is done destructively.
- Risk: Windows file locking can block moves/deletes; migration must be resilient (copy-first).
- Dependency: clarify how cross-product artifacts are identified (by convention, not automation, for now).

# Worklog

2026-01-09 11:25 [agent=windsurf] Created to introduce `_kano/backlog/_shared/artifacts` for cross-product artifacts and plan migration from legacy `_kano/backlog/artifacts`.
2026-01-09 11:38 [agent=windsurf] Created `_kano/backlog/_shared/artifacts/` and copied Mermaid guidance to `_kano/backlog/_shared/artifacts/KABSD-TSK-0130/mermaid-guidance.md` as the first cross-product shared artifact example.
2026-01-09 11:56 [agent=windsurf] Decision: only truly cross-product artifacts should move into `_shared/artifacts`; product-specific artifacts should remain product-local.
2026-01-12 02:56 [agent=codex-cli] Start migration: clean up legacy _kano/backlog/artifacts, move to product or _shared per convention.
2026-01-12 03:00 [agent=codex-cli] Copied legacy _kano/backlog/artifacts into canonical locations (product artifacts + _shared/KABSD-TSK-0130). Deletion blocked by ACL (no delete permission); left README and placeholder noting removal once permitted.
