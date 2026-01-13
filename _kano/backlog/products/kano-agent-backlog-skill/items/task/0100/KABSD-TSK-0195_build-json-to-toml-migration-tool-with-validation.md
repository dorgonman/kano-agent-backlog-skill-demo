---
area: general
created: '2026-01-13'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0195
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0024
priority: P2
state: Done
tags: []
title: Build JSON to TOML migration tool with validation
type: Task
uid: 019bb368-f403-760c-93ef-b23e7915d16e
updated: '2026-01-13'
---

# Context

We are migrating the config system from JSON to TOML (schema v1.0). JSON is deprecated but must remain supported for two minor versions. We need a safe local-first migration tool to convert existing defaults/config.json files to TOML equivalents.

# Goal

Implement a migration command that generates TOML configs from existing JSON layer files with minimal user effort and safe rollback.

# Approach

1) Add an admin command (e.g., ) that scans known config locations (shared/product/topic/workset) 2) For each JSON file found, parse + map keys to TOML tables per schema 3) Write TOML next to JSON (dry-run by default), optionally back up JSON 4) Emit a summary report and next-step guidance

# Acceptance Criteria

Migration tool runs in dry-run mode by default; writes TOML files that match schema sections; does not delete JSON by default; supports backing up originals; produces clear report; unit/integration tests cover mapping for representative configs

# Risks / Dependencies

Schema mismatch for edge-case keys; keeping formatting stable for diffs; avoiding secrets in output

# Worklog

2026-01-13 02:12 [agent=copilot] Created item
2026-01-13 23:45 [agent=antigravity] State -> Done. Verified migrate-json command in config_cmd.py and completed manual repo-wide migration.