# AGENTS

## Repo purpose
This repo is a demo showing how to use `kano-agent-backlog-skill` to turn agent collaboration
into a durable, local-first backlog with an auditable decision trail (instead of losing context in chat).

## Key paths
- Skill (submodule): `skills/kano-agent-backlog-skill/`
  - Rules entrypoint: `skills/kano-agent-backlog-skill/SKILL.md`
  - References: `skills/kano-agent-backlog-skill/references/`
- Demo backlog (system of record): `_kano/backlog/`
  - Items: `_kano/backlog/items/`
  - ADRs: `_kano/backlog/decisions/`
  - Views: `_kano/backlog/views/`
  - Tools (deprecated stubs): `_kano/backlog/tools/` (use skill scripts directly)

## Backlog discipline (this repo)
- Use `skills/kano-agent-backlog-skill/SKILL.md` for any planning/backlog work.
- Before any code change, create/update items in `_kano/backlog/items/` (Epic -> Feature -> UserStory -> Task/Bug).
- Enforce the Ready gate on Task/Bug (required, non-empty): `Context`, `Goal`, `Approach`, `Acceptance Criteria`, `Risks / Dependencies`.
- Worklog is append-only; never rewrite history. Append a Worklog line whenever:
  - a load-bearing decision is made,
  - an item state changes,
  - scope/approach changes,
  - or an ADR is created/linked.
- Use `skills/kano-agent-backlog-skill/scripts/backlog/update_state.py` for state transitions so `state`, `updated`, and Worklog stay consistent.
- For backlog/skill file operations, use `skills/kano-agent-backlog-skill/scripts/backlog/*` or `scripts/fs/*` so audit logs capture the action.
- Skill scripts refuse paths outside `_kano/backlog/`; confirm your target path is under that root.
- Keep backlog volume under control: only open new items for code/design changes; keep Tasks/Bugs sized to one focused session; avoid ADRs unless there is a real architectural trade-off.
- Ticketing threshold (agent-decided):
  - Open a new Task/Bug when you will change code/docs/views/scripts.
  - Open an ADR (and link it) when a real trade-off or direction change is decided.
  - Otherwise, record the discussion in an existing Worklog; ask if unsure.
- State ownership: the agent decides when to move items to InProgress or Done; humans observe and can add context.

## Naming and storage rules (short)
- Store items under `_kano/backlog/items/<type>/<bucket>/` and bucket per 100 (`0000`, `0100`, ...).
- Filenames are stable: `<ID>_<slug>.md` (ASCII slug).
- For Epics, create an adjacent `<ID>_<slug>.index.md` MOC and register it in `_kano/backlog/_meta/indexes.md`.

## Views (human-friendly)
- Obsidian Dataview dashboards live under `_kano/backlog/views/` (e.g. `_kano/backlog/views/Dashboard.md`).
- Generate plain Markdown views (no Dataview required):
  - `python skills/kano-agent-backlog-skill/scripts/backlog/generate_view.py --groups "New,InProgress" --title "Active Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Active.md`
  - `python skills/kano-agent-backlog-skill/scripts/backlog/generate_view.py --groups "New" --title "New Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_New.md`
  - `python skills/kano-agent-backlog-skill/scripts/backlog/generate_view.py --groups "Done" --title "Done Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Done.md`
  - Note: `_kano/backlog/tools/*.sh` are deprecated.

## Demo principles
- Keep the demo backlog small and traceable; avoid ticket spam.
- Avoid unrelated refactors; every meaningful change should be explainable via a backlog item or ADR (with verification steps).
- If you change the skill itself, commit inside the submodule `skills/kano-agent-backlog-skill/` and update the parent repo submodule pointer.
- Self-contained skill stance (this demo repo):
  - Prefer implementing automation as skill scripts (`skills/kano-agent-backlog-skill/scripts/`) so the skill is usable without manual setup.
  - Avoid wrapper scripts in `_kano/backlog/tools/`; reserve wrappers only when hook points are needed.
  - Other projects may choose override-only usage; this repo does not. Treat the skill as the source of truth.

## Tests
No tests or build steps are defined yet.
