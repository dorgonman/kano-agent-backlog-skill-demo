# Dashboard (Plain Markdown)

This is the “no plugin” dashboard: pure Markdown links that work in any editor and render in Obsidian without Dataview/Bases.

## Generated views

- InProgress work: `Dashboard_PlainMarkdown_Active.md` (New + InProgress/Review/Blocked)
- New work: `Dashboard_PlainMarkdown_New.md` (New only)
- Done work: `Dashboard_PlainMarkdown_Done.md` (Done + Dropped)

![[Dashboard_PlainMarkdown_Active.md]]

![[Dashboard_PlainMarkdown_New.md]]

![[Dashboard_PlainMarkdown_Done.md]]


To refresh:
- `python skills/kano-agent-backlog-skill/scripts/backlog/generate_view.py --groups "New,InProgress" --title "InProgress Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Active.md`
- `python skills/kano-agent-backlog-skill/scripts/backlog/generate_view.py --groups "New" --title "New Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_New.md`
- `python skills/kano-agent-backlog-skill/scripts/backlog/generate_view.py --groups "Done" --title "Done Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Done.md`

## Browse by type (folders)

- Epics: `../items/epics/`
- Features: `../items/features/`
- UserStories: `../items/userstories/`
- Tasks: `../items/tasks/`
- Bugs: `../items/bugs/`

## Decisions (ADRs)

- ADRs: `../decisions/`

For hierarchy navigation, open an Epic MOC file (`*.index.md`) under `../items/epics/**/`.


