---
id: KABSD-TSK-0169
uid: 35ed5fef-9c0c-45a5-8d09-c1c9830e72ed
type: Task
title: "Implement kano backlog sandbox init subcommand"
state: Proposed
priority: P3
parent: KABSD-FTR-0028
area: cli
iteration: active
tags: ['cli', 'sandbox', 'testing']
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

Testing and experimentation often require isolated backlog workspaces that don't pollute the canonical `_kano/backlog/`. Currently, developers manually create sandbox directories and copy config files. To streamline this, we need `kano backlog sandbox init` to scaffold sandboxes with proper structure and config inheritance.

# Goal

Implement `kano backlog sandbox init` subcommand:
- Accepts `--name <sandbox-name>`, `--product <template-product>`, `--sandbox-root` (defaults to `_kano/backlog_sandbox`).
- Creates `_kano/backlog_sandbox/<name>/products/<product>/` with:
  - Standard directory structure (items/, decisions/, views/, _config/, _meta/, _index/).
  - Config file inheriting from template product or default config.
  - Optional symlink to shared defaults (`_kano/backlog/_shared/defaults.json`).
- Emits sandbox root path and config location.

# Non-Goals

- Auto-cleanup of old sandboxes (manual `rm -rf` is acceptable for MVP).
- Sandbox-to-production promotion (one-way workflow for now).
- Multi-sandbox orchestration (advanced CI feature, out of scope).

# Approach

1. Reuse `kano_backlog_ops.init.init_backlog()` logic but target sandbox root instead of platform root.
2. Add CLI command in `src/kano_cli/commands/init.py` (backlog group).
3. Support config inheritance: read template product config, override `sandbox.root`, write to sandbox location.
4. Optionally create a README in the sandbox root explaining its purpose and lifecycle.
5. Return `SandboxInitResult` with paths and creation summary.
6. Update SKILL.md to document sandbox workflows.

# Alternatives

- Keep manual sandbox creation: Rejected because it's error-prone and inconsistent.
- Use `kano backlog init` with a `--sandbox` flag: Rejected because sandbox lifecycle is distinct from product initialization.

# Acceptance Criteria

- [ ] `kano backlog sandbox init --name test-sandbox --product cli-demo` creates a sandbox under `_kano/backlog_sandbox/test-sandbox/`.
- [ ] Sandbox config inherits from specified product or defaults.
- [ ] Sandbox structure matches production backlog layout.
- [ ] Optional README.md explains sandbox purpose and cleanup instructions.
- [ ] SKILL.md documents sandbox init and best practices.
- [ ] Sandboxes are gitignored by default (update `.gitignore` if needed).

# Risks / Dependencies

- Risk of sandbox pollution if `--name` is not unique; add existence check.
- Depends on `init_backlog()` being flexible enough to handle sandbox roots.
- Need clear guidance on when to use sandboxes vs branches for experimentation.

# Worklog

2026-01-11 14:48 [agent=copilot] Created item
