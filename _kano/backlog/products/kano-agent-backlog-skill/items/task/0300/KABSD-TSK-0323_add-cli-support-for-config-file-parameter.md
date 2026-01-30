---
area: general
created: '2026-01-30'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0323
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: None
parent: KABSD-FTR-0063
priority: P2
state: Done
tags: []
title: Add CLI support for --config-file parameter
type: Task
uid: 019c0c0a-f655-73e9-902a-4b22ff027a2a
updated: '2026-01-30'
---

# Context

Users need ability to specify custom project config file locations via CLI parameter, enabling flexible deployment scenarios and testing with different configurations.

# Goal

Add --config-file parameter to CLI commands that allows users to specify custom .kano/backlog_config.toml file locations.

# Approach

1. Add --config-file parameter to main CLI app 2. Update ConfigLoader to accept config file path override 3. Modify resolve_product_root to use custom config path 4. Add validation for config file existence and format 5. Update help documentation

# Acceptance Criteria

1. --config-file parameter available on all relevant commands 2. Custom config files load correctly 3. Path validation with clear error messages 4. Works with both relative and absolute paths 5. Maintains backward compatibility when not specified 6. Help documentation updated

# Risks / Dependencies

Path resolution complexity, potential conflicts with auto-discovery logic

# Worklog

2026-01-30 07:16 [agent=kiro] Created item [Parent Ready gate validated]
2026-01-30 08:09 [agent=kiro] State -> Ready.
2026-01-30 08:16 [agent=kiro] State -> Done.
2026-01-30 08:16 [agent=kiro] [model=unknown] Implemented --config-file parameter support. Added global config file storage, updated ConfigLoader and utility functions to support custom config file paths. Supports both relative and absolute paths, maintains backward compatibility. Tested with various scenarios including custom config files, multiple products, and path resolution.