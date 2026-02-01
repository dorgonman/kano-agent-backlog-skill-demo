---
area: general
created: '2026-02-01'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0348
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: Done
tags: []
title: Remove legacy project config overrides; enforce flattened-only product config
type: Task
uid: 019c182b-d455-74aa-931b-000924491032
updated: 2026-02-01
---

# Context

We are pre-alpha (AGENTS.md) and want to avoid compatibility layers. The project config currently still accepts legacy nested product overrides under [products.<name>.overrides] (and code carries logic around an overrides dict). This makes the schema more complex and requires extra cleanup later.

# Goal

Make .kano/backlog_config.toml product sections flattened-only. Disallow [products.<name>.overrides] entirely. Reject unknown product keys to catch typos early.

# Approach

1. Update kano_backlog_core/project_config.py: ProductDefinition explicitly lists allowed flattened keys; set Pydantic extra=forbid. 2. Remove any reading/merging of product_data['overrides'] in ProjectConfigLoader; if present, raise ConfigError with a clear migration message. 3. Compute product overrides deterministically from flattened keys (ProductDefinition.to_overrides()) and update ConfigLoader.load_project_product_overrides to use it. 4. Update docs/examples (.kano/debug/backlog_config.toml, any other docs) to state flattened-only. 5. Verify by running kano-backlog config show for all products.

# Acceptance Criteria

1. Using [products.<name>.overrides] in .kano/backlog_config.toml fails with a clear error. 2. Unknown keys inside [products.<name>] fail validation. 3. Flattened keys continue to work for all supported sections. 4. kano-backlog config show works for all products in this repo.

# Risks / Dependencies

Breaking change for any repo still using overrides; acceptable in pre-alpha. Need to ensure error message is actionable.

# Worklog

2026-02-01 15:47 [agent=opencode] Created item
2026-02-01 15:47 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-02-01 15:47 [agent=opencode] Workset initialized: D:\_work\_Kano\kano-agent-backlog-skill-demo\_kano\backlog\.cache\worksets\items\KABSD-TSK-0348
2026-02-01 15:54 [agent=opencode] State -> Done.
