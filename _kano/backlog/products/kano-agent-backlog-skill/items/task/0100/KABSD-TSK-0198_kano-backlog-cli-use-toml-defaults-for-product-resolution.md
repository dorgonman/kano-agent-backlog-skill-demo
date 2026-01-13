---
area: tooling
created: '2026-01-13'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0198
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: null
parent: KABSD-FTR-0024
priority: P2
state: Done
tags:
- config
- defaults
- toml
- cli
title: 'kano-backlog CLI: use TOML defaults for product resolution'
type: Task
uid: 019bb7e9-eadd-74d8-a688-9a75c3b1480d
updated: '2026-01-14'
---

# Context

`skills/kano-agent-backlog-skill/src/kano_backlog_cli/util.py` still reads `_kano/backlog/_shared/defaults.json` directly when resolving the default product.

The repo config system is TOML-first:
- `_kano/backlog/_shared/defaults.toml` is the preferred defaults file.
- `defaults.json` is deprecated and should only be a compatibility fallback.

This mismatch is confusing for humans (it looks like JSON is still authoritative) and can break the fallback when only TOML defaults exist.

# Goal

Make kano-backlog CLI product resolution use the shared TOML-first defaults loader, and clarify the fallback semantics.

# Approach

1. Update `kano_backlog_cli.util.resolve_product_root` to load defaults via `kano_backlog_core.config.ConfigLoader.load_defaults()` (TOML-first, JSON fallback).
2. Scan code (non-test) for other direct reads of `_shared/defaults.json` and consolidate them to the shared loader where appropriate.
3. Add a short comment to `_kano/backlog/_shared/defaults.toml` describing when `default_product` is used (fallback only).
4. Run focused config tests (or add a small one) to ensure TOML-only defaults still resolve `default_product`.

# Acceptance Criteria

- `kano_backlog_cli.util.resolve_product_root` no longer reads `defaults.json` directly.
- If only `defaults.toml` exists, `default_product` fallback is honored.
- If only `defaults.json` exists, behavior remains compatible (deprecated fallback).
- A brief comment clarifies the fallback behavior for humans.

# Risks / Dependencies

- Risk: subtle behavior change in edge cases. Mitigation: keep the same precedence order and cover with a focused test.

# Worklog

2026-01-13 19:40 [agent=codex-cli] Created task to migrate kano-backlog CLI default_product fallback to TOML-first loader.
2026-01-13 23:15 [agent=codex-cli] [model=gpt-5.2] State: Proposed → Ready: Ready: clarified TOML-first defaults fallback work and acceptance criteria.
2026-01-13 23:15 [agent=codex-cli] [model=gpt-5.2] State: Ready → InProgress: Start: implementing TOML-first defaults in kano_backlog_cli util.
2026-01-14 00:26 [agent=codex-cli] [model=gpt-5.2] State: InProgress → Done: Done: resolve_product_root now uses TOML-first defaults loader (defaults.toml preferred, defaults.json deprecated fallback) + clarified fallback docs.