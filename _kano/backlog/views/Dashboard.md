# Dashboard (Demo index)

This folder demos three ways to view the same local-first backlog data under `_kano/backlog/items/**`.

## 1) Obsidian Dataview (plugin)

- File: `Dashboard_ObsidianDataview.md`
- Requires: Dataview plugin
- Best for: rich queries, “table per section” dashboards

## 2) Obsidian Bases (core feature, no plugin)

- File: `Dashboard_ObsidianBase.base`
- Requires: Obsidian Bases (core feature)
- Best for: table-style browsing/filtering without extra plugins

## 3) Plain Markdown (no plugin)

- File: `Dashboard_PlainMarkdown.md`
- Requires: none
- Best for: shareable, deterministic views (can be generated in CI)

Refresh the plain Markdown views:
- `python skills/kano-agent-backlog-skill/scripts/backlog/generate_view.py --groups "New,InProgress" --title "InProgress Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Active.md`
- `python skills/kano-agent-backlog-skill/scripts/backlog/generate_view.py --groups "New" --title "New Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_New.md`
- `python skills/kano-agent-backlog-skill/scripts/backlog/generate_view.py --groups "Done" --title "Done Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Done.md`
