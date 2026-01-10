---
id: KABSD-TSK-0167
uid: b8f3c2d1-5e9a-4b3f-9c2e-8d7f6a5e4d3c
type: Task
title: "Phase 3.3-3.4: Direct update_state and validate_ready Implementation"
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
  blocks: [KABSD-TSK-0168]
  blocked_by: [KABSD-TSK-0166]
decisions: [KABSD-ADR-0013]
---

# Context

Phase 3 refactoring removes subprocess delegation. After successful direct create_item implementation (Phase 3.2), we now implement direct update_state and validate_ready to complete the core operations layer.

# Goal

Replace subprocess delegation for state transitions and validation:
- Parse YAML frontmatter directly
- Update state, timestamp, and owner fields
- Append worklog entries with proper formatting
- Validate items against Ready gate criteria
- Auto-assign owner when moving to InProgress

# Approach

1. Created frontmatter.py module:
   - parse_frontmatter(): Extract YAML key-value pairs
   - update_frontmatter(): Modify state, updated, owner fields
   - find_frontmatter_delimiters(): Locate YAML boundaries
   - load_lines()/write_lines(): File I/O helpers

2. Created worklog.py module:
   - ensure_worklog_section(): Create section if missing
   - append_worklog_entry(): Add timestamped entries
   - get_worklog_entries(): Read all entries

3. Implemented update_state():
   - Resolves item by ID or path
   - Loads and parses frontmatter
   - Updates state, updated date, owner
   - Appends worklog entry
   - Writes file directly
   - Returns UpdateStateResult

4. Implemented validate_ready():
   - Checks for required sections (Task/Bug only)
   - Returns ValidationResult with missing sections
   - Works for any item type

# Acceptance Criteria

- [x] Frontmatter parsing works correctly
- [x] update_state() transitions work
- [x] State field updated in frontmatter
- [x] Updated date field updated
- [x] Owner auto-assigned on InProgress
- [x] Worklog entries append correctly
- [x] validate_ready() recognizes sections
- [x] Tested successfully with DM-TSK-0002

# Risks / Dependencies

- Breaking change: CLI still uses old scripts, need to migrate (Phase 3.5)
- Depends on: Phase 3.2 (create_item), KABSD-ADR-0013, KABSD-FTR-0028

# Worklog

2025-01-11 [agent=assistant] Created frontmatter.py module with YAML parsing, update, and file I/O functions.
2025-01-11 [agent=assistant] Created worklog.py module with worklog section management and entry appending.
2025-01-11 [agent=assistant] Implemented update_state() with direct logic - parses frontmatter, updates fields, appends worklog, writes file.
2025-01-11 [agent=assistant] Implemented validate_ready() to check required sections for Ready gate validation.
2025-01-11 [agent=assistant] Tested update_state() successfully - created DM-TSK-0002, transitioned to InProgress, verified worklog appended and state changed.
2025-01-11 [agent=assistant] Tested validate_ready() successfully - recognizes sections from template, validates item status.
