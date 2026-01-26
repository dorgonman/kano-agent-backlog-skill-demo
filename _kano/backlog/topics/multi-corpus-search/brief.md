# Topic Brief: multi-corpus-search

Generated: 2026-01-25T14:20:33.043881Z

## Facts

<!-- Verified facts with citations to materials/items/docs -->
- [x] Two distinct corpuses: backlog (items+ADRs+topics) and repo (docs+code) — [KABSD-FTR-0058](../../products/kano-agent-backlog-skill/items/feature/0000/KABSD-FTR-0058_multi-corpus-hybrid-search-backlog-repo.md)
- [x] Each corpus gets its own SQLite DB to prevent ranking pollution — [KABSD-FTR-0058](../../products/kano-agent-backlog-skill/items/feature/0000/KABSD-FTR-0058_multi-corpus-hybrid-search-backlog-repo.md)
- [x] Cache freshness uses mtime-based heuristic (not content hash) for speed — [KABSD-TSK-0297 worklog](../../products/kano-agent-backlog-skill/items/task/0200/KABSD-TSK-0297_define-corpus-boundaries-and-cache-freshness-policy.md)
- [x] --force rebuild provided as escape hatch for stale results — [KABSD-TSK-0297](../../products/kano-agent-backlog-skill/items/task/0200/KABSD-TSK-0297_define-corpus-boundaries-and-cache-freshness-policy.md)
- [x] Backlog corpus implementation completed (items+ADRs+topics indexed) — [KABSD-TSK-0298](../../products/kano-agent-backlog-skill/items/task/0200/KABSD-TSK-0298_implement-backlog-corpus-chunks-db-items-adrs-topics.md)
- [x] Embedding space IDs include corpus identity to prevent cross-corpus mixing — [KABSD-TSK-0300](../../products/kano-agent-backlog-skill/items/task/0300/KABSD-TSK-0300_add-repo-corpus-embedding-build-and-hybrid-search.md)

## Unknowns / Risks

<!-- Open questions and potential blockers -->
- [ ] How to handle very large repos (>10k files)? May need sampling or priority-based indexing
- [ ] What's the right balance for FTS candidate count before vector rerank? (current: top-200)
- [ ] Should we support cross-corpus queries in the future, or keep them strictly separated?
- [ ] How often should users run --force rebuild? Need usage data to recommend a cadence
- [ ] Repo corpus include/exclude patterns: are the defaults safe enough to prevent secret leakage?

## Proposed Actions

<!-- Concrete next steps, linked to workitems -->
- [x] Define corpus boundaries and cache policy → [KABSD-TSK-0297](../../products/kano-agent-backlog-skill/items/task/0200/KABSD-TSK-0297_define-corpus-boundaries-and-cache-freshness-policy.md) (Proposed)
- [x] Implement backlog corpus chunks DB → [KABSD-TSK-0298](../../products/kano-agent-backlog-skill/items/task/0200/KABSD-TSK-0298_implement-backlog-corpus-chunks-db-items-adrs-topics.md) (InProgress - DONE)
- [ ] Implement repo corpus chunks DB → [KABSD-TSK-0299](../../products/kano-agent-backlog-skill/items/task/0200/KABSD-TSK-0299_implement-repo-corpus-chunks-db-docs-code.md) (Proposed)
- [ ] Add repo corpus embedding build and hybrid search → [KABSD-TSK-0300](../../products/kano-agent-backlog-skill/items/task/0300/KABSD-TSK-0300_add-repo-corpus-embedding-build-and-hybrid-search.md) (Proposed)
- [ ] Document multi-corpus search usage → [KABSD-TSK-0301](../../products/kano-agent-backlog-skill/items/task/0300/KABSD-TSK-0301_document-multi-corpus-search-usage-and-rebuild-commands.md) (Proposed)

## Decision Candidates

<!-- Tradeoffs requiring ADR -->
- [ ] Corpus split strategy (backlog vs repo) → Consider ADR if we add more corpuses or change boundaries
- [ ] mtime-based freshness vs content-hash → Already decided in KABSD-TSK-0297 worklog; promote to ADR if this becomes contentious
- [ ] Separate DBs vs unified DB with corpus tags → Already decided (separate DBs); consider ADR if we revisit

---
_This brief is human-maintained. `topic distill` writes to `brief.generated.md`._

