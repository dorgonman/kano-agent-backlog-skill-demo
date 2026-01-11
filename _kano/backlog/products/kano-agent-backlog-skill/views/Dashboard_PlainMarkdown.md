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
- Run the CLI (auto-selects SQLite vs file scan):
  - `python skills/kano-agent-backlog-skill/scripts/kano view refresh --backlog-root _kano/backlog --agent <agent-name>`

- Single-dashboard generation now routes through the same CLI; per-group switches will return in a future subcommand.

## Demo: DBIndex vs NoDBIndex

If you want explicit filenames for the data source, regenerate the demo set once the `kano view demo ...` subcommand ships, or keep using `_kano/backlog/tools/view_generate_demo.py` as an interim wrapper.

## Browse by type (folders)

- Epics: `../items/epic/`
- Features: `../items/feature/`
- UserStories: `../items/userstory/`
- Tasks: `../items/task/`
- Bugs: `../items/bug/`

## Decisions (ADRs)

- ADRs: `../decisions/`

For hierarchy navigation, open an Epic MOC file (`*.index.md`) under `../items/epic/**/`.
