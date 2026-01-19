---
id: ADR-0034
uid: 019bc711-f9f0-72cd-8707-898abc34aac0
title: "Conflict handling policy for duplicate IDs and UIDs"
status: Proposed
date: 2026-01-16
related_items: ["KABSD-TSK-0232"]
supersedes: null
superseded_by: null
---

# Decision

Adopt a configurable conflict policy for duplicate IDs and UIDs, with defaults:

- `conflict_policy.id_conflict = "rename"`: when duplicate display IDs are detected, rename duplicates to the next available ID.
- `conflict_policy.uid_conflict = "trash_shorter"`: when the same UID appears with differing content, keep the longer file and move the shorter file to `_trash/<YYYYMMDD>/...`.

Tie-breaker for equal length: keep the lexicographically earliest path and trash the other(s).

# Context

We need deterministic, low-friction behavior for duplicate IDs/UIDs across agents. Recent link integrity repairs showed how ambiguity slows down remediation and risks cross-agent divergence.

# Options Considered

- Always report and require human intervention.
- Auto-rename duplicate IDs and auto-trash UID conflicts.
- Auto-rename for both ID and UID conflicts.

# Pros / Cons

- Auto-rename reduces manual cleanup for benign ID collisions.
- Trashing UID conflicts is safer than deletion and preserves a recovery path.
- Auto-remediation can hide mistakes if applied without review; defaults should be documented and configurable.

# Consequences

- `admin links normalize-ids` will apply these defaults unless overridden in config.
- UID conflict resolution will create `_trash/` entries; audits should treat them as recoverable artifacts.

# Follow-ups

- Document the policy in the skill and config defaults.
