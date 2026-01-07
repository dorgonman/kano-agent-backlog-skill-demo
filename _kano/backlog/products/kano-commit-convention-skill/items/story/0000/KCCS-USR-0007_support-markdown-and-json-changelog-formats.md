---
id: KCCS-USR-0007
uid: 019b9866-c145-7f68-a017-3594d21d02b6
type: Story
title: "Support Markdown and JSON changelog formats"
state: Proposed
priority: P2
parent: KCCS-FTR-0003
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
Markdown is great for humans, but other tools (e.g., a dashboard or a release notification bot) might need structured data.

# Goal
Support JSON output in `generate_changelog.py`.

# Non-Goals
- XML or YAML support (JSON is sufficient).

# Approach
- Add CLI argument: `--format [markdown|json]` (default: markdown).
- Define JSON schema:
  ```json
  [
    {
      "hash": "abc1234",
      "subsystem": "Core",
      "type": "Feature",
      "breaking": false,
      "summary": "Add new API",
      "ticket": "JIRA-123"
    }
  ]
  ```
- Ensure JSON output is standard stdout so it can be piped to `jq` or files.

# Acceptance Criteria
- [ ] `generate_changelog.py --format json` produces valid JSON array.
- [ ] JSON contains all parsed fields from the KCC commit.
- [ ] Characters in summary are properly escaped.

# Risks / Dependencies
- None.

2026-01-07 20:20 [agent=antigravity] Created from template.
