---
area: cli
created: '2026-01-11'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0169
iteration: active
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0028
priority: P3
state: Done
tags:
- cli
- sandbox
- testing
title: Implement kano backlog sandbox init subcommand
type: Task
uid: 019bac45-bf59-70fb-ac49-2a6ba981f964
updated: 2026-01-12
---

# Context

Testing and experimentation require isolated backlog workspaces separate from canonical _kano/backlog/. Currently manual sandbox creation is error-prone and inconsistent. Need kano-backlog admin sandbox init to scaffold sandboxes with proper structure and config inheritance from templates.

# Goal

Implement kano-backlog admin sandbox init command supporting: --name (sandbox-name), --product (template), --sandbox-root (defaults to _kano/backlog_sandbox). Creates proper directory structure with inherited config. Returns sandbox root and config paths.

# Non-Goals

- Auto-cleanup of old sandboxes (manual `rm -rf` is acceptable for MVP).
- Sandbox-to-production promotion (one-way workflow for now).
- Multi-sandbox orchestration (advanced CI feature, out of scope).

# Approach

Extend kano_backlog_ops.init with sandbox-aware logic; add CLI command in commands/admin.py under sandbox group; support config inheritance; create README in sandbox root; update docs.

# Alternatives

- Keep manual sandbox creation: Rejected because it's error-prone and inconsistent.
- Use `kano backlog init` with a `--sandbox` flag: Rejected because sandbox lifecycle is distinct from product initialization.

# Acceptance Criteria

sandbox init creates directory under _kano/backlog_sandbox/<name>/products/<product>/; config inherits from template; matches production layout; README documents purpose; SKILL.md updated; .gitignore covers sandboxes.

# Risks / Dependencies

Sandbox pollution if --name not unique (add existence check); depends on init_backlog flexibility; need clear guidance on sandbox vs branches.

# Worklog

2026-01-11 14:48 [agent=copilot] Created item
2026-01-12 07:37 [agent=copilot] Started: implementing kano-backlog admin sandbox init command for isolated backlog testing.
2026-01-12 07:38 [agent=copilot] Done: kano-backlog admin sandbox init fully functional. Creates isolated backlog environments at _kano/backlog_sandbox/<name>/. Supports --product, --force, config inheritance. README included. .gitignore configured. SKILL.md updated with sandbox workflow examples. All acceptance criteria met.
