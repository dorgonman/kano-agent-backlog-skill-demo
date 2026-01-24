# Topic Brief: release-0-0-2

Updated: 2026-01-24

## Facts

<!-- Verified facts with citations to materials/items/docs -->
- [x] Release readiness checks for version `0.0.2` passed (phase1 PASS). — [source](_kano/backlog/topics/release-0-0-2/publish/release_check_0.0.2_phase1.md)
- [x] Environment health check passed via `kano-backlog doctor` (2 products detected; CLI available). — [source](_kano/backlog/topics/release-0-0-2/publish/phase2_doctor.txt)
- [x] Test suite passed: `707 passed, 32 skipped` (warnings present). — [source](_kano/backlog/topics/release-0-0-2/publish/phase2_pytest.txt)
- [x] Feature coverage confirmed in phase1 checks:
  - Topic templates (engine + ops + CLI flags). — [source](_kano/backlog/topics/release-0-0-2/publish/release_check_0.0.2_phase1.md)
  - Topic cross-references (`manifest.related_topics`). — [source](_kano/backlog/topics/release-0-0-2/publish/release_check_0.0.2_phase1.md)
  - Topic snapshots (create/list/restore + models). — [source](_kano/backlog/topics/release-0-0-2/publish/release_check_0.0.2_phase1.md)
  - Topic merge/split (including dry-run plan types). — [source](_kano/backlog/topics/release-0-0-2/publish/release_check_0.0.2_phase1.md)
  - Topic distill seed-item rendering improvements. — [source](_kano/backlog/topics/release-0-0-2/publish/release_check_0.0.2_phase1.md)
  - Workitem artifact attachment supports product layout resolution. — [source](_kano/backlog/topics/release-0-0-2/publish/release_check_0.0.2_phase1.md)
- [x] Phase2 smoke checks ran and were recorded as PASS, but include expected errors due to pre-existing sandbox/topics (see Risks). — [source](_kano/backlog/topics/release-0-0-2/publish/release_check_0.0.2_phase2.md)

## Unknowns / Risks

<!-- Open questions and potential blockers -->
- [ ] Phase2 smoke logs include errors caused by pre-existing resources:
  - Sandbox init suggests using `--force` to recreate an existing sandbox. — [source](_kano/backlog/topics/release-0-0-2/publish/phase2_sandbox_init.txt)
  - Topic create smoke fails when the topic already exists. — [source](_kano/backlog/topics/release-0-0-2/publish/phase2_smoke_topic-create-a-template.txt)
  - Topic create (non-template) reports "Topic already exists" with suggestion. — [source](_kano/backlog/topics/release-0-0-2/publish/phase2_smoke_topic-create-b.txt)
- [ ] Pytest warnings remain (JSON config deprecation; `frontmatter` uses deprecated `codecs.open`). These are not release blockers, but should be tracked to avoid future breakage. — [source](_kano/backlog/topics/release-0-0-2/publish/phase2_pytest.txt)
- [ ] No release tracking work items are linked in this topic (`seed_items` is empty), so scope/ownership is not explicit in backlog. — [source](_kano/backlog/topics/release-0-0-2/manifest.json)

## Proposed Actions

<!-- Concrete next steps, linked to workitems -->
- [ ] Create a release tracking Task for `0.0.2` (scope, acceptance, artifacts, who publishes). → new ticket needed
- [ ] Decide whether smoke tests should auto-cleanup (or auto-randomize names) to avoid "already exists" failures. → new ticket needed
- [ ] Track and optionally reduce deprecation warnings (JSON config migration; `frontmatter` deprecation). → new ticket needed
- [ ] If using sandboxes for smoke in CI, document `--force` usage and expected behavior when sandbox exists. → new ticket needed

## Decision Candidates

<!-- Tradeoffs requiring ADR -->
- [ ] Smoke test policy: treat "already exists" as non-fatal (idempotent) vs enforce unique names/cleanup. → draft needed (decision note or ADR if cross-cutting)
- [ ] Config migration policy: timeline to remove JSON config support vs keep deprecation-only. → draft needed

---
_This brief is human-maintained. `topic distill` writes to `brief.generated.md`._
