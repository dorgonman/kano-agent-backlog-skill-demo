# Topic Notes: release-0-0-2

## Overview

This topic tracks the readiness evidence and follow-ups for releasing version `0.0.2` of the `kano-agent-backlog-skill` demo repo.

Primary inputs are the deterministic release check reports (phase1 + phase2) stored under `publish/`.

## Related Items

No work items are currently linked to this topic (`seed_items` is empty). — [source](_kano/backlog/topics/release-0-0-2/manifest.json)

Recommendation: create a dedicated release tracking Task/Bug for `0.0.2` so ownership, acceptance criteria, and publish steps are recorded in the backlog.

## Key Decisions

- No release-go/no-go decisions are recorded in this topic yet.
- Candidate decisions to record (depending on future CI needs):
  - Smoke test policy for existing resources (idempotent vs strict cleanup/unique naming).
  - Deprecation policy timeline for JSON config support.

## Open Questions

- Should phase2 smoke checks be adjusted to avoid failures when the sandbox or smoke topics already exist?
  Evidence of current behavior:
  - Sandbox already exists (requires `--force`). — [source](_kano/backlog/topics/release-0-0-2/publish/phase2_sandbox_init.txt)
  - Topic create fails when the topic already exists. — [source](_kano/backlog/topics/release-0-0-2/publish/phase2_smoke_topic-create-b.txt)
- Should the release process include a standard cleanup step (delete smoke topics / remove sandbox) or should commands become more idempotent?
- Do we want to reduce or track pytest warnings before `0.0.x` grows further?
  Evidence:
  - Pytest run is green but includes deprecation warnings (JSON config; `frontmatter`/`codecs.open`). — [source](_kano/backlog/topics/release-0-0-2/publish/phase2_pytest.txt)

## Evidence Summary (for human reviewers)

- Phase1 PASS: version bump and feature checklist for `0.0.2`. — [source](_kano/backlog/topics/release-0-0-2/publish/release_check_0.0.2_phase1.md)
- Phase2 PASS: environment doctor + pytest + topic smoke command execution logs. — [source](_kano/backlog/topics/release-0-0-2/publish/release_check_0.0.2_phase2.md)
