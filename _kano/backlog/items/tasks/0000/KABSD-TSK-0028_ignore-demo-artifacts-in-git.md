---
id: KABSD-TSK-0028
type: Task
title: "Ignore demo artifacts in git"
state: Done
priority: P2
parent: KABSD-FTR-0003
area: repo
iteration: null
tags: ["gitignore"]
created: 2026-01-04
updated: 2026-01-04
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

Local logs, sandbox output, and test artifacts are generated during demo runs. The current `.gitignore` only covers a subset, so extra files keep showing up in `git status` and risk accidental commits.

# Goal

Ignore generated/demo artifacts (logs, sandbox output, cache files) without hiding the source-of-truth backlog or skill content.

# Non-Goals

- Removing already committed files.
- Ignoring backlog items, config, or skill scripts that are part of the demo.

# Approach

- Audit current generated paths (logs, sandbox, temp test data).
- Add targeted ignore rules for demo artifacts and Python cache files.
- Keep existing tracked Obsidian config unless explicitly marked as local-only.

# Alternatives

Continue cleaning artifacts manually or stash them outside the repo.

# Acceptance Criteria

- `.gitignore` covers log output, sandbox paths, temp test directories, and Python cache files.
- Running demo/test scripts does not introduce new untracked files.

# Risks / Dependencies

- Over-ignoring files that are meant to be shared with the demo (review each rule).

# Worklog

2026-01-04 21:26 [agent=codex] Created from template.
2026-01-04 21:29 [agent=codex] Filled Ready sections for gitignore update.
2026-01-04 21:29 [agent=codex] State -> Ready.
2026-01-04 21:30 [agent=codex] Updated .gitignore for demo artifacts, sandbox, and Python cache.
