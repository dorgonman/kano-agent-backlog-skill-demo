---
id: ADR-0005
title: "Skill Versioning and Release Policy"
status: Proposed
date: 2026-01-06
related_items: [KABSD-EPIC-0002, KABSD-EPIC-0003, KABSD-TSK-0067]
supersedes: null
superseded_by: null
---

# Decision

Adopt a **SemVer-inspired** versioning policy for `kano-agent-backlog-skill` with a clear pre-1.0 roadmap:

- Use Git tags as the source of truth for released versions: `vX.Y.Z`.
- While `<1.0.0`, treat releases as **milestones** and allow faster iteration, but still:
  - use `Z` for bugfixes and non-breaking changes,
  - use `Y` when we introduce intentional breaking changes (schema/CLI/layout).
- After `1.0.0`, follow SemVer strictly:
  - `Z` patch = backward-compatible bugfix only
  - `Y` minor = backward-compatible feature + optional deprecations
  - `X` major = breaking changes (must provide migration guidance)

# Context

This repo is a demo host and development environment for an open-source skill. We need a predictable way to:
- communicate what changed,
- decide when changes are breaking,
- align backlog milestones with releases,
- keep multi-agent usage stable across time.

# Definitions (what counts as breaking)

Breaking changes include (non-exhaustive):

- **Frontmatter schema**: renaming/removing required keys, changing meaning of `state` groups, changing defaults that alter workflow rules.
- **Path/layout**: moving the canonical backlog root (`_kano/backlog/**`), changing bucket rules, changing decisions/items separation.
- **Script CLI**: removing/renaming flags, changing required flags, changing default behavior that affects output determinism.
- **Config schema**: renaming/removing keys under `_kano/backlog/_config/config.json`.
- **Generated output contracts**: changing canonical dashboard filenames or section/group meaning.

Non-breaking changes include:
- adding optional keys or sections,
- adding new scripts (without changing existing CLI),
- strengthening validation with clearer error messages (unless it blocks previously valid projects).

# Release artifacts (minimum)

For each release tag:

- Update the skill docs (README/REFERENCE) to match reality.
- Ensure canonical scripts work end-to-end:
  - `scripts/backlog/view_refresh_dashboards.py`
  - `scripts/backlog/view_generate_demo.py` (demo dashboards)
  - `scripts/backlog/workitem_update_state.py`
- Ensure demo views are regenerated.

Optional (recommended as we approach 0.1.0+):
- `CHANGELOG.md` in the skill repo (high-level, human readable).
- A short “upgrade notes” section when there is any migration required.

# Milestone mapping (demo backlog)

We track releases as milestone Epics:

- `KABSD-EPIC-0002` = `v0.0.1` (core demo)
- `KABSD-EPIC-0003` = `v0.0.2` (indexing + resolver)

Future guideline:
- Patch releases (`v0.0.(Z+1)`) do not require new Epics; they are small fixes folded into the current milestone Epic.
- Minor bump in pre-1.0 (`v0.(Y+1).0`) should have a dedicated milestone Epic if it introduces breaking changes.

# Consequences

- We will treat “schema/CLI/layout” changes as versioned contracts.
- Each “milestone epic” must have acceptance criteria that match a release outcome (taggable state).
- When breaking changes are introduced, the release must include clear migration guidance (script or documented steps).
