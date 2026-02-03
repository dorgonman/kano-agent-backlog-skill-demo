---
area: embedding
created: '2026-02-03'
decisions: []
external:
  azure_id: null
  jira_key: null
id: KABSD-TSK-0357
iteration: backlog
links:
  blocked_by: []
  blocks: []
  relates: []
owner: opencode
parent: null
priority: P2
state: InProgress
tags:
- gemini
- embedding
- vector
title: Add Gemini embedding provider (gemini-embedding-001)
type: Task
uid: 019c21de-5ce4-747a-be2c-e46214549384
updated: '2026-02-03'
---

# Context

User wants Gemini embeddings (gemini-embedding-001) using free API key in env/local.secrets.env. We must add a new embedding provider in the local-first pipeline with optional dependency and env-based auth.

# Goal

Support gemini-embedding-001 in embedding/vector pipeline with optional dependency and profile example; no secrets in repo.

# Approach

Implement a new EmbeddingAdapter using google-genai (Gemini Developer API). Add provider in embedding factory; accept api_key via env ref (GEMINI_API_KEY or GOOGLE_API_KEY). Add profile under .kano/backlog_config/embedding and document usage in SKILL.md + embedding_pipeline.md. Add optional dependency check/test similar to sentence-transformers.

# Acceptance Criteria

-  works with model gemini-embedding-001.
- Auth is via env var (no secrets in config).
- Profile example provided.
- Docs updated with install and usage.
- Tests cover missing dependency behavior.
- pyright clean on changed files.

# Risks / Dependencies

Risk: SDK API changes. Mitigation: use official google-genai SDK docs, keep adapter thin and fail fast if import missing.

# Worklog

2026-02-03 12:59 [agent=opencode] Created item
2026-02-03 12:59 [agent=opencode] Ready: Gemini embedding support scoped.
2026-02-03 12:59 [agent=opencode] Start: implement Gemini embedding adapter + docs + profile. [Ready gate validated]
2026-02-03 13:03 [agent=opencode] Workset initialized: D:\_work\_Kano\kano-agent-backlog-skill-demo\_kano\backlog\.cache\worksets\items\KABSD-TSK-0357
2026-02-03 13:14 [agent=opencode] [model=unknown] Implemented Gemini embedding adapter + factory wiring, added gemini profile/docs/tests. Blocked: unable to create .venv (venvlauncher copy/symlink errors), so pytest/pyright not run; lsp_diagnostics still reports pyright errors for gemini_adapter.
2026-02-03 13:22 [agent=opencode] [model=unknown] Created venv, installed dev deps, ran pyright on changed files (0 errors). pytest skills/kano-agent-backlog-skill/tests/test_gemini_optional_dependency.py passed (2 tests). Pydantic deprecation warnings pre-existing.
2026-02-03 13:34 [agent=opencode] [model=unknown] Fixed backlog_vector_index indentation error; moved embedding profiles so .kano/backlog_config/embedding keeps only local-noop and added gemini profile under skills profiles. Smoke test failed due to missing GEMINI_API_KEY/GOOGLE_API_KEY (google-genai installed).