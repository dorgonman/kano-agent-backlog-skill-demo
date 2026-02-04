---
area: general
created: '2026-02-04'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-BUG-0011
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: InProgress
tags: []
title: Embedding build ignores gemini profile + --force unlink fails when DB in use
type: Bug
uid: 019c26c1-4b6d-732e-871d-56f5c7d0cd72
updated: '2026-02-04'
---

# Context

Embedding build with gemini profile should use gemini provider and cache root. Currently it runs with noop provider and tries to unlink an in-use DB, causing WinError 32, then proceeds with noop build. This was observed while running embedding build with KANO_ENV_FILE and --env-file overrides.

# Goal

Ensure embedding build honors profile/provider and handles --force deletion safely on Windows. Verify env overrides work and DB lands under .kano/cache/backlog.

# Approach

1) Investigate build_vector_index/profile resolution; ensure effective config is used during full product build. 2) Adjust --force behavior to handle locked DB (skip unlink or rename with warning) and still build. 3) Validate with gemini profile using KANO_ENV_FILE and --env-file.

# Acceptance Criteria

- Embedding build with gemini profile uses gemini provider (not noop). - No WinError 32 crash when --force and DB locked; command completes with warning. - Gemini vector DB appears under .kano/cache/backlog with non-unknown corpus naming. - Both KANO_ENV_FILE and --env-file paths allow build to proceed.

# Risks / Dependencies

Gemini API availability or invalid keys; Windows file locks during sqlite operations.

# Worklog

2026-02-04 11:45 [agent=opencode] Created item
2026-02-04 11:46 [agent=opencode] Investigating gemini profile build + --force DB lock issue [Ready gate validated]
2026-02-04 11:55 [agent=opencode] [model=unknown] Repro: embedding build with gemini profile and env overrides. KANO_ENV_FILE run: profile resolves to gemini, cache_root=.kano/cache/backlog, warns on locked DB delete, then proceeds. --env-file run: API call fails with 429 RESOURCE_EXHAUSTED (quota/rate limit). Evidence: tool output tool_c26c553f4001o1Ujwfo0CrsfYn lines 1229-1237 show 429; build command reached Gemini API (uses GOOGLE_API_KEY).