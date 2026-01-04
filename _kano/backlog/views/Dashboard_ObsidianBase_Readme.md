# Dashboard (Obsidian Bases)

This is a plugin-free dashboard recipe using Obsidian **Bases** (core feature).

Goal: cover the same "table-style" dashboard use cases as Dataview, while keeping:
- Items in `_kano/backlog/items/**`
- Decisions in `_kano/backlog/decisions/**`
- Tree navigation via Epic `.index.md` MOC files + wikilinks (Bases is not a tree renderer)

## Files in this demo

- `_kano/backlog/views/Dashboard_ObsidianBase.base`: a multi-view Base config that mirrors the Dataview dashboard sections.
- `_kano/backlog/views/Dashboard_ObsidianBase_Readme.md`: usage notes + view mappings.

## Prereqs

- Obsidian version that includes Bases.
- Your items use frontmatter fields like: `id`, `type`, `title`, `state`, `priority`, `parent`, `area`, `iteration`, `created`, `updated`.

## How to use the .base file

1) Open `_kano/backlog/views/Dashboard_ObsidianBase.base` in Obsidian.
2) Confirm the source folder is `_kano/backlog/items` (Obsidian may prompt you on first open).
3) Switch between views in the left panel.
4) If your Obsidian version expects different filter operator names, re-create the filters in the UI using the same logic below.

## View mapping (for the demo)

- New Work: `Proposed`, `Planned`, `Ready`
- InProgress Work: `InProgress`, `Review`, `Blocked`
- Done Work: `Done`, `Dropped`
- Epics/Features/UserStories/Tasks + Bugs: hide `Done` and `Dropped`
- Ready + InProgress: `Ready`, `InProgress`
- Blocked: `Blocked`

## Recommended approach

Bases currently works best as "one Base per table". This demo keeps a single `.base` file with multiple views for convenience. If you prefer, you can split each view into its own Base and keep the same filters.

Common Base settings (for all sections):
- Source folder: `_kano/backlog/items`
- Columns: `file.link`, `id`, `type`, `title`, `state`, `priority`, `parent`, `area`, `iteration`, `updated`
- Default sorting: `priority` asc (or `created` asc for Epics)

### Base: Epics

Filter:
- `type` equals `Epic`
- `state` is not `Done`
- `state` is not `Dropped`

Sort:
- `created` asc

### Base: Features

Filter:
- `type` equals `Feature`
- `state` is not `Done`
- `state` is not `Dropped`

Sort:
- `priority` asc

### Base: UserStories

Filter:
- `type` equals `UserStory`
- `state` is not `Done`
- `state` is not `Dropped`

Sort:
- `priority` asc

### Base: Tasks + Bugs

Filter:
- `type` is one of `Task`, `Bug`
- `state` is not `Done`
- `state` is not `Dropped`

Sort:
- `type` asc, then `priority` asc

### Base: Ready + InProgress

Filter:
- `state` is one of `Ready`, `InProgress`

Sort:
- `type` asc, then `priority` asc

### Base: Blocked

Filter:
- `state` equals `Blocked`

Sort:
- `priority` asc

## Notes

- If nested filters are not supported in your Bases version (e.g. `Tasks + Bugs`), split it into two views: `Tasks` and `Bugs`.
- If you want a zero-UI, shareable artifact, use the generator:
  - `python skills/kano-agent-backlog-skill/scripts/backlog/generate_view.py --groups "New,InProgress" --title "InProgress Work" --output _kano/backlog/views/Dashboard_PlainMarkdown_Active.md`
- For hierarchy browsing, use the Epic MOC:
  - `_kano/backlog/items/epics/**/<ID>_<slug>.index.md`
