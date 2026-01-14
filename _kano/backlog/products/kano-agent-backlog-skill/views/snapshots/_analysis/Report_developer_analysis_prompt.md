You are writing a short *analysis* section for a project status report.

Persona focus: developer (technical progress, blockers, concrete next steps, and verification commands)

Strict rules:
1) ONLY use facts that appear in the provided report content. Do not invent items, states, counts, or commands.
2) If information is missing, say "Unknown from the report" and suggest what to capture in backlog to make it known.
3) Output MUST be Markdown.
4) Keep it concise (max ~200 lines).

Required sections (use these exact headings):
## LLM Analysis
### Key Observations
### Risks / Unknowns
### Recommendations (Actionable)

Report content (SSOT):
---
# Project Status Report (developer)

- Generated: 2026-01-10 06:38 UTC
- Source: `sqlite:_kano\backlog\products\kano-agent-backlog-skill\_index\backlog.sqlite3`
- Product: `kano-agent-backlog-skill`

## Snapshot

- New: **93** (Proposed/Planned/Ready)
- InProgress: **8** (InProgress/Blocked/Review)
- Done: **134** (Done/Dropped)

## What to focus on (developer)

### Continue (InProgress/Blocked/Review)
- [kano-agent-backlog-skill] `KABSD-TSK-0083` [Task] (InProgress, P1) Update CLI scripts for product-aware execution
- [kano-agent-backlog-skill] `KABSD-TSK-0110` [Task] (InProgress, P2) Evaluate VCS Query Cache Layer

### Next (Ready)
- [kano-agent-backlog-skill] `KABSD-TSK-0035` [Task] (Ready, P1) Verify agent compliance with skill workflow
- [kano-agent-backlog-skill] `KABSD-TSK-0092` [Task] (Ready, P3) Implement global embedding database for cross-product semantic search

### Recently completed (sanity check)
- [kano-agent-backlog-skill] `KABSD-TSK-0136` [Task] (Done, P2) Fix gitignore for derived data compliance
- [kano-agent-backlog-skill] `KABSD-TSK-0145` [Task] (Done, P1) Add prerequisite install script for Python deps (self-contained skill)
- [kano-agent-backlog-skill] `KABSD-BUG-0001` [Bug] (Done, P0) workitem_update_state crashes: args.model attribute missing
- [kano-agent-backlog-skill] `KABSD-TSK-0146` [Task] (Done, P1) Clarify config: replace mode.role with mode.skill_developer + persona
- [kano-agent-backlog-skill] `KABSD-TSK-0147` [Task] (Done, P2) Persona-aware project summary generation in view_refresh_dashboards
- [kano-agent-backlog-skill] `KABSD-TSK-0148` [Task] (Done, P1) Deterministic persona reports (developer/pm/qa) for project status
- [kano-agent-backlog-skill] `KABSD-TSK-0149` [Task] (Done, P2) Optional LLM analysis appended to deterministic persona reports
- [kano-agent-backlog-skill] `KABSD-TSK-0150` [Task] (Done, P2) Add --all-personas to view_refresh_dashboards
- [kano-agent-backlog-skill] `KABSD-TSK-0078` [Task] (Done, P2) Fix SQLite index schema mismatch (missing source_path)
- [kano-agent-backlog-skill] `KABSD-TSK-0056` [Task] (Done, P4) Define embedding chunking + metadata schema for backlog items

## How to refresh

Use `view_refresh_dashboards.py` to regenerate dashboards and persona outputs.

---
