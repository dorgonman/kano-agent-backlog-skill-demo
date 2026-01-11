---
id: ADR-0015
title: "Skill-Scoped CLI Namespace Convention"
status: Proposed
date: 2026-01-12
related_items: ["KABSD-EPIC-0009", "KABSD-FTR-0034", "KABSD-FTR-0035", "KABSD-FTR-0036"]
supersedes: null
superseded_by: null
---

# Decision

Each skill repository **MUST** use skill-scoped naming for its CLI entrypoints and Python packages:
- CLI script: `scripts/<skill-name>` (e.g., `scripts/kano-backlog`)
- Python CLI package: `<skill_name>_cli` (e.g., `kano_backlog_cli`)
- Console script entrypoint (in pyproject.toml): `<skill-name>` (e.g., `kano-backlog`)

The global name **`kano`** is **reserved** for a future umbrella CLI that will aggregate multiple skill CLIs. Individual skills **MUST NOT** claim the `kano` name in their own codebase.

# Context

The original implementation used universe-level names (`kano`, `kano_cli`) inside `kano-agent-backlog-skill`, assuming this was the only skill. As we add more skills (e.g., `kano-commit-convention-skill`), these names will collide.

**Problems with the current approach:**
- `kano` is too generic for a single skill's CLI
- Multiple skills can't coexist if they all claim `kano`
- Migration confusion when the umbrella CLI is introduced later

**Goals:**
- Enable multiple skill repos to coexist (each with its own scoped CLI)
- Reserve `kano` as a future umbrella command aggregator
- Maintain consistency across all kano-ecosystem skills

# Options Considered

1. **Keep `kano` as-is and ignore future skills** ❌  
   - Rejected: causes immediate collision when adding second skill.

2. **Use skill-scoped naming (`kano-backlog`, `kano_backlog_cli`)** ✅ (chosen)  
   - Each skill is self-contained and independent.
   - `kano` umbrella CLI can be added later without breaking existing skills.

3. **Use a monorepo with namespace packages**  
   - Rejected: conflicts with self-contained skill deployment model; skills are designed to be used as git submodules or standalone repos.

# Pros / Cons

**Pros:**
- Clear ownership: each skill owns its namespace
- No collision when multiple skills are used together
- Future-proof: umbrella CLI can be introduced as a separate repo
- Aligns with ADR-0013 (module boundaries)

**Cons:**
- Requires renaming existing code (`kano` → `kano-backlog`, `kano_cli` → `kano_backlog_cli`)
- Command tree changes (`kano item` → `kano-backlog workitem`)
- Migration for existing users (mitigated by deprecation wrapper)

# Consequences

**Immediate actions (EPIC-0009):**
- Rename `scripts/kano` → `scripts/kano-backlog`
- Rename `src/kano_cli` → `src/kano_backlog_cli`
- Update pyproject.toml entrypoint: `kano-backlog` instead of `kano`
- Restructure command groups (`item` → `workitem`, `backlog` → `admin`)
- Update all documentation (SKILL.md, README.md, REFERENCE.md)
- Provide deprecated `kano` wrapper script with migration warning

**Long-term (out of scope for this repo):**
- Future `kano` umbrella CLI repo can implement command delegation (e.g., `kano backlog <cmd>` → `kano-backlog <cmd>`)
- Each skill continues to work standalone with its scoped CLI

# Follow-ups

- [ ] Implement renaming per KABSD-FTR-0034 (rename packages/scripts)
- [ ] Implement command tree restructuring per KABSD-FTR-0035
- [ ] Document reservation and future umbrella CLI design per KABSD-FTR-0036
- [ ] Update ADR-0013 to reference this naming convention
