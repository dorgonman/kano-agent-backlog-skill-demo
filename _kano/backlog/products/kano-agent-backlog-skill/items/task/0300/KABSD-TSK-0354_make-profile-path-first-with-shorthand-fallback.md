---
area: config
created: '2026-02-02'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0354
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: Done
tags:
- config
- profiles
title: Make --profile path-first with shorthand fallback
type: Task
uid: 019c1a3e-280f-72e8-b149-0156e7f2050a
updated: 2026-02-02
---

# Context

--profile now supports both path and shorthand. Ambiguity still exists for values like embedding/local-noop which could be interpreted as a repo-root relative path. User preference: try filesystem path first, and only fall back to shorthand if no file exists.

# Goal

Make --profile resolution path-first: treat the argument as an absolute or repo-root relative path if such a file exists; otherwise treat it as shorthand under .kano/backlog_config/.

# Approach

Update ConfigLoader.load_profile_overrides: always attempt to resolve and load an existing absolute/repo-relative .toml file (adding .toml suffix if omitted). If no file exists at the path candidates, then resolve shorthand under .kano/backlog_config/<ref>.toml. Keep safety: disallow relative paths containing '..' or escaping project root.

# Acceptance Criteria

- --profile embedding/local-noop continues to work via shorthand fallback (since repo_root/embedding/local-noop.toml does not exist).
- --profile .kano/backlog_config/embedding/local-noop.toml works (path mode).
- If repo_root/<arg>.toml exists, it is used.
- Docs explain the fallback rule.
- pyright clean for touched files.

# Risks / Dependencies

Risk: behavior change for users who had a real file at repo_root/<ref>.toml; now that file would take precedence. Mitigation: this matches the path-first rule and is documented.

# Worklog

2026-02-02 01:26 [agent=opencode] Created item
2026-02-02 01:27 [agent=opencode] Ready: path-first fallback rule specified.
2026-02-02 01:27 [agent=opencode] Start: implement path-first --profile fallback semantics. [Ready gate validated]
2026-02-02 01:29 [agent=opencode] [model=unknown] Changed --profile ambiguity handling: try existing file path first (absolute or repo-root relative, optional .toml suffix); if no file exists, fall back to shorthand under .kano/backlog_config/. Updated SKILL.md; verified benchmark run.
2026-02-02 01:29 [agent=opencode] Done: --profile path-first with shorthand fallback.
