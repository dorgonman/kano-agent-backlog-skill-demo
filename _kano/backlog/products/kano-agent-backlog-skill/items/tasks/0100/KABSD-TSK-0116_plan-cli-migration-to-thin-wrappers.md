---
id: KABSD-TSK-0116
uid: 019b9853-73ad-7ba4-bf3e-1c5e5e6218e5
type: Task
title: "Plan CLI migration to thin wrappers"
state: Proposed
priority: P2
parent: KABSD-FTR-0019
area: architecture
iteration: null
tags: ["cli", "facade", "wrapper"]
created: 2026-01-07
updated: 2026-01-07
owner: null
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

Current scripts mix domain logic and arg parsing/output formatting. Post-refactor, scripts should become thin wrappers over `kano-backlog-core`, with a consistent CLI package exposing entry points.

# Goal

- Define CLI facade structure (package layout, `console_scripts` entry points).
- Decide output modes (human-readable vs `--json`) and error exit code conventions.
- Plan incremental migration for legacy scripts without breaking workflows.

# Non-Goals

- Implement all CLI commands; focus on plan and examples.
- Design HTTP/MCP routes.

# Approach

1. Propose a `kano` CLI with subcommands mapping to core operations.
2. Define arg parsing policy (argparse/click/typer) and output formatting.
3. Identify high-usage scripts to migrate first; provide mapping table.
4. Keep legacy entrypoints temporarily as wrappers calling the new CLI.

# Alternatives

- Keep separate scripts indefinitely; risks fragmentation.

# Acceptance Criteria

- A migration plan is documented with initial entry points and subcommands.
- Error handling and exit code policy are defined.
- Legacy compatibility approach is described (wrappers or deprecation timeline).

# Risks / Dependencies

- CLI churn can confuse users; require clear docs and stable aliases.
- Packaging introduces distribution/versioning considerations.

# Worklog

2026-01-07 19:59 [agent=copilot] Outline CLI facade package entry points and migrate legacy scripts incrementally.
