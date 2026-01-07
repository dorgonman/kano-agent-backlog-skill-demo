---
id: KCCS-USR-0002
uid: 019b9866-a89b-7b7a-b765-7f1f3be80bf1
type: Story
title: "Develop install_hooks.py script"
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
Developers need an easy way to enable KCC linter in their local repositories.

# Goal
Provide an `install_hooks.py` script to setup the `commit-msg` hook.

# Approach
- The script should detect the `.git` directory.
- Create or update `.git/hooks/commit-msg`.
- Ensure the hook is executable.
- Provide an `--uninstall` flag to remove the hook.

# Acceptance Criteria
- [ ] `python install_hooks.py` successfully installs the hook.
- [ ] `python install_hooks.py --uninstall` successfully removes the hook.
- [ ] Works on Windows (where Git hooks are executed via sh/bash inside Git Bash).

# Risks / Dependencies
- Overwriting existing user hooks (should probably warn or append).

2026-01-07 20:20 [agent=antigravity] Created from template.
