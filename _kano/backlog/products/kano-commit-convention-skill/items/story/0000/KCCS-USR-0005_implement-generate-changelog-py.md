---
id: KCCS-USR-0005
uid: 019b9866-b72f-7de5-8f06-7ce4a259558c
type: Story
title: "Implement generate_changelog.py"
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
Manual changelogs are tedious and error-prone. Since we enforce KCC-STCC format, we can reliably automate this process.

# Goal
Create a Python script `generate_changelog.py` that parses git history and outputs a formatted Markdown changelog.

# Non-Goals
- Integration with GitHub Releases API (file generation only).
- Intelligent summarization (LLM-based) - strictly rule-based for now.

# Approach
- **CLI Arguments**: `--from-ref`, `--to-ref`, `--output` (optional).
- **Git Interface**: Use `subprocess` to call `git log --format="%s"`.
- **Parsing**:
    - Use KCC regex to extract fields.
    - Collect `[Breaking]` flags.
- **Rendering**:
    - Group by `Type` (e.g., `## Features`, `## BugFixes`).
    - Sort within groups (maybe by Subsystem).
    - Format: `- **[Subsystem]** Summary ([Ticket](link))`
    - Link Generation: If ticket ID exists in `_kano/backlog/products/*/items/...`, link to that file. Otherwise link to a dummy search URL or just text.
- **Prepend**: If `--output` file exists, prepend the new entry (keeping the old history).

# Acceptance Criteria
- [ ] `generate_changelog.py` produces correct Markdown output for a given range.
- [ ] Commits grouped by Type.
- [ ] Breaking changes listed in a dedicated "Breaking Changes" section at the top.
- [ ] Ticket IDs are linked to local backlog files if found.
- [ ] Non-compliant commits are listed under "Other Changes" or filtered out (configurable).

# Risks / Dependencies
- Git history might contain non-compliant commits if the hook wasn't always active. The script needs to handle parsing failures gracefully.

2026-01-07 20:20 [agent=antigravity] Created from template.
