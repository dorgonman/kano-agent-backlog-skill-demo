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
  - Tools: `_kano/backlog/tools/`

## Backlog discipline (this repo)
- Use `skills/kano-agent-backlog-skill/SKILL.md` for any planning/backlog work.
- Before any code change, create/update items in `_kano/backlog/items/` (Epic -> Feature -> UserStory -> Task/Bug).
- Enforce the Ready gate on Task/Bug (required, non-empty): `Context`, `Goal`, `Approach`, `Acceptance Criteria`, `Risks / Dependencies`.
- Worklog is append-only; never rewrite history. Append a Worklog line whenever:
  - a load-bearing decision is made,
  - an item state changes,
  - scope/approach changes,
  - or an ADR is created/linked.
- Use `_kano/backlog/tools/update_state.py` for state transitions so `state`, `updated`, and Worklog stay consistent.
- Keep backlog volume under control: only open new items for code/design changes; keep Tasks/Bugs sized to one focused session; avoid ADRs unless there is a real architectural trade-off.

## Naming and storage rules (short)
- Store items under `_kano/backlog/items/<type>/<bucket>/` and bucket per 100 (`0000`, `0100`, ...).
- Filenames are stable: `<ID>_<slug>.md` (ASCII slug).
- For Epics, create an adjacent `<ID>_<slug>.index.md` MOC and register it in `_kano/backlog/_meta/indexes.md`.

## Views (human-friendly)
- Obsidian Dataview dashboards live under `_kano/backlog/views/` (e.g. `_kano/backlog/views/Dashboard.md`).
- Generate plain Markdown views (no Dataview required):
  - `python _kano/backlog/tools/generate_view.py --groups "New,InProgress" --title "Active Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Active.md`
  - `python _kano/backlog/tools/generate_view.py --groups "New" --title "New Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_New.md`
  - `python _kano/backlog/tools/generate_view.py --groups "Done" --title "Done Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Done.md`
  - Note: `_kano/backlog/tools/*.sh` are bash scripts; on Windows prefer the `python` commands above.

## Demo principles
- Keep the demo backlog small and traceable; avoid ticket spam.
- Avoid unrelated refactors; every meaningful change should be explainable via a backlog item or ADR (with verification steps).
- If you change the skill itself, commit inside the submodule `skills/kano-agent-backlog-skill/` and update the parent repo submodule pointer.

## Tests
No tests or build steps are defined yet.
