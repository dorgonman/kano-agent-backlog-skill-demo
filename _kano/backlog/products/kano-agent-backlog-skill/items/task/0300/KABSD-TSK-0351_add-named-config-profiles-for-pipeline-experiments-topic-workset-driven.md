---
area: general
created: '2026-02-01'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0351
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
title: Add named config profiles for pipeline experiments (topic/workset driven)
type: Task
uid: 019c18d9-7d30-742f-a0a7-5b0cf5b00c40
updated: 2026-02-01
---

# Context

Config-driven switching exists, but it's currently manual to edit TOML layers to try different pipeline combinations. For systematic evaluation (local vs paid, different tokenizers/chunking), we want named profiles or a quick switch mechanism.

# Goal

Provide a first-class way to define and select named pipeline config profiles (e.g., 'local-st', 'openai-paid') without editing base config each time.

# Approach

1. Define where profiles live (e.g., topic config directory or _shared/profiles). 2. Add CLI option like --profile <name> that loads and merges a profile layer above product config. 3. Ensure profile can override chunking/tokenizer/embedding/vector settings using flattened keys schema. 4. Add command to list profiles and show effective config.

# Acceptance Criteria

1. Can run kano-backlog embedding build/query with --profile to switch pipeline. 2. Profiles are file-based and git-trackable. 3. Effective config display shows profile layer applied.

# Risks / Dependencies

Need to keep config precedence understandable; document clearly.

# Worklog

2026-02-01 18:57 [agent=opencode] Created item
2026-02-01 19:08 [agent=opencode] State -> InProgress. [Ready gate validated]
2026-02-01 19:09 [agent=opencode] Workset initialized: D:\_work\_Kano\kano-agent-backlog-skill-demo\_kano\backlog\.cache\worksets\items\KABSD-TSK-0351
2026-02-01 19:29 [agent=opencode] State -> Done.
