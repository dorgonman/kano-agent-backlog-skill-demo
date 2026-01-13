# Topic Brief: config-refactor-toml-layers

Generated: 2026-01-13 (Updated after KABSD-TSK-0192 completion)

## Facts

- [x] Current implementation: JSON, 4-layer merge (defaults→product→topic→workset)
- [x] Schema v1.0 completed: TOML structure + URI compilation + migration plan
- [x] All design decisions resolved (merge semantics, compat duration, auth, registry)
- [x] Example configs created for all 3 layers (global/repo/product)
- [x] KABSD-TSK-0191 Done: Schema definition complete
- [x] KABSD-TSK-0192 Done: TOML parser implemented with backward compat, 10/10 tests pass

**Implementation Status**:
- ✅ TOML precedence over JSON at same layer
- ✅ Deep-merge works identically for TOML/JSON
- ✅ Deprecation warnings for JSON configs
- ✅ Python 3.11+ uses stdlib tomllib, <3.11 uses tomli
- ✅ All existing config overlay tests pass (3/3)
- ✅ New TOML tests pass (10/10)

**References**:
- [Complete Schema Spec](synthesis/toml-config-schema-v1.md)
- [Example Global Config](synthesis/example-global-config.toml)
- [Example Repo Config](synthesis/example-repo-config.toml)
- [Example Product Config](synthesis/example-product-config.toml)
- [Current Config Implementation](../../../skills/kano-agent-backlog-skill/src/kano_backlog_core/config.py)

## Unknowns / Risks

- [x] Parser choice for Python <3.11 (tomli vs tomllib backport) — RESOLVED: conditional import in code
- [ ] Performance impact of 6 layers vs current 4 — likely negligible, config loads once
- [ ] Migration tooling UX (ensure safe rollback) — TSK-0195 will address

## Proposed Actions

- [x] Define schema (TSK-0191) ✅ **DONE**
- [x] Implement TOML parser with deep-merge (TSK-0192) ✅ **DONE**
- [x] Fill Ready gates for TSK-0193~0195 using schema v1.0 as spec
- [x] Implement URI compiler (TSK-0193) ✅ **DONE**
- [x] Add CLI: config show, validate (TSK-0194) ✅ **DONE**
- [x] Build migration tool: JSON→TOML (TSK-0195) ✅ **DONE**
- [x] Update docs and finalize migration guide ✅ **DONE**

## Decision Candidates

All key decisions resolved in schema v1.0:
- [x] Deep-merge strategy: recursive (same as JSON) ✅ implemented
- [x] Compat duration: 2 minor versions before TOML-only ✅ documented
- [x] URI compilation: load-time, fail-fast (deferred to TSK-0193)
- [x] Auth: env vars only for v1 ✅ documented
- [x] Registry: embedded in global config.toml (deferred to TSK-0193)

## Materials Index (Deterministic)

### Items
- 019ba071-1062-79ac-aacb-63abf3e61a73
- 019bb367-1f84-7681-85be-af23e82027ed
- 019bb368-cefc-76c7-ae4c-6d937da64d16
- 019bb368-d2d0-736d-b38c-4a0f2d43cdaf
- 019bb368-d5b8-754c-a0ed-2db82c029293
- 019bb368-f403-760c-93ef-b23e7915d16e

### Pinned Docs
- (none)

### Snippet Refs
- _kano/backlog/_shared/defaults.json#L1-L3 (sha256:68f7a93420ca2f201291a5033551edd9609ac667bca243c08dc7c87f5665d848)
- _kano/backlog/products/kano-agent-backlog-skill/_config/config.json#L1-L36 (sha256:e40176f0c11fbd6328f90144ecba3a3354ba7f0ef0057b64e162e3c1962b3190)
- skills/kano-agent-backlog-skill/src/kano_backlog_core/config.py#L1-L317 (sha256:a5d77de223bb439a328a41096a4c074498d777b9c446ffbded7eff9932b7201e)
