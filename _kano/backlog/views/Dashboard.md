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

### Canonical generated dashboards (recommended)

- `python skills/kano-agent-backlog-skill/scripts/backlog/view_refresh_dashboards.py --backlog-root _kano/backlog --agent <agent-name>`

This uses `--source auto` by default:
- prefers SQLite when `index.enabled=true` and the DB exists
- otherwise falls back to scanning files

Outputs (canonical):
- `Dashboard_PlainMarkdown_Active.md` (New + InProgress)
- `Dashboard_PlainMarkdown_New.md` (New only)
- `Dashboard_PlainMarkdown_Done.md` (Done + Dropped)

### Demo dashboards: DBIndex vs NoDBIndex

To make the data source explicit in the filename, generate both variants under `views/_demo/`:

- (preferred) `python skills/kano-agent-backlog-skill/scripts/backlog/view_generate_demo.py --backlog-root _kano/backlog --agent <agent-name>`
- (demo repo wrapper) `python _kano/backlog/tools/view_generate_demo.py --backlog-root _kano/backlog --agent <agent-name>`

Outputs (demo):
- DBIndex (forced SQLite): `views/_demo/Dashboard_Demo_DBIndex_{Active,New,Done}.md`
- NoDBIndex (forced file scan): `views/_demo/Dashboard_Demo_NoDBIndex_{Active,New,Done}.md`

Tag-based demo views (via DB query or file scan):
- DBIndex: `views/_demo/Dashboard_Demo_DBIndex_Tags_Versioning.md`
- NoDBIndex: `views/_demo/Dashboard_Demo_NoDBIndex_Tags_Versioning.md`

### Project-specific dashboards (tools)

Keep project-only dashboards under `_kano/backlog/tools/` (e.g. iteration-based or "last 2 weeks" lists).
They should call the skill scripts and follow the same source selection rule:
- use SQLite index when available
- otherwise fall back to scanning files

Example (demo tool):
- `python _kano/backlog/tools/generate_focus_view.py --backlog-root _kano/backlog --days 14 --agent <agent-name> --output _kano/backlog/views/_demo/Dashboard_Demo_Focus_Last14Days.md`
