# Dashboard (Plain Markdown)

This is the "no plugin" dashboard: pure Markdown links that work in any editor and render in Obsidian without Dataview/Bases.

## Generated views

- Active work: `Dashboard_PlainMarkdown_Active.md` (New + InProgress)
- New work: `Dashboard_PlainMarkdown_New.md` (New only)
- Done work: `Dashboard_PlainMarkdown_Done.md` (Done + Dropped)

![[Dashboard_PlainMarkdown_Active.md]]

![[Dashboard_PlainMarkdown_New.md]]

![[Dashboard_PlainMarkdown_Done.md]]


To refresh:
- Recommended (refresh all standard dashboards; uses SQLite index when available, otherwise scans files):
- `python skills/kano-agent-backlog-skill/scripts/backlog/view_refresh_dashboards.py --backlog-root _kano/backlog --agent <agent-name>`

- Or generate a single dashboard file:
  - `python skills/kano-agent-backlog-skill/scripts/backlog/view_generate.py --source auto --groups "New,InProgress" --title "InProgress Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Active.md`
  - `python skills/kano-agent-backlog-skill/scripts/backlog/view_generate.py --source auto --groups "New" --title "New Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_New.md`
  - `python skills/kano-agent-backlog-skill/scripts/backlog/view_generate.py --source auto --groups "Done" --title "Done Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Done.md`

## Demo: DBIndex vs NoDBIndex

If you want explicit filenames for the data source, generate both variants:
- (preferred) `python skills/kano-agent-backlog-skill/scripts/backlog/view_generate_demo.py --backlog-root _kano/backlog --agent <agent-name>`
- (demo repo wrapper) `python _kano/backlog/tools/view_generate_demo.py --backlog-root _kano/backlog --agent <agent-name>`

Outputs:
- DBIndex (forced SQLite): `views/_demo/Dashboard_Demo_DBIndex_{Active,New,Done}.md`
- NoDBIndex (forced file scan): `views/_demo/Dashboard_Demo_NoDBIndex_{Active,New,Done}.md`

## Browse by type (folders)

- Epics: `../items/epics/`
- Features: `../items/features/`
- UserStories: `../items/userstories/`
- Tasks: `../items/tasks/`
- Bugs: `../items/bugs/`

## Decisions (ADRs)

- ADRs: `../decisions/`

For hierarchy navigation, open an Epic MOC file (`*.index.md`) under `../items/epics/**/`.
