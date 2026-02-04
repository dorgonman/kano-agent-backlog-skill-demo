---
area: general
created: '2026-02-04'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0362
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
title: Add default profile guidance to project config template
type: Task
uid: 019c26ee-34dd-70af-a35d-b702c5684840
updated: 2026-02-04
---

# Context

We want project config to document default profile usage and list built-in profiles. CLI --profile remains the override. This should be documented near the profile field in .kano/backlog_config.toml template.

# Goal

Document how to set a default profile in backlog_config.toml and list available built-in profiles for embedding, with CLI override note.

# Approach

Update backlog_config.toml template comments: add optional default profile field and explain shorthand/explicit path; list built-in profiles from skills/kano-agent-backlog-skill/profiles/embedding. Keep English-only comments.

# Acceptance Criteria

- backlog_config.toml contains a commented default profile field with usage instructions. - Comments list built-in embedding profiles (local-noop, gemini-embedding-001, etc.) and note CLI override precedence.

# Risks / Dependencies

Profile list may drift if new profiles are added; keep comments lightweight and accurate.

# Worklog

2026-02-04 12:34 [agent=opencode] Created item
2026-02-04 12:34 [agent=opencode] Add default profile guidance to backlog_config.toml [Ready gate validated]
2026-02-04 12:36 [agent=opencode] [model=unknown] Added default profile guidance comment block in .kano/backlog_config.toml with built-in profile paths and shorthand usage; CLI --profile remains override.
2026-02-04 12:36 [agent=opencode] Added default profile guidance comments in .kano/backlog_config.toml
