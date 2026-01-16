---
area: general
created: '2026-01-16'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0209
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: codex
parent: null
priority: P2
state: Done
tags:
- backlog
- links
- validation
- tooling
title: Add link integrity validator for backlog refs
type: Task
uid: 019bc429-6d75-75b4-b637-b9d045b746be
updated: 2026-01-16
---

# Context

Renaming backlog item filenames can break markdown links and wikilinks in the source-of-truth files. Derived data can be regenerated, but broken source links require a reliable detection mechanism to guide repairs.

# Goal

Provide a deterministic, local-first validator that scans backlog markdown for references and reports any broken links so agents can fix them before/after renames.

# Approach

Add kano-backlog CLI commands that (1) validate links and (2) optionally fix links using explicit remap rules and ID resolution. The validator parses markdown links and Obsidian-style wikilinks, resolves targets within the backlog root, and emits json/markdown reports listing broken references. The fix command rewrites only when a target can be resolved unambiguously.

# Acceptance Criteria

- admin validate links reports broken references with source path, line, and target. - admin links fix supports --remap-root, --resolve-id, dry-run output, and --apply for rewrites. - Running fix with resolve-id/remap rules only rewrites links that resolve unambiguously; remaining issues are missing or ambiguous targets.

# Risks / Dependencies

Risk: false positives from unusual link formats or non-backlog targets; mitigate by allowing explicit allowlist/ignore patterns. Performance risk on large repos; mitigate with streaming file scan and rg-based prefiltering.

# Worklog

2026-01-16 08:16 [agent=codex] [model=unknown] Created item
2026-01-16 08:19 [agent=codex] [model=unknown] Start implementing link integrity validator command and ops support.
2026-01-16 08:25 [agent=codex] [model=unknown] Implemented admin validate links command with ops-level scanner for markdown links and wikilinks, legacy _kano/backlog path remap to per-product layout, and ID-based resolution; added json/markdown output and ignore-target patterns. Initial run reports existing broken refs in demo content (expected to be resolved later).
2026-01-16 09:44 [agent=codex] [model=unknown] Added admin links fix command with remap-root and resolve-id strategies; ops fix_links applies safe rewrites and reports changes (dry-run by default).
2026-01-16 09:47 [agent=codex] [model=unknown] Applied admin links fix with resolve-id and remap-root; updated acceptance criteria to focus on unambiguous rewrites and reporting of remaining missing/ambiguous targets.
2026-01-16 09:47 [agent=codex] [model=unknown] Completed link validation and fix commands; updated criteria to reflect unambiguous rewrites and reporting.
