---
id: KABSD-TSK-0167
uid: 7610cc74-dc68-4e39-a0fa-7938bd74a842
type: Task
title: "Implement kano backlog demo seed subcommand"
state: Proposed
priority: P3
parent: KABSD-FTR-0028
area: cli
iteration: active
tags: ['cli', 'demo', 'bootstrap']
created: 2026-01-11
updated: 2026-01-11
owner: None
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
---

# Context

Legacy `bootstrap_seed_demo.py` creates sample backlog items for testing/demo purposes. To align with the unified CLI, we need `kano backlog demo seed` that wraps this functionality via the ops layer.

# Goal

Implement `kano backlog demo seed` subcommand:
- Accepts `--product`, `--persona-pack developer|pm|qa`, `--max-items N`, `--dry-run`.
- Creates sample Epic/Feature/Task/Bug items under `_kano/backlog/products/<product>/items/`.
- Emits created IDs + file paths for audit.
- Optionally supports custom persona packs via JSON config (deferred to FTR-0030).

# Non-Goals

- Real production data seeding (demo only).
- Generating ADRs or views (focus on items only).
- Integration with external systems (JIRA/Azure sync deferred).

# Approach

1. Extract seeding logic from `bootstrap_seed_demo.py` into `kano_backlog_ops.demo.seed_demo()`.
2. Add CLI command in `src/kano_cli/commands/init.py` (backlog group) or new `demo.py` module.
3. Define a persona pack schema (JSON) with sample item templates (title patterns, priority distribution, tag sets).
4. Use existing `kano_backlog_ops.workitem.create_item()` to generate items (reuse validation/numbering logic).
5. Return `DemoSeedResult` with list of created IDs and paths.
6. Update docs to reference `kano backlog demo seed` instead of `bootstrap_seed_demo.py`.

# Alternatives

- Keep `bootstrap_seed_demo.py` as standalone script: Rejected because it doesn't follow CLI-first pattern.
- Generate demo items via external fixture files: Rejected for MVP; prefer self-contained logic.

# Acceptance Criteria

- [ ] `kano backlog demo seed --product <name> --persona-pack developer` creates sample items.
- [ ] `--max-items N` limits the number of generated items.
- [ ] `--dry-run` previews items without writing files.
- [ ] Output lists created item IDs and file paths.
- [ ] SKILL.md documents the command and deprecates `bootstrap_seed_demo.py`.
- [ ] Generated items pass Ready gate validation (valid frontmatter, non-empty required sections).

# Risks / Dependencies

- Depends on `create_item()` stability (currently used in production).
- Persona pack schema needs to be flexible for future extension (FTR-0030).
- Risk of polluting real backlogs if run without `--product` guard; add safety checks.

# Worklog

2026-01-11 14:48 [agent=copilot] Created item
