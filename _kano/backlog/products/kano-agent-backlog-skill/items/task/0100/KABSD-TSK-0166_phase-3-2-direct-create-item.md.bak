---
id: KABSD-TSK-0166
uid: a7e2b1c9-4d8f-4a2e-8b1f-7c9d6e4a3f2b
type: Task
title: "Phase 3.2: Direct create_item Implementation"
state: Done
priority: P1
parent: KABSD-FTR-0028
area: kano-agent-backlog-skill
iteration: active
tags: [refactor, ops-layer, cli]
created: 2025-01-11
updated: 2025-01-11
owner: null
external:
  azure_id: null
  jira_key: null
links:
  relates: [KABSD-ADR-0013, KABSD-ADR-0014]
  blocks: [KABSD-TSK-0167]
  blocked_by: []
decisions: [KABSD-ADR-0013]
---

# Context

Phase 3 of skill refactoring removes subprocess delegation and implements logic directly in the ops layer. Phase 3.2 focused on `create_item` - the first major operation requiring complete rewrite.

Started with utility extraction (Phase 3.1) and template rendering foundation.

# Goal

Replace subprocess delegation in workitem.create_item() with direct implementation:
- Generate sequential IDs without calling workitem_create.py script
- Render item frontmatter and template sections directly
- Create Epic index files for epic items
- Update index registry when creating epics
- Handle all file I/O internally

# Approach

1. Created item_templates.py module with:
   - render_item_frontmatter(): Generate YAML frontmatter
   - render_item_body(): Generate complete markdown (frontmatter + sections)
   - render_epic_index(): Generate Epic index MOC file

2. Updated workitem.py create_item():
   - Use ConfigLoader to find backlog root
   - Derive prefix from product name
   - Find next available ID number
   - Calculate storage path (subdir/bucket/filename)
   - Generate content with templates
   - Write files directly
   - Update index registry for Epics
   - Return CreateItemResult

3. Tested successfully with DM-TSK-0001 item creation

# Acceptance Criteria

- [x] create_item() works without subprocess calls
- [x] Generates sequential IDs correctly
- [x] Creates YAML frontmatter properly
- [x] Creates markdown sections
- [x] Creates Epic index files
- [x] Updates index registry
- [x] Test item created and verified
- [x] All required sections present in output

# Risks / Dependencies

- Breaking change: ops layer now has direct implementation, scripts still use subprocess delegation
- Need to migrate CLI commands next (Phase 3.5) to fully benefit
- Depends on: Phase 3.1 (utilities), KABSD-ADR-0013 (architecture), KABSD-FTR-0028 (feature)

# Worklog

2025-01-11 [agent=assistant] Created item_templates.py with template rendering functions for frontmatter and body sections.
2025-01-11 [agent=assistant] Rewrote create_item() function to use direct logic instead of subprocess delegation. Implemented ID generation, path calculation, content rendering, and file I/O.
2025-01-11 [agent=assistant] Fixed ItemType enum references (USER_STORY not USERSTORY) and parameter signatures for utilities.
2025-01-11 [agent=assistant] Successfully tested create_item() - created test task DM-TSK-0001 with proper structure. Verified YAML frontmatter and markdown sections.
2025-01-11 [agent=assistant] Marked Phase 3.2 as complete and created this task to document completion.
