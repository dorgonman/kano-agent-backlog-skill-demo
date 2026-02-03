---
area: general
created: '2026-02-03'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0358
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
title: Auto-load local.secrets.env with override env file
type: Task
uid: 019c2204-5457-71ed-92ea-0408a6ae8f95
updated: 2026-02-03
---

# Context

Gemini pipeline run failed because env/local.secrets.env is not auto-loaded, so GEMINI_API_KEY was not set for the CLI process. We want default auto-load for local dev.

# Goal

Auto-load env/local.secrets.env by default and allow explicit override via --env-file or KANO_ENV_FILE.

# Approach

Load env vars early in CLI startup. Default to env/local.secrets.env if present, unless --env-file or KANO_ENV_FILE is provided. Override semantics: explicit path replaces default.

# Acceptance Criteria

CLI auto-loads env/local.secrets.env when present; --env-file and KANO_ENV_FILE override the default; no secrets printed; docs updated to mention behavior.

# Risks / Dependencies

Avoid unintended secret loading in non-local contexts; ensure missing file is ignored gracefully.

# Worklog

2026-02-03 13:40 [agent=opencode] Created item
2026-02-03 13:40 [agent=opencode] Start implementing env auto-load with override support [Ready gate validated]
2026-02-03 13:44 [agent=opencode] [model=unknown] Added CLI env auto-load (env/local.secrets.env) with --env-file and KANO_ENV_FILE override. Gemini smoke test succeeded after auto-load; tokenizer fell back to heuristic due to missing tiktoken/huggingface. Pyright on util.py reports pre-existing errors.
2026-02-03 13:44 [agent=opencode] Auto-load env file + override support implemented and verified
