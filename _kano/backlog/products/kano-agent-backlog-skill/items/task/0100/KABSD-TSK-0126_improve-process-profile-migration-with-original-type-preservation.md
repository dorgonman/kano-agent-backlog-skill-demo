---
area: config
created: 2026-01-08
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0126
iteration: null
links:
  blocked_by: []
  blocks: []
  relates: []
owner: null
parent: KABSD-FTR-0004
priority: P2
state: Done
tags:
- process-migration
- realign
- type-mapping
title: Improve process profile migration with original type preservation
type: Task
uid: 019bac4a-683d-72cc-a977-a50ff79e7289
updated: 2026-01-08
---

# Context

The current realign.py tool has an irreversible type conversion problem when handling work item type mapping between Azure Boards and Jira:

**Azure → Jira Mapping:**
- Epic → Epic
- Feature → Epic
- UserStory → Story
- Task → Task
- Bug → Bug
- SubTask (not handled)

**Jira → Azure Mapping:**
- Epic → Epic
- ??? → Feature (cannot reverse map)
- Story → UserStory
- Task → Task
- Bug → Bug
- SubTask → ??? (no corresponding type)

This means conversion only works one direction: Azure to Jira, but not back from Jira to Azure.

# Goal

Improve the realign.py tool to preserve original type information when type mapping is not a complete match, ensuring bidirectional conversion reversibility.

# Approach

1. During conversion, if the target profile lacks a corresponding work item type, record the original type in frontmatter (e.g., `original_type` field)
2. Move the work item to the closest matching type folder
3. On reverse conversion, prioritize using the saved original type information to restore the original state

# Acceptance Criteria

- [x] Support saving original type information in frontmatter (e.g., `original_type` field)
- [x] When target profile lacks corresponding type, select closest matching type and record original type
- [x] Reverse conversion can restore original type
- [x] Update mapping logic to support bidirectional conversion
- [x] Add test cases verifying conversion reversibility

# Risks / Dependencies

- Requires modifying frontmatter schema to support original_type field
- May require updating other tools that depend on type field

# Worklog

2026-01-08 [agent=copilot] Created task to improve reversibility of process profile conversion
2026-01-08 [agent=q] Implemented improved realign.py tool with:
- original_type field preservation in frontmatter
- Smart type mapping logic supporting Azure ↔ Jira bidirectional conversion
- Hierarchical fallback mechanism for closest type selection
- Priority restoration of original types during reverse conversion
- Complete error handling and detailed logging output
Testing verified: Azure → Jira → Azure conversion is fully reversible with original type information preserved.