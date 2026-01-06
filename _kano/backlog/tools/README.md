# Backlog Tools (project-specific)

This folder contains **project-specific** helper scripts for `_kano/backlog/`.

Principle:
- **Generic** backlog workflows live in the skill: `skills/kano-agent-backlog-skill/scripts/**`
- **Project-only** dashboards/reports live here (iteration, recent changes, team conventions)

## Canonical dashboards

Generate (and refresh) the standard dashboards via the skill scripts:

- `python skills/kano-agent-backlog-skill/scripts/backlog/view_refresh_dashboards.py --backlog-root _kano/backlog --agent <agent-name>`

## Demo: focus view (last N days / iteration)

- `python _kano/backlog/tools/generate_focus_view.py --backlog-root _kano/backlog --days 14 --agent <agent-name>`
- `python _kano/backlog/tools/generate_focus_view.py --backlog-root _kano/backlog --iteration \"Sprint 1\" --agent <agent-name>`

The tool prefers SQLite index when enabled/available, otherwise falls back to scanning files.

## Demo: DBIndex vs NoDBIndex dashboards

Run the demo generator from the skill scripts:
- `python skills/kano-agent-backlog-skill/scripts/backlog/view_generate_demo.py --backlog-root _kano/backlog --agent <agent-name>`

Outputs:
- `_kano/backlog/views/_demo/Dashboard_Demo_DBIndex_{Active,New,Done}.md`
- `_kano/backlog/views/_demo/Dashboard_Demo_NoDBIndex_{Active,New,Done}.md`
- `_kano/backlog/views/_demo/Dashboard_Demo_*_Tags_Versioning.md`
