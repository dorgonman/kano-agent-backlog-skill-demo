---
id: KCCS-USR-0003
uid: 019b9866-ad77-7e9b-880b-a7c194270500
type: Story
title: "Config-based linter types/scopes"
state: Proposed
priority: P2
parent: KCCS-FTR-0002
area: general
iteration: null
tags: []
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
Different teams might need different allowed types or custom subsystem rules.

# Goal
Support a configuration file to customize the linter behavior.

# Approach
- Search for a `kcc.json` or `.kccrc` file in the repository root.
- Allow overriding the `allowed_types` list.
- (Optional) Allow defining custom regex for tickets if they don't follow the default JIRA-like format.

# Acceptance Criteria
- [ ] Linter uses `kcc.json` if present.
- [ ] If `allowed_types` is defined in config, linter validates against it instead of the default set.
- [ ] Linter falls back to default KCC-STCC rules if no config is found.

# Risks / Dependencies
- Config file parsing errors should be handled gracefully (warn and use defaults).

2026-01-07 20:20 [agent=antigravity] Created from template.
