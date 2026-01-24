# Backlog Tools (project-specific)

This folder contains **project-specific** helper scripts for `_kano/backlog/`.

Principle:
- **Generic** backlog workflows live in the skill: call `python skills/kano-agent-backlog-skill/scripts/kano-backlog <command>`
- **Project-only** dashboards/reports live here (iteration, recent changes, team conventions)

## Canonical dashboards

Generate (and refresh) the standard dashboards via the CLI:

- `python skills/kano-agent-backlog-skill/scripts/kano-backlog view refresh --backlog-root _kano/backlog --agent <agent-name> --product <product-name>`

## 🚧 WIP: Demo focus view (last N days / iteration)

**Status**: Partially implemented, may not work reliably

- `python _kano/backlog/tools/generate_focus_view.py --backlog-root _kano/backlog --days 14 --agent <agent-name>`
- `python _kano/backlog/tools/generate_focus_view.py --backlog-root _kano/backlog --iteration \"Sprint 1\" --agent <agent-name>`

The tool prefers SQLite index when enabled/available, otherwise falls back to scanning files.

## 🚧 WIP: Demo DBIndex vs NoDBIndex dashboards

**Status**: Experimental, interfaces may change

The legacy demo generator script has been removed. Re-introduce it as a `kano-backlog view demo ...` subcommand (TBD) before relying on it again.

Outputs:
- `_kano/backlog/products/<product-name>/views/_demo/Dashboard_Demo_DBIndex_{Active,New,Done}.md`
- `_kano/backlog/products/<product-name>/views/_demo/Dashboard_Demo_NoDBIndex_{Active,New,Done}.md`
- `_kano/backlog/products/<product-name>/views/_demo/Dashboard_Demo_*_Tags_Versioning.md`
