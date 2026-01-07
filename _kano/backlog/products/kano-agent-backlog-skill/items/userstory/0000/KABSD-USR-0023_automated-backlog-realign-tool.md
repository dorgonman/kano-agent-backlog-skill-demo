---
id: KABSD-USR-0023
uid: 019b98ab-3023-7a9d-b8ac-2bb9a5e2f03f
type: UserStory
title: "Automated backlog realignment tool"
state: InProgress
priority: P1
parent: KABSD-FTR-0004
area: infra
iteration: null
tags: [tooling]
created: 2026-01-07
updated: 2026-01-07
owner: antigravity
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
decisions: []
original_type: UserStory
---

# Context
Manually moving folders and updating `type` fields when changing process profiles (e.g., from `azure-boards-agile` to `jira-default`) is error-prone and time-consuming.

# Goal
Implement `backlog_realign.py` to automate the migration of a product's backlog items to match the folder structure and item types defined in its process profile.

# Approach
- Read the product's `config.json` to identify the active process profile.
- Load the process profile (JSON) and extract the mapping of item types to slugs.
- Scan the product's `items/` directory.
- For each folder that doesn't match a target slug but contains items of a specific type, move them and update their frontmatter.
- Perform the migration in a safe, repeatable way.

# Acceptance Criteria
- [ ] Tool correctly identifies mismatches between folder names and profile slugs.
- [ ] Tool moves files to correct slug-named folders.
- [ ] Tool updates `type` in frontmatter to match the profile's `type` names.
- [ ] Tool cleans up empty old folders.
- [ ] Tool can be run across multiple products or a single product.

# Worklog
2026-01-07 22:05 [agent=antigravity] Created ticket and started implementation.
