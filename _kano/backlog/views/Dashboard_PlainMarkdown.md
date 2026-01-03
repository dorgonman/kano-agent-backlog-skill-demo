# Dashboard (Plain Markdown)

This is the “no plugin” dashboard: pure Markdown links that work in any editor and render in Obsidian without Dataview/Bases.

## Generated views

- Active work: `Dashboard_PlainMarkdown_Active.md` (New + InProgress)
- New work: `Dashboard_PlainMarkdown_New.md` (New only)
- Done work: `Dashboard_PlainMarkdown_Done.md` (Done + Dropped)

To refresh:
- `python _kano/backlog/tools/generate_view.py --groups "New,InProgress" --title "Active Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Active.md`
- `python _kano/backlog/tools/generate_view.py --groups "New" --title "New Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_New.md`
- `python _kano/backlog/tools/generate_view.py --groups "Done" --title "Done Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Done.md`

## Browse by type (folders)

- Epics: `../items/epics/`
- Features: `../items/features/`
- UserStories: `../items/userstories/`
- Tasks: `../items/tasks/`
- Bugs: `../items/bugs/`

## Decisions (ADRs)

- ADRs: `../decisions/`

For hierarchy navigation, open an Epic MOC file (`*.index.md`) under `../items/epics/**/`.
