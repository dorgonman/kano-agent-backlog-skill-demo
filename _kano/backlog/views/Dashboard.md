# Dashboard (Demo index)

This folder demos three ways to view the same local-first backlog data under `_kano/backlog/items/**`.

Optional: maintain a derived SQLite index under `_kano/backlog/_index/backlog.sqlite3` to speed up queries and
enable faster dashboard generation. The Markdown files remain the source of truth.

## 1) Obsidian Dataview (plugin)

- File: `Dashboard_ObsidianDataview.md`
- Requires: Dataview plugin
- Best for: rich queries, “table per section” dashboards

## 2) Obsidian Bases (core feature, no plugin)

- Files: `Dashboard_ObsidianBase.base`, `Dashboard_ObsidianBase_Readme.md`
- Requires: Obsidian Bases (core feature)
- Best for: table-style browsing/filtering without extra plugins

## 3) Plain Markdown (no plugin)

- File: `Dashboard_PlainMarkdown.md`
- Requires: none
- Best for: shareable, deterministic views (can be generated in CI)

Refresh the generated Markdown dashboards (recommended):

- `python skills/kano-agent-backlog-skill/scripts/backlog/refresh_dashboards.py --backlog-root _kano/backlog --agent <agent-name>`

This uses `--source auto` by default:
- prefers SQLite when `index.enabled=true` and the DB exists
- otherwise falls back to scanning files
