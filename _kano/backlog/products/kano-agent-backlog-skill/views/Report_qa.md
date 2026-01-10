# Project Status Report (qa)

- Generated: 2026-01-10 06:38 UTC
- Source: `sqlite:_kano\backlog\products\kano-agent-backlog-skill\_index\backlog.sqlite3`
- Product: `kano-agent-backlog-skill`

## Snapshot

- New: **93** (Proposed/Planned/Ready)
- InProgress: **8** (InProgress/Blocked/Review)
- Done: **134** (Done/Dropped)

## Verification view (qa)

### Review queue (needs verification)
- (none)

### Bugs to triage
- (none)

### Recently done (suggested regression check)
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

### Suggested test notes (best-effort)

- [kano-agent-backlog-skill] `KABSD-TSK-0136`: Fix gitignore for derived data compliance
  - - [x] `backlog.sqlite3` removed from git tracking
  - - [x] All files in `_index/` directories are ignored by git
  - - [x] Only canonical markdown files are tracked
- [kano-agent-backlog-skill] `KABSD-TSK-0145`: Add prerequisite install script for Python deps (self-contained skill)
  - - A single command exists that creates a venv and installs required deps for the skill scripts.
  - - The command is documented in `README.md` and `AGENTS.md`.
  - - The script uses only stdlib so it can run before any dependencies are installed.
- [kano-agent-backlog-skill] `KABSD-BUG-0001`: workitem_update_state crashes: args.model attribute missing
  - Running `python skills/kano-agent-backlog-skill/scripts/backlog/workitem_update_state.py --help` and updating an item state does not raise an exception.
- [kano-agent-backlog-skill] `KABSD-TSK-0146`: Clarify config: replace mode.role with mode.skill_developer + persona
  - All references to `mode.role` are removed and replaced with `mode.skill_developer` and `mode.persona`.
- [kano-agent-backlog-skill] `KABSD-TSK-0147`: Persona-aware project summary generation in view_refresh_dashboards
  - Running `view_refresh_dashboards.py` generates a persona-aware summary file under `views/` without errors.
  - When SQLite index is enabled and present, the summary generator uses it; otherwise it scans files.

## How to refresh

Use `view_refresh_dashboards.py` to regenerate dashboards and persona outputs.
